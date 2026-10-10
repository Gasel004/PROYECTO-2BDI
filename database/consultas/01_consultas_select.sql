-- Consultas SELECT (sección 3.4 del enunciado)

-- Los valores de prueba se cambian en las líneas
\pset pager off

\set fecha        '2026-10-15'
\set desde        '2026-10-01'
\set hasta        '2026-10-31'
\set tipo         'Taller'
\set fecha_disp   '2026-11-05'
\set id_evento    1


\echo
\echo '=== 1. LISTADO DE EVENTOS (con tipo, organizador, ubicación y # de recursos) ==='

SELECT e.id_evento                      AS id,
       e.nombre                         AS evento,
       e.fecha,
       e.hora_inicio                    AS inicio,
       e.hora_fin                       AS fin,
       e.estado,
       t.nombre                         AS tipo,
       o.nombre || ' ' || o.apellido    AS organizador,
       u.nombre                         AS ubicacion,
       COUNT(er.id_recurso)             AS recursos
FROM evento e
JOIN tipo_evento t   ON t.id_tipo_evento = e.id_tipo_evento
JOIN organizador o   ON o.id_organizador = e.id_organizador
JOIN ubicacion u     ON u.id_ubicacion   = e.id_ubicacion
LEFT JOIN evento_recurso er ON er.id_evento = e.id_evento
GROUP BY e.id_evento, t.nombre, o.nombre, o.apellido, u.nombre
ORDER BY e.fecha, e.hora_inicio;


\echo
\echo '=== 2a. EVENTOS POR FECHA, fecha =' :fecha '==='

SELECT e.id_evento AS id, e.nombre AS evento, e.fecha, e.hora_inicio AS inicio,
       e.estado, t.nombre AS tipo, u.nombre AS ubicacion
FROM evento e
JOIN tipo_evento t ON t.id_tipo_evento = e.id_tipo_evento
JOIN ubicacion u   ON u.id_ubicacion   = e.id_ubicacion
WHERE e.fecha = :'fecha'
ORDER BY e.hora_inicio;

\echo
\echo '=== 2b. EVENTOS POR RANGO DE FECHAS, de' :desde 'a' :hasta '==='
SELECT e.id_evento AS id, e.nombre AS evento, e.fecha, e.hora_inicio AS inicio,
       e.estado, t.nombre AS tipo, u.nombre AS ubicacion
FROM evento e
JOIN tipo_evento t ON t.id_tipo_evento = e.id_tipo_evento
JOIN ubicacion u   ON u.id_ubicacion   = e.id_ubicacion
WHERE e.fecha BETWEEN :'desde' AND :'hasta'
ORDER BY e.fecha, e.hora_inicio;


\echo
\echo '=== 3a. EVENTOS POR TIPO, tipo =' :tipo '==='

SELECT e.id_evento AS id, e.nombre AS evento, e.fecha, e.hora_inicio AS inicio,
       e.estado, o.nombre || ' ' || o.apellido AS organizador, u.nombre AS ubicacion
FROM evento e
JOIN tipo_evento t ON t.id_tipo_evento = e.id_tipo_evento
JOIN organizador o ON o.id_organizador = e.id_organizador
JOIN ubicacion u   ON u.id_ubicacion   = e.id_ubicacion
WHERE t.nombre = :'tipo'
ORDER BY e.fecha, e.hora_inicio;

\echo
\echo '=== 3b. CANTIDAD DE EVENTOS POR TIPO ==='
SELECT t.nombre AS tipo, COUNT(e.id_evento) AS eventos
FROM tipo_evento t
LEFT JOIN evento e ON e.id_tipo_evento = t.id_tipo_evento
GROUP BY t.id_tipo_evento, t.nombre
ORDER BY eventos DESC, t.nombre;


\echo
\echo '=== 4a. RECURSOS DISPONIBLES (en servicio: disponible = TRUE) ==='

SELECT id_recurso AS id, nombre, descripcion, cantidad_total
FROM recurso
WHERE disponible
ORDER BY nombre;

\echo
\echo '=== 4b. DISPONIBILIDAD DE RECURSOS EN LA FECHA' :fecha_disp '==='
\echo '    (descuenta lo pedido por los eventos de ese día que no estén Cancelados)'
SELECT r.nombre,
       r.cantidad_total,
       COALESCE(c.comprometidos, 0)                   AS comprometidos,
       r.cantidad_total - COALESCE(c.comprometidos, 0) AS disponibles
FROM recurso r
LEFT JOIN (
    SELECT er.id_recurso, SUM(er.cantidad) AS comprometidos
    FROM evento_recurso er
    JOIN evento e ON e.id_evento = er.id_evento
    WHERE e.fecha = :'fecha_disp'
      AND e.estado <> 'Cancelado'
    GROUP BY er.id_recurso
) c ON c.id_recurso = r.id_recurso
WHERE r.disponible
ORDER BY r.nombre;


\echo
\echo '=== 5. MAESTRO-DETALLE: evento con id =' :id_evento '==='

\echo '--- Maestro ---'
SELECT e.id_evento AS id, e.nombre AS evento, e.fecha, e.hora_inicio AS inicio,
       e.hora_fin AS fin, e.estado, t.nombre AS tipo,
       o.nombre || ' ' || o.apellido AS organizador, u.nombre AS ubicacion
FROM evento e
JOIN tipo_evento t ON t.id_tipo_evento = e.id_tipo_evento
JOIN organizador o ON o.id_organizador = e.id_organizador
JOIN ubicacion u   ON u.id_ubicacion   = e.id_ubicacion
WHERE e.id_evento = :id_evento;

\echo '--- Detalle ---'
SELECT r.nombre AS recurso, er.cantidad
FROM evento_recurso er
JOIN recurso r ON r.id_recurso = er.id_recurso
WHERE er.id_evento = :id_evento
ORDER BY r.nombre;
