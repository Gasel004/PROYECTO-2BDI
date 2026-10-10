# Proyecto II: Gestión de eventos

Proyecto académico del curso **Bases de Datos 1**, el cúal permite administrar eventos, organizadores, tipos de evento, ubicaciones y recursos, cada evento puede asociarse con varios recursos y cantidades mediante una relación maestro-detalle
##
- Enlance al video: [text](https://youtu.be/bpWPFkX-HmI)
- 
## Tecnologías

- PostgreSQL
- Astro y Node.js (22.12 o superior)

## Preparación

1. Crea una base de datos vacía en PostgreSQL, por ejemplo `eventos_db`
2. Desde la raíz del proyecto, crea las tablas y carga los datos de ejemplo:

   ```bash
   psql -d eventos_db -f database/ddl/01_ddl.sql
   psql -d eventos_db -f database/datos/01_datos_prueba.sql
   ```

   **Nota:** el script de creación elimina las tablas existentes antes de volver a crearlas em ciclo

3. Crea `app/.env` y configura la conexión:

   ```env
   DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/eventos_db"
   ```

4. Instala las dependencias e inicia la aplicación:

   ```bash
   cd app
   npm install
   npm run dev
   ```

## Contenido del proyecto

- `database/ddl/`: creación de tablas y permisos.
- `database/datos/`: datos de prueba.
- `database/consultas/`: consultas SELECT de ejemplo.
- `database/pruebas-integridad/`: pruebas de integridad de entidad, referencial y de dominio.
- `app/`: aplicación web para gestionar eventos y catálogos.
- `docs/`: requerimientos, diagrama y manuales.

## Datos
- Elmer Yovani Rodríguez de Paz
- 7690-22-11804
- Bases de datos l "B"

