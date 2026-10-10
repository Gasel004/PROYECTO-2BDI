--            10 recursos, 10 eventos y sus detalles de recursos.

BEGIN;

-- ------------------------------------------------------------
-- ORGANIZADOR (10) - el último (Gabriela) no organiza ningún evento
-- ------------------------------------------------------------
INSERT INTO organizador (nombre, apellido, correo, telefono, cargo) VALUES
    ('María Fernanda', 'López',    'mlopez@institucion.edu.gt',    '5501-2345', 'Coordinadora Académica'),
    ('Carlos Alberto', 'Méndez',   'cmendez@institucion.edu.gt',   '5502-3456', 'Jefe de Recursos Humanos'),
    ('Ana Lucía',      'Ramírez',  'aramirez@institucion.edu.gt',  '5503-4567', 'Encargada de Seguridad'),
    ('José Luis',      'Pérez',    'jperez@institucion.edu.gt',    '5504-5678', 'Instructor de Informática'),
    ('Sofía Elizabeth','Castillo', 'scastillo@institucion.edu.gt', '5505-6789', 'Gerente de Proyectos'),
    ('Luis Fernando',  'Morales',  'lmorales@institucion.edu.gt',  NULL,        'Coordinador de Salud Ocupacional'),
    ('Andrea Paola',   'Herrera',  'aherrera@institucion.edu.gt',  '5507-8901', NULL),
    ('Diego Alejandro','Ruiz',     'druiz@institucion.edu.gt',     '5508-9012', 'Encargado de TI'),
    ('Roberto Antonio','Alvarado', 'ralvarado@institucion.edu.gt', NULL,        'Director de Comunicación'),
    ('Gabriela Mishel','Cifuentes','gcifuentes@institucion.edu.gt','5510-1234', 'Asistente Administrativa');

-- ------------------------------------------------------------
-- TIPO_EVENTO (5)
-- ------------------------------------------------------------
INSERT INTO tipo_evento (nombre, descripcion) VALUES
    ('Capacitación', 'Formación práctica dirigida al personal de la institución'),
    ('Reunión',      'Encuentro de trabajo entre equipos o áreas'),
    ('Conferencia',  'Exposición de un tema ante un público numeroso'),
    ('Taller',       'Actividad práctica con participación activa de los asistentes'),
    ('Seminario',    'Sesión de estudio y discusión sobre un tema especializado');

-- ------------------------------------------------------------
-- UBICACION (6)
-- ------------------------------------------------------------
INSERT INTO ubicacion (nombre, direccion, capacidad) VALUES
    ('Auditorio Principal',          'Edificio A, nivel 1',        200),
    ('Salón de Conferencias A',      'Edificio B, nivel 2',         60),
    ('Salón de Conferencias B',      'Edificio B, nivel 2',         40),
    ('Laboratorio de Cómputo 1',     'Edificio C, nivel 1',         30),
    ('Sala de Juntas',               'Edificio A, nivel 3',         15),
    ('Patio Cultural',               'Área exterior, edificio A',  150);

-- ------------------------------------------------------------
-- RECURSO (10)
--   * Cámara web: no disponible (en reparación)
--   * Extensión eléctrica: no se usa en ningún evento (sirve para
--     probar el borrado permitido de un recurso sin uso)
-- ------------------------------------------------------------
INSERT INTO recurso (nombre, descripcion, cantidad_total, disponible) VALUES
    ('Proyector',             'Proyector multimedia HDMI',              5,   TRUE),
    ('Computadora portátil',  'Laptop para presentaciones',            20,   TRUE),
    ('Micrófono inalámbrico', 'Micrófono de mano con receptor',         8,   TRUE),
    ('Bocinas',               'Bocinas amplificadas portátiles',        6,   TRUE),
    ('Sillas',                'Sillas plegables',                     200,   TRUE),
    ('Mesas',                 'Mesas rectangulares',                   40,   TRUE),
    ('Pantalla de proyección','Pantalla retráctil de pared o trípode',  4,   TRUE),
    ('Pizarra móvil',         'Pizarra blanca con ruedas',              6,   TRUE),
    ('Cámara web',            'Cámara HD para videoconferencias',       3,   FALSE),
    ('Extensión eléctrica',   'Extensión de 5 metros con regleta',     15,   TRUE);

