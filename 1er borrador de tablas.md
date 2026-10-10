ORGANIZADOR

Atributo	Tipo	Restricciones
id_organizador	SERIAL	PK
nombre	VARCHAR(80)	NOT NULL
apellido	VARCHAR(80)	NOT NULL
correo	VARCHAR(120)	NOT NULL, UNIQUE
telefono	VARCHAR(20)	NULL permitido
cargo	VARCHAR(80)	NULL permitido

---
TIPO_EVENTO

Atributo	Tipo	Restricciones
id_tipo_evento	SERIAL	PK
nombre	VARCHAR(50)	NOT NULL, UNIQUE
descripcion	VARCHAR(200)	NULL permitido

---
UBICACION

Atributo	Tipo	Restricciones
id_ubicacion	SERIAL	PK
nombre	VARCHAR(80)	NOT NULL, UNIQUE
direccion	VARCHAR(150)	NOT NULL
capacidad	INTEGER	NOT NULL, CHECK (capacidad > 0)

---
RECURSO

Atributo	Tipo	Restricciones
id_recurso	SERIAL	PK
nombre	VARCHAR(80)	NOT NULL, UNIQUE
descripcion	VARCHAR(200)	NULL permitido
cantidad_total	INTEGER	NOT NULL, CHECK (cantidad_total > 0)
disponible	BOOLEAN	NOT NULL, DEFAULT TRUE


---
EVENTO (maestro)

Atributo	Tipo	Restricciones
id_evento	SERIAL	PK
nombre	VARCHAR(120)	NOT NULL
descripcion	VARCHAR(300)	NULL permitido
fecha	DATE	NOT NULL
hora_inicio	TIME	NOT NULL
hora_fin	TIME	NULL permitido, CHECK (hora_fin > hora_inicio)
estado	VARCHAR(20)	NOT NULL, CHECK en (‘Programado’, ‘En curso’, ‘Finalizado’, ‘Cancelado’)
id_tipo_evento	INTEGER	FK → TIPO_EVENTO, NOT NULL
id_organizador	INTEGER	FK → ORGANIZADOR, NOT NULL
id_ubicacion	INTEGER	FK → UBICACION, NOT NULL

---

EVENTO_RECURSO (detalle)

Atributo	Tipo	Restricciones
id_evento	INTEGER	PK (parte 1), FK → EVENTO
id_recurso	INTEGER	PK (parte 2), FK → RECURSO
cantidad	INTEGER	NOT NULL, CHECK (cantidad > 0)



#	Relación
1	ORGANIZADOR – EVENTO	Un organizador organiza varios eventos; un evento lo organiza exactamente un organizador	1:N. ORGANIZADOR (0,N) · EVENTO (1,1)	EVENTO.id_organizador
2	TIPO_EVENTO – EVENTO	Un tipo clasifica varios eventos; un evento tiene exactamente un tipo	1:N. TIPO_EVENTO (0,N) · EVENTO (1,1)	EVENTO.id_tipo_evento
3	UBICACION – EVENTO	Una ubicación aloja varios eventos; un evento se realiza en exactamente una ubicación	1:N. UBICACION (0,N) · EVENTO (1,1)	EVENTO.id_ubicacion
4	EVENTO – EVENTO_RECURSO	Un evento tiene varios detalles de recurso; cada detalle pertenece a un solo evento	1:N. EVENTO (1,1) · EVENTO_RECURSO (0,N)	EVENTO_RECURSO.id_evento
5	RECURSO – EVENTO_RECURSO	Un recurso aparece en varios detalles; cada detalle se refiere a un solo recurso	1:N. RECURSO (1,1) · EVENTO_RECURSO (0,N)	EVENTO_RECURSO.id_recurso
