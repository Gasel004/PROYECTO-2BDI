import { withTransaction } from './db.js';

export function leerCantidadesRecursos(datos) {
  const cantidades = [];
  for (const [campo, valor] of datos.entries()) {
    if (!campo.startsWith('recurso_')) continue;
    const idRecurso = Number(campo.slice('recurso_'.length));
    if (!Number.isSafeInteger(idRecurso) || idRecurso <= 0 || typeof valor !== 'string') {
      throw new Error('Uno de los recursos enviados no es válido.');
    }
    const cantidadTexto = valor.trim();
    if (!cantidadTexto) continue;
    if (!/^\d+$/.test(cantidadTexto)) {
      throw new Error('La cantidad de cada recurso debe ser un número entero igual o mayor que cero.');
    }
    const cantidad = Number(cantidadTexto);
    if (!Number.isSafeInteger(cantidad)) throw new Error('La cantidad de un recurso excede el límite permitido.');
    if (cantidad > 0) cantidades.push({ idRecurso, cantidad });
  }
  return cantidades;
}

export async function guardarEvento({ id = null, valores, cantidades }) {
  return withTransaction(async (tx) => {
    let asignadosAntes = [];
    let idEvento = id;

    if (idEvento) {
      const anterior = await tx('SELECT id_recurso FROM evento_recurso WHERE id_evento = $1', [idEvento]);
      asignadosAntes = anterior.rows.map((fila) => Number(fila.id_recurso));
      const actualizado = await tx(
        `UPDATE evento
         SET nombre = $1, descripcion = $2, fecha = $3, hora_inicio = $4, hora_fin = $5,
             estado = $6, id_tipo_evento = $7, id_organizador = $8, id_ubicacion = $9
         WHERE id_evento = $10`,
        [valores.nombre, valores.descripcion, valores.fecha, valores.hora_inicio, valores.hora_fin,
          valores.estado, valores.id_tipo_evento, valores.id_organizador, valores.id_ubicacion, idEvento],
      );
      if (!actualizado.rowCount) {
        const error = new Error('El evento ya no existe.');
        error.userMessage = true;
        throw error;
      }
    } else {
      const creado = await tx(
        `INSERT INTO evento
          (nombre, descripcion, fecha, hora_inicio, hora_fin, estado, id_tipo_evento, id_organizador, id_ubicacion)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
         RETURNING id_evento`,
        [valores.nombre, valores.descripcion, valores.fecha, valores.hora_inicio, valores.hora_fin,
          valores.estado, valores.id_tipo_evento, valores.id_organizador, valores.id_ubicacion],
      );
      idEvento = Number(creado.rows[0].id_evento);
    }

    if (cantidades.length && valores.estado !== 'Cancelado') {
      const ids = cantidades.map((fila) => fila.idRecurso).sort((a, b) => a - b);
      const recursos = await tx(
        `SELECT id_recurso, nombre, disponible, cantidad_total
         FROM recurso WHERE id_recurso = ANY($1::integer[])
         ORDER BY id_recurso FOR UPDATE`,
        [ids],
      );
      const porId = new Map(recursos.rows.map((fila) => [Number(fila.id_recurso), fila]));
      for (const fila of cantidades) {
        const recurso = porId.get(fila.idRecurso);
        if (!recurso) {
          const error = new Error('Uno de los recursos seleccionados ya no existe.');
          error.userMessage = true;
          throw error;
        }
        if (!recurso.disponible && !asignadosAntes.includes(fila.idRecurso)) {
          const error = new Error(`${recurso.nombre} está fuera de servicio y no se puede agregar a un evento activo.`);
          error.userMessage = true;
          throw error;
        }
        const comprometido = await tx(
          `SELECT COALESCE(SUM(er.cantidad), 0)::int AS cantidad
           FROM evento_recurso er JOIN evento e ON e.id_evento = er.id_evento
           WHERE er.id_recurso = $1 AND e.fecha = $2 AND e.estado <> 'Cancelado'
             AND e.id_evento <> $3`,
          [fila.idRecurso, valores.fecha, idEvento],
        );
        const disponible = Number(recurso.cantidad_total) - Number(comprometido.rows[0].cantidad);
        if (fila.cantidad > disponible) {
          const error = new Error(`Para ${recurso.nombre} quedan ${Math.max(0, disponible)} unidades disponibles en esa fecha.`);
          error.userMessage = true;
          throw error;
        }
      }
    }

    if (id) await tx('DELETE FROM evento_recurso WHERE id_evento = $1', [idEvento]);
    for (const fila of cantidades) {
      await tx(
        'INSERT INTO evento_recurso (id_evento, id_recurso, cantidad) VALUES ($1, $2, $3)',
        [idEvento, fila.idRecurso, fila.cantidad],
      );
    }
    return idEvento;
  });
}
