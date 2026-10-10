
-- PRUEBAS DE INTEGRIDAD DE DOMINIO (sección 5.3 del enunciado)
-- Los campos aceptan solo valores válidos según su naturaleza.
-- Parte 1 (A-L): deben FALLAR.
-- Parte 2 (M-N): casos PERMITIDOS, dentro de transacción con ROLLBACK
\set ON_ERROR_STOP off
\pset pager off

\echo
\echo '########## PARTE 1: DEBEN FALLAR ##########'

\echo
\echo '=== 5.3-A | Estado de evento no permitido ==='
\echo 'Esperado: ERROR por ck_evento_estado'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba estado', '2026-12-10', '09:00', 'Pendiente',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-B | Estado nulo (campo obligatorio) ==='
\echo 'Esperado: ERROR not-null en estado'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba estado nulo', '2026-12-10', '09:00', NULL,
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-C | Fecha imposible (30 de febrero) ==='
\echo 'Esperado: ERROR date/time field value out of range'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba fecha', '2026-02-30', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-D | Fecha con formato inválido ==='
\echo 'Esperado: ERROR invalid input syntax for type date'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba fecha texto', 'mañana', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-E | Hora de fin anterior a la hora de inicio ==='
\echo 'Esperado: ERROR por ck_evento_horas'
INSERT INTO evento (nombre, fecha, hora_inicio, hora_fin, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba horas', '2026-12-10', '10:00', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-F | Nombre de evento nulo (campo obligatorio) ==='
\echo 'Esperado: ERROR not-null en nombre'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES (NULL, '2026-12-10', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-G | Fecha de evento nula (campo obligatorio) ==='
\echo 'Esperado: ERROR not-null en fecha'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba sin fecha', NULL, '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.3-H | Capacidad de ubicación igual a cero ==='
\echo 'Esperado: ERROR por ck_ubicacion_capacidad'
INSERT INTO ubicacion (nombre, direccion, capacidad) VALUES ('Sala sin cupo', 'Edificio X', 0);

\echo
\echo '=== 5.3-I | Cantidad total de recurso negativa ==='
\echo 'Esperado: ERROR por ck_recurso_cantidad'
INSERT INTO recurso (nombre, cantidad_total) VALUES ('Recurso negativo', -5);

\echo
\echo '=== 5.3-J | Cantidad en el detalle igual a cero ==='
\echo 'Esperado: ERROR por ck_evento_recurso_cantidad'
INSERT INTO evento_recurso (id_evento, id_recurso, cantidad)
VALUES ((SELECT id_evento  FROM evento  WHERE nombre = 'Taller de Oratoria'),
        (SELECT id_recurso FROM recurso WHERE nombre = 'Mesas'),
        0);

\echo
\echo '=== 5.3-K | Disponibilidad de recurso nula (campo obligatorio) ==='
\echo 'Esperado: ERROR not-null en disponible'
INSERT INTO recurso (nombre, cantidad_total, disponible) VALUES ('Recurso sin estado', 3, NULL);

\echo
\echo '=== 5.3-L | Texto más largo que el campo (nombre de tipo > 50 caracteres) ==='
\echo 'Esperado: ERROR value too long for type character varying(50)'
INSERT INTO tipo_evento (nombre)
VALUES ('Este nombre de tipo de evento es deliberadamente demasiado largo para el campo');

\echo
\echo '########## PARTE 2: CASOS PERMITIDOS (con ROLLBACK) ##########'

\echo
\echo '=== 5.3-M | Evento sin hora de fin (NULL permitido; el CHECK no falla con NULL) ==='
\echo 'Esperado: INSERT 0 1'
BEGIN;
INSERT INTO evento (nombre, fecha, hora_inicio, hora_fin, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Prueba sin hora de fin', '2026-12-10', '09:00', NULL, 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));
ROLLBACK;

\echo
\echo '=== 5.3-N | Recurso sin indicar disponibilidad (toma el DEFAULT TRUE) ==='
\echo 'Esperado: disponible = t'
BEGIN;
INSERT INTO recurso (nombre, cantidad_total) VALUES ('Recurso de prueba', 1) RETURNING nombre, disponible;
ROLLBACK;

\echo
\echo '--- Conteos tras las pruebas (deben seguir en 10 / 5 / 6 / 10 / 10 / 30) ---'
SELECT (SELECT COUNT(*) FROM organizador)    AS organizador,
       (SELECT COUNT(*) FROM tipo_evento)    AS tipo_evento,
       (SELECT COUNT(*) FROM ubicacion)      AS ubicacion,
       (SELECT COUNT(*) FROM recurso)        AS recurso,
       (SELECT COUNT(*) FROM evento)         AS evento,
       (SELECT COUNT(*) FROM evento_recurso) AS evento_recurso;
