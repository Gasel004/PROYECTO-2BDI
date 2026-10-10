
-- Permisos del rol de la aplicación (eventos_app): solo DML.

GRANT USAGE ON SCHEMA public TO eventos_app;

GRANT SELECT, INSERT, UPDATE, DELETE
    ON ALL TABLES IN SCHEMA public TO eventos_app;

-- Necesario para los INSERT en columnas SERIAL
GRANT USAGE, SELECT
    ON ALL SEQUENCES IN SCHEMA public TO eventos_app;
