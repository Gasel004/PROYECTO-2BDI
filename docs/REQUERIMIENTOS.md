# Proyecto II — Sistema de Gestión de Eventos y Recursos

Curso: Bases de Datos 2

## 1. Descripción

Una institución necesita gestionar los eventos que organiza durante el año (capacitaciones, reuniones, conferencias, talleres, seminarios y actividades institucionales). Hoy la información de eventos y recursos se lleva de forma manual.

El sistema debe registrar eventos, organizadores, tipos de evento, ubicaciones y recursos necesarios. Un evento puede requerir varios recursos, por lo que se implementa una relación **maestro-detalle**:

- **Maestro:** `EVENTO`
- **Detalle:** `RECURSOS` requeridos por el evento (con cantidad)

Ejemplo: Evento "Capacitación de Seguridad" (15/10/2026) → Proyector x1, Computadora x1, Micrófono x2, Sillas x30, Pantalla x1.

## 2. Requerimientos funcionales

| Módulo | Requerimiento |
|---|---|
| Organizadores | Registrar responsables de eventos (identificación y datos básicos). |
| Tipos de evento | Administrar tipos (ej. capacitación, reunión, conferencia, taller, seminario). Atributos a definir por el estudiante. |
| Recursos | Registrar recursos (proyector, computadora, micrófono, bocinas, sillas, mesas, pantalla) e identificar si están disponibles. Atributos a definir por el estudiante. |
| Eventos | Registrar: identificación, nombre/descripción, fecha, hora, tipo, organizador, ubicación y estado. Consultar, modificar y eliminar según reglas establecidas. |
| Maestro-detalle | Cada evento tiene recursos requeridos como registros de detalle. |

## 3. Operaciones CRUD

- **INSERT:** organizadores, tipos de evento, recursos, eventos.
- **UPDATE:** organizadores, recursos, eventos y detalles de un evento.
- **DELETE:** según reglas de integridad. Ejemplos: recurso no utilizado, evento de prueba, detalle de evento; además, intentar eliminar un registro relacionado para demostrar la integridad referencial.
- **SELECT:** listado de eventos, eventos por fecha, eventos por tipo, recursos disponibles.

## 4. Datos de prueba (mínimo)

- 10 organizadores
- 5 tipos de evento
- 10 recursos
- 10 eventos

Los datos deben ser lo bastante variados para probar las consultas solicitadas.

## 5. Normalización (hasta 3FN)

- **1FN:** valores atómicos, sin grupos repetitivos, sin múltiples valores en un campo. Explicar cómo se resuelve el caso de varios recursos en un solo atributo.
- **2FN:** analizar dependencia respecto de las claves primarias, sobre todo en claves compuestas.
- **3FN:** comprobar que no existan dependencias transitivas.

## 6. Integridad de los datos

- **6.1 Entidad:** toda tabla con clave primaria; sin duplicados en la PK.
- **6.2 Referencial:** claves foráneas válidas (ej. no registrar un evento con organizador inexistente). Se deben realizar pruebas que lo demuestren.
- **6.3 Dominio:** valores válidos por campo (fechas válidas, estados permitidos, campos obligatorios sin NULL).

## 7. Entregables

1. Manual del usuario
2. Manual técnico:
   1. Diagrama Entidad-Relación
   2. Identificación de entidades
   3. Identificación de atributos
   4. Relaciones entre entidades
   5. Cardinalidades
   6. Proceso de normalización hasta 3FN
   7. Modelo relacional
   8. Restricciones de integridad
3. Script de base de datos
4. Videos: evidencias de desarrollo del sistema y explicación de la funcionalidad
