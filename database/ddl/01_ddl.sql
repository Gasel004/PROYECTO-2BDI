/*
Script de creación de tablas

Reglas de borrado (ON DELETE):
EVENTO -> ORGANIZADOR / TIPO_EVENTO / UBICACION : RESTRICT
EVENTO_RECURSO -> RECURSO                       : RESTRICT
EVENTO_RECURSO -> EVENTO                        : CASCADE

Limpieza para poder re-ejecutar el script (borra TODOS los datos).
Orden inverso a las dependencias: primero el detalle.
*/
DROP TABLE IF EXISTS evento_recurso;
DROP TABLE IF EXISTS evento;
DROP TABLE IF EXISTS recurso;
DROP TABLE IF EXISTS ubicacion;
DROP TABLE IF EXISTS tipo_evento;
DROP TABLE IF EXISTS organizador;


CREATE TABLE organizador (
    id_organizador SERIAL       NOT NULL,
    nombre         VARCHAR(80)  NOT NULL,
    apellido       VARCHAR(80)  NOT NULL,
    correo         VARCHAR(120) NOT NULL,
    telefono       VARCHAR(20),
    cargo          VARCHAR(80),
    CONSTRAINT pk_organizador        PRIMARY KEY (id_organizador),
    CONSTRAINT uq_organizador_correo UNIQUE (correo)
);

CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL       NOT NULL,
    nombre         VARCHAR(50)  NOT NULL,
    descripcion    VARCHAR(200),
    CONSTRAINT pk_tipo_evento        PRIMARY KEY (id_tipo_evento),
    CONSTRAINT uq_tipo_evento_nombre UNIQUE (nombre)
);


CREATE TABLE ubicacion (
    id_ubicacion SERIAL       NOT NULL,
    nombre       VARCHAR(80)  NOT NULL,
    direccion    VARCHAR(150) NOT NULL,
    capacidad    INTEGER      NOT NULL,
    CONSTRAINT pk_ubicacion           PRIMARY KEY (id_ubicacion),
    CONSTRAINT uq_ubicacion_nombre    UNIQUE (nombre),
    CONSTRAINT ck_ubicacion_capacidad CHECK (capacidad > 0)
);


CREATE TABLE recurso (
    id_recurso     SERIAL       NOT NULL,
    nombre         VARCHAR(80)  NOT NULL,
    descripcion    VARCHAR(200),
    cantidad_total INTEGER      NOT NULL,
    disponible     BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_recurso          PRIMARY KEY (id_recurso),
    CONSTRAINT uq_recurso_nombre   UNIQUE (nombre),
    CONSTRAINT ck_recurso_cantidad CHECK (cantidad_total > 0)
);

--(maestro)
CREATE TABLE evento (
    id_evento      SERIAL       NOT NULL,
    nombre         VARCHAR(120) NOT NULL,
    descripcion    VARCHAR(300),
    fecha          DATE         NOT NULL,
    hora_inicio    TIME         NOT NULL,
    hora_fin       TIME,
    estado         VARCHAR(20)  NOT NULL,
    id_tipo_evento INTEGER      NOT NULL,
    id_organizador INTEGER      NOT NULL,
    id_ubicacion   INTEGER      NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT ck_evento_horas
        CHECK (hora_fin > hora_inicio),
    CONSTRAINT ck_evento_estado
        CHECK (estado IN ('Programado', 'En curso', 'Finalizado', 'Cancelado')),
    CONSTRAINT fk_evento_tipo_evento
        FOREIGN KEY (id_tipo_evento)
        REFERENCES tipo_evento (id_tipo_evento)
        ON DELETE RESTRICT,
    CONSTRAINT fk_evento_organizador
        FOREIGN KEY (id_organizador)
        REFERENCES organizador (id_organizador)
        ON DELETE RESTRICT,
    CONSTRAINT fk_evento_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion (id_ubicacion)
        ON DELETE RESTRICT
);


-- detalle - PK compuesta

CREATE TABLE evento_recurso (
    id_evento  INTEGER NOT NULL,
    id_recurso INTEGER NOT NULL,
    cantidad   INTEGER NOT NULL,
    CONSTRAINT pk_evento_recurso PRIMARY KEY (id_evento, id_recurso),
    CONSTRAINT ck_evento_recurso_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_evento_recurso_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento)
        ON DELETE CASCADE,
    CONSTRAINT fk_evento_recurso_recurso
        FOREIGN KEY (id_recurso)
        REFERENCES recurso (id_recurso)
        ON DELETE RESTRICT
);
/*
(#__#)
*/