-- ------------------------------------------------------------
-- EVENTO (10) - maestro
--   Mezcla de estados, fechas pasadas y futuras, un evento sin hora de
--   fin y un evento (Seminario de Salud Ocupacional) sin recursos.
-- ------------------------------------------------------------
INSERT INTO evento
    (nombre, descripcion, fecha, hora_inicio, hora_fin, estado,
     id_tipo_evento, id_organizador, id_ubicacion)
SELECT
    v.nombre, v.descripcion, v.fecha, v.hora_inicio, v.hora_fin, v.estado,
    (SELECT id_tipo_evento FROM tipo_evento WHERE nombre = v.tipo),
    (SELECT id_organizador FROM organizador WHERE correo = v.org),
    (SELECT id_ubicacion   FROM ubicacion   WHERE nombre = v.ubic)
FROM (VALUES
    ('Capacitación de Seguridad',           'Normas básicas de seguridad en el trabajo',
        DATE '2026-10-15', TIME '09:00', TIME '12:00', 'Programado',
        'Capacitación', 'aramirez@institucion.edu.gt',    'Salón de Conferencias A'),
    ('Reunión de Coordinación Académica',   'Planificación del cierre del ciclo',
        DATE '2026-10-12', TIME '08:30', TIME '10:00', 'Programado',
        'Reunión',      'mlopez@institucion.edu.gt',      'Sala de Juntas'),
    ('Conferencia de Innovación Tecnológica','Tendencias tecnológicas para la institución',
        DATE '2026-11-05', TIME '14:00', TIME '17:00', 'Programado',
        'Conferencia',  'ralvarado@institucion.edu.gt',   'Auditorio Principal'),
    ('Taller de Excel Avanzado',            'Tablas dinámicas y funciones avanzadas',
        DATE '2026-10-20', TIME '15:00', TIME '18:00', 'Programado',
        'Taller',       'jperez@institucion.edu.gt',      'Laboratorio de Cómputo 1'),
    ('Seminario de Gestión de Proyectos',   'Metodologías ágiles y tradicionales',
        DATE '2026-11-18', TIME '09:00', TIME '13:00', 'Programado',
        'Seminario',    'scastillo@institucion.edu.gt',   'Salón de Conferencias B'),
    ('Capacitación de Primeros Auxilios',   'Atención básica de emergencias',
        DATE '2026-09-22', TIME '08:00', TIME '12:00', 'Finalizado',
        'Capacitación', 'mlopez@institucion.edu.gt',      'Patio Cultural'),
    ('Reunión de Evaluación Semestral',     'Revisión de resultados del semestre',
        DATE '2026-09-10', TIME '10:00', TIME '11:30', 'Finalizado',
        'Reunión',      'cmendez@institucion.edu.gt',     'Sala de Juntas'),
    ('Conferencia de Ciberseguridad',       'Buenas prácticas de seguridad informática',
        DATE '2026-10-08', TIME '16:00', TIME '19:00', 'En curso',
        'Conferencia',  'druiz@institucion.edu.gt',       'Salón de Conferencias A'),
    ('Taller de Oratoria',                  'Técnicas de expresión oral',
        DATE '2026-10-27', TIME '14:00', TIME '16:30', 'Cancelado',
        'Taller',       'aherrera@institucion.edu.gt',    'Salón de Conferencias B'),
    ('Seminario de Salud Ocupacional',      'Prevención de riesgos laborales',
        DATE '2026-12-02', TIME '09:00', NULL,         'Programado',
        'Seminario',    'lmorales@institucion.edu.gt',    'Auditorio Principal')
) AS v (nombre, descripcion, fecha, hora_inicio, hora_fin, estado, tipo, org, ubic);

