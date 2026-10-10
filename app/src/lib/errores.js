// Traduce los errores de PostgreSQL a un mensaje para la interfaz.
//
// Además del resumen amigable se devuelve el detalle técnico (mensaje y
// nombre de la restricción) a propósito: sirve para demostrar en el video
// que la integridad de los datos la hace cumplir la base de datos.
// En un sistema real ese detalle no se mostraría al usuario final.

const RESUMENES = {
  '23505': 'Ya existe un registro con ese valor, que debe ser único.',
  '23503': 'La operación rompe una relación con otra tabla (clave foránea).',
  '23502': 'Falta un campo obligatorio.',
  '23514': 'El valor no cumple una regla de validación.',
  '22001': 'El texto es demasiado largo para el campo.',
  '22007': 'La fecha u hora no tiene un formato válido.',
  '22008': 'La fecha u hora está fuera de rango.',
  '22P02': 'Un valor no tiene el formato esperado.',
};

// Un SQLSTATE de PostgreSQL tiene siempre 5 caracteres (por ejemplo 23505).
const esErrorDeBaseDeDatos = (codigo) =>
  typeof codigo === 'string' && /^[0-9A-Z]{5}$/.test(codigo);

export function describirError(err) {
  const codigo = err?.code;
  const resumen = esErrorDeBaseDeDatos(codigo)
    ? (RESUMENES[codigo] ?? 'La base de datos rechazó la operación.')
    : 'No se pudo completar la operación (error inesperado).';

  const tecnico = [
    err?.message,
    err?.detail,
    err?.constraint ? `Restricción: ${err.constraint}` : null,
  ]
    .filter(Boolean)
    .join('\n');

  return { resumen, tecnico, codigo };
}
