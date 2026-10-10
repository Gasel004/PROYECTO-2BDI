// Lee un campo de texto de un FormData.
// Quita espacios sobrantes y devuelve null si queda vacío, para que un campo
// obligatorio en blanco llegue a la base como NULL y sea ella quien lo rechace
// (una cadena vacía '' sí pasaría la restricción NOT NULL).
export function texto(datos, campo) {
  const valor = datos.get(campo);
  if (typeof valor !== 'string') return null;
  const limpio = valor.trim();
  return limpio === '' ? null : limpio;
}
