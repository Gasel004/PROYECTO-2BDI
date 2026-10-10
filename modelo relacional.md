ORGANIZADOR (id_organizador, nombre, apellido, correo, telefono, cargo)
TIPO_EVENTO (id_tipo_evento, nombre, descripcion)
UBICACION (id_ubicacion, nombre, direccion, capacidad)
RECURSO (id_recurso, nombre, descripcion, cantidad_total, disponible)
EVENTO (id_evento, nombre, descripcion, fecha, hora_inicio, hora_fin, estado, id_tipo_evento → TIPO_EVENTO, id_organizador → ORGANIZADOR, id_ubicacion → UBICACION)
EVENTO_RECURSO (id_evento → EVENTO, id_recurso → RECURSO, cantidad)


Integridad de entidad

Cada tabla tiene PK y el motor garantiza que no se repita ni sea NULL. Las 5 tablas de clave simple usan SERIAL; EVENTO_RECURSO usa la clave compuesta (id_evento, id_recurso), que además impide registrar el mismo recurso dos veces en un evento.

Hay también claves candidatas con UNIQUE: ORGANIZADOR.correo, y nombre en TIPO_EVENTO, UBICACION y RECURSO.

Integridad referencial

FK	Referencia	ON DELETE	Justificación
EVENTO.id_organizador	ORGANIZADOR	RESTRICT	No se borra un organizador que tiene eventos
EVENTO.id_tipo_evento	TIPO_EVENTO	RESTRICT	No se borra un tipo en uso
EVENTO.id_ubicacion	UBICACION	RESTRICT	No se borra una ubicación en uso
EVENTO_RECURSO.id_recurso	RECURSO	RESTRICT	El PDF pide eliminar solo “un recurso que no esté siendo utilizado”
EVENTO_RECURSO.id_evento	EVENTO	CASCADE (por cascade)	s


El detalle no tiene sentido sin su maestro, es la relación de composición típica del maestro-detalle.

Integridad de dominio

Tabla.columna	Restricción
ORGANIZADOR.nombre, apellido, correo	NOT NULL (correo además UNIQUE)
TIPO_EVENTO.nombre	NOT NULL, UNIQUE
UBICACION.nombre, direccion	NOT NULL (nombre además UNIQUE)
UBICACION.capacidad	NOT NULL, CHECK (capacidad > 0)
RECURSO.nombre	NOT NULL, UNIQUE
RECURSO.cantidad_total	NOT NULL, CHECK (cantidad_total > 0)
RECURSO.disponible	NOT NULL, DEFAULT TRUE
EVENTO.nombre, fecha, hora_inicio	NOT NULL
EVENTO.fecha	Tipo DATE: PostgreSQL rechaza fechas imposibles (por ejemplo 2026-02-30)
EVENTO.hora_fin	CHECK (hora_fin > hora_inicio); permite NULL
EVENTO.estado	NOT NULL, CHECK IN (‘Programado’, ‘En curso’, ‘Finalizado’, ‘Cancelado’)
EVENTO.id_tipo_evento, id_organizador, id_ubicacion	NOT NULL
EVENTO_RECURSO.cantidad	NOT NULL, CHECK (cantidad > 0)