-- ------------------------------------------------------------
-- EVENTO_RECURSO (detalle)
--   Los eventos se buscan por nombre (único en estos datos de prueba).
-- ------------------------------------------------------------
INSERT INTO evento_recurso (id_evento, id_recurso, cantidad)
SELECT
    (SELECT id_evento  FROM evento  WHERE nombre = v.evento),
    (SELECT id_recurso FROM recurso WHERE nombre = v.recurso),
    v.cantidad
FROM (VALUES
    -- Capacitación de Seguridad (ejemplo del enunciado)
    ('Capacitación de Seguridad',            'Proyector',              1),
    ('Capacitación de Seguridad',            'Computadora portátil',   1),
    ('Capacitación de Seguridad',            'Micrófono inalámbrico',  2),
    ('Capacitación de Seguridad',            'Sillas',                30),
    ('Capacitación de Seguridad',            'Pantalla de proyección', 1),
    -- Reunión de Coordinación Académica
    ('Reunión de Coordinación Académica',    'Mesas',                  2),
    ('Reunión de Coordinación Académica',    'Sillas',                12),
    ('Reunión de Coordinación Académica',    'Proyector',              1),
    -- Conferencia de Innovación Tecnológica
    ('Conferencia de Innovación Tecnológica','Micrófono inalámbrico',  4),
    ('Conferencia de Innovación Tecnológica','Bocinas',                4),
    ('Conferencia de Innovación Tecnológica','Proyector',              2),
    ('Conferencia de Innovación Tecnológica','Pantalla de proyección', 2),
    ('Conferencia de Innovación Tecnológica','Sillas',               150),
    -- Taller de Excel Avanzado
    ('Taller de Excel Avanzado',             'Proyector',              1),
    ('Taller de Excel Avanzado',             'Pizarra móvil',          1),
    -- Seminario de Gestión de Proyectos
    ('Seminario de Gestión de Proyectos',    'Sillas',                40),
    ('Seminario de Gestión de Proyectos',    'Mesas',                  6),
    ('Seminario de Gestión de Proyectos',    'Proyector',              1),
    ('Seminario de Gestión de Proyectos',    'Micrófono inalámbrico',  2),
    -- Capacitación de Primeros Auxilios
    ('Capacitación de Primeros Auxilios',    'Sillas',                40),
    ('Capacitación de Primeros Auxilios',    'Mesas',                  4),
    ('Capacitación de Primeros Auxilios',    'Pizarra móvil',          1),
    -- Reunión de Evaluación Semestral
    ('Reunión de Evaluación Semestral',      'Sillas',                10),
    ('Reunión de Evaluación Semestral',      'Mesas',                  1),
    ('Reunión de Evaluación Semestral',      'Cámara web',             1),
    -- Conferencia de Ciberseguridad
    ('Conferencia de Ciberseguridad',        'Proyector',              1),
    ('Conferencia de Ciberseguridad',        'Micrófono inalámbrico',  2),
    ('Conferencia de Ciberseguridad',        'Bocinas',                2),
    ('Conferencia de Ciberseguridad',        'Sillas',                50),
    -- Taller de Oratoria (un solo recurso)
    ('Taller de Oratoria',                   'Sillas',                25)
    -- Seminario de Salud Ocupacional: sin recursos (evento sin detalle)
) AS v (evento, recurso, cantidad);

COMMIT;

-- ------------------------------------------------------------
-- Verificación: cantidad de registros por tabla
-- ------------------------------------------------------------
SELECT 'organizador'    AS tabla, COUNT(*) AS registros FROM organizador
UNION ALL SELECT 'tipo_evento',    COUNT(*) FROM tipo_evento
UNION ALL SELECT 'ubicacion',      COUNT(*) FROM ubicacion
UNION ALL SELECT 'recurso',        COUNT(*) FROM recurso
UNION ALL SELECT 'evento',         COUNT(*) FROM evento
UNION ALL SELECT 'evento_recurso', COUNT(*) FROM evento_recurso;
