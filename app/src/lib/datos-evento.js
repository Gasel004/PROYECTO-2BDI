import { query } from './db.js';
import { fechaISOValida } from './validaciones.js';

export async function cargarCatalogosEvento(fecha = null, idEvento = null) {
  const [tipos, organizadores, ubicaciones, recursos] = await Promise.all([
    query('SELECT id_tipo_evento, nombre FROM tipo_evento ORDER BY nombre'),
    query('SELECT id_organizador, nombre, apellido FROM organizador ORDER BY apellido, nombre'),
    query('SELECT id_ubicacion, nombre, capacidad FROM ubicacion ORDER BY nombre'),
    query(
      `SELECT r.id_recurso, r.nombre, r.descripcion, r.cantidad_total, r.disponible,
              COALESCE((
                SELECT SUM(er.cantidad)
                FROM evento_recurso er JOIN evento e ON e.id_evento = er.id_evento
                WHERE er.id_recurso = r.id_recurso AND e.fecha = $1::date
                  AND e.estado <> 'Cancelado'
                  AND ($2::integer IS NULL OR e.id_evento <> $2)
              ), 0)::int AS comprometidos
       FROM recurso r ORDER BY r.nombre`,
      [fechaISOValida(fecha) ? fecha : null, idEvento],
    ),
  ]);
  return {
    tipos: tipos.rows,
    organizadores: organizadores.rows,
    ubicaciones: ubicaciones.rows,
    recursos: recursos.rows,
  };
}
