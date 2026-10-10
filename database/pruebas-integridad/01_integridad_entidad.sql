
-- PRUEBAS DE INTEGRIDAD DE ENTIDAD (sección 5.1 del enunciado)

-- Todas las pruebas de este archivo DEBEN FALLAR: el error es el resultado esperado.
\set ON_ERROR_STOP off
\pset pager off

\echo
\echo '=== 5.1-A | PK duplicada en ORGANIZADOR (id_organizador = 1 ya existe) ==='
\echo 'Esperado: ERROR por pk_organizador'
INSERT INTO organizador (id_organizador, nombre, apellido, correo)
VALUES (1, 'Prueba', 'Duplicada', 'duplicada@institucion.edu.gt');

\echo
\echo '=== 5.1-B | PK nula en ORGANIZADOR ==='
\echo 'Esperado: ERROR not-null en id_organizador'
INSERT INTO organizador (id_organizador, nombre, apellido, correo)
VALUES (NULL, 'Prueba', 'SinClave', 'sinclave@institucion.edu.gt');

\echo
\echo '=== 5.1-C | PK compuesta duplicada: el mismo recurso dos veces en un evento ==='
\echo 'Esperado: ERROR por pk_evento_recurso'
INSERT INTO evento_recurso (id_evento, id_recurso, cantidad)
VALUES (
    (SELECT id_evento  FROM evento  WHERE nombre = 'Capacitación de Seguridad'),
    (SELECT id_recurso FROM recurso WHERE nombre = 'Proyector'),
    5
);

\echo
\echo '=== 5.1-D | Clave candidata duplicada: correo de organizador repetido ==='
\echo 'Esperado: ERROR por uq_organizador_correo'
INSERT INTO organizador (nombre, apellido, correo)
VALUES ('Otra', 'Persona', 'mlopez@institucion.edu.gt');

\echo
\echo '=== 5.1-E | Clave candidata duplicada: tipo de evento repetido ==='
\echo 'Esperado: ERROR por uq_tipo_evento_nombre'
INSERT INTO tipo_evento (nombre) VALUES ('Taller');

\echo
\echo '=== 5.1-F | Clave candidata duplicada: recurso repetido ==='
\echo 'Esperado: ERROR por uq_recurso_nombre'
INSERT INTO recurso (nombre, cantidad_total) VALUES ('Sillas', 10);

\echo
\echo '--- Conteos tras las pruebas (deben seguir en 10 / 5 / 6 / 10 / 10 / 30) ---'
SELECT (SELECT COUNT(*) FROM organizador)    AS organizador,
       (SELECT COUNT(*) FROM tipo_evento)    AS tipo_evento,
       (SELECT COUNT(*) FROM ubicacion)      AS ubicacion,
       (SELECT COUNT(*) FROM recurso)        AS recurso,
       (SELECT COUNT(*) FROM evento)         AS evento,
       (SELECT COUNT(*) FROM evento_recurso) AS evento_recurso;
