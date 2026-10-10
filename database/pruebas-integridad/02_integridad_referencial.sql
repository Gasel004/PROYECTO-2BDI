-- PRUEBAS DE INTEGRIDAD REFERENCIAL (sección 5.2 del enunciado)
-- Las FK garantizan que las relaciones entre tablas sean válidas
-- Parte 1 (A-J): deben FALLAR.
-- Parte 2 (K-N): operaciones PERMITIDAS. Se hacen dentro de una
--                transacción con ROLLBACK para no perder los datos de prueba
\set ON_ERROR_STOP off
\pset pager off

\echo
\echo '########## PARTE 1: DEBEN FALLAR ##########'

\echo
\echo '=== 5.2-A | Evento con organizador inexistente (caso del enunciado) ==='
\echo 'Esperado: ERROR por fk_evento_organizador'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Evento huérfano', '2026-12-10', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        999,
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.2-B | Evento con tipo de evento inexistente ==='
\echo 'Esperado: ERROR por fk_evento_tipo_evento'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Evento sin tipo', '2026-12-10', '09:00', 'Programado',
        999,
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        (SELECT id_ubicacion FROM ubicacion WHERE nombre = 'Sala de Juntas'));

\echo
\echo '=== 5.2-C | Evento con ubicación inexistente ==='
\echo 'Esperado: ERROR por fk_evento_ubicacion'
INSERT INTO evento (nombre, fecha, hora_inicio, estado, id_tipo_evento, id_organizador, id_ubicacion)
VALUES ('Evento sin lugar', '2026-12-10', '09:00', 'Programado',
        (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = 'Taller'),
        (SELECT id_organizador FROM organizador WHERE correo = 'mlopez@institucion.edu.gt'),
        999);

\echo
\echo '=== 5.2-D | Detalle de un evento inexistente ==='
\echo 'Esperado: ERROR por fk_evento_recurso_evento'
INSERT INTO evento_recurso (id_evento, id_recurso, cantidad)
VALUES (999, (SELECT id_recurso FROM recurso WHERE nombre = 'Proyector'), 1);

\echo
\echo '=== 5.2-E | Detalle de un recurso inexistente ==='
\echo 'Esperado: ERROR por fk_evento_recurso_recurso'
INSERT INTO evento_recurso (id_evento, id_recurso, cantidad)
VALUES ((SELECT id_evento FROM evento WHERE nombre = 'Taller de Oratoria'), 999, 1);

\echo
\echo '=== 5.2-F | Borrar un organizador que tiene eventos (ON DELETE RESTRICT) ==='
\echo 'Esperado: ERROR por fk_evento_organizador'
DELETE FROM organizador WHERE correo = 'mlopez@institucion.edu.gt';

\echo
\echo '=== 5.2-G | Borrar un tipo de evento en uso (ON DELETE RESTRICT) ==='
\echo 'Esperado: ERROR por fk_evento_tipo_evento'
DELETE FROM tipo_evento WHERE nombre = 'Taller';

\echo
\echo '=== 5.2-H | Borrar una ubicación en uso (ON DELETE RESTRICT) ==='
\echo 'Esperado: ERROR por fk_evento_ubicacion'
DELETE FROM ubicacion WHERE nombre = 'Auditorio Principal';

\echo
\echo '=== 5.2-I | Borrar un recurso que está siendo utilizado (ON DELETE RESTRICT) ==='
\echo 'Esperado: ERROR por fk_evento_recurso_recurso'
DELETE FROM recurso WHERE nombre = 'Proyector';

\echo
\echo '=== 5.2-J | Cambiar la PK de un organizador referenciado (ON UPDATE sin acción) ==='
\echo 'Esperado: ERROR por fk_evento_organizador'
UPDATE organizador SET id_organizador = 999 WHERE correo = 'mlopez@institucion.edu.gt';

\echo
\echo '########## PARTE 2: OPERACIONES PERMITIDAS (con ROLLBACK) ##########'

\echo
\echo '=== 5.2-K | Borrar un recurso que NO está en uso (Extensión eléctrica) ==='
\echo 'Esperado: DELETE 1'
BEGIN;
DELETE FROM recurso WHERE nombre = 'Extensión eléctrica';
ROLLBACK;

\echo
\echo '=== 5.2-L | Borrar un organizador que NO tiene eventos (Gabriela Cifuentes) ==='
\echo 'Esperado: DELETE 1'
BEGIN;
DELETE FROM organizador WHERE correo = 'gcifuentes@institucion.edu.gt';
ROLLBACK;

\echo
\echo '=== 5.2-M | Eliminar un detalle de evento (Pantalla de la Capacitación de Seguridad) ==='
\echo 'Esperado: DELETE 1'
BEGIN;
DELETE FROM evento_recurso
WHERE id_evento  = (SELECT id_evento  FROM evento  WHERE nombre = 'Capacitación de Seguridad')
  AND id_recurso = (SELECT id_recurso FROM recurso WHERE nombre = 'Pantalla de proyección');
ROLLBACK;

\echo
\echo '=== 5.2-N | Eliminar un evento con detalles (ON DELETE CASCADE) ==='
\echo 'Esperado: detalles_antes = 5, detalles_despues = 0, detalles_tras_rollback = 5'
BEGIN;
SELECT id_evento AS id_prueba FROM evento WHERE nombre = 'Capacitación de Seguridad' \gset
SELECT COUNT(*) AS detalles_antes FROM evento_recurso WHERE id_evento = :id_prueba;
DELETE FROM evento WHERE id_evento = :id_prueba;
SELECT COUNT(*) AS detalles_despues FROM evento_recurso WHERE id_evento = :id_prueba;
ROLLBACK;
SELECT COUNT(*) AS detalles_tras_rollback FROM evento_recurso WHERE id_evento = :id_prueba;

\echo
\echo '--- Conteos tras las pruebas (deben seguir en 10 / 5 / 6 / 10 / 10 / 30) ---'
SELECT (SELECT COUNT(*) FROM organizador)    AS organizador,
       (SELECT COUNT(*) FROM tipo_evento)    AS tipo_evento,
       (SELECT COUNT(*) FROM ubicacion)      AS ubicacion,
       (SELECT COUNT(*) FROM recurso)        AS recurso,
       (SELECT COUNT(*) FROM evento)         AS evento,
       (SELECT COUNT(*) FROM evento_recurso) AS evento_recurso;
