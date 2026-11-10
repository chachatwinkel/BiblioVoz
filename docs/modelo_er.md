# Modelo entidad–relación de BiblioVoz

```mermaid
erDiagram
    LIBRO ||--o{ PRESTAMO : "se presta en"
    SOCIO ||--o{ PRESTAMO : "realiza"
    LIBRO ||--o{ VALORACION

    LIBRO {
        INTEGER id PK
        TEXT titulo
        TEXT autor
        TEXT isbn
        TEXT genero
    }
    SOCIO {
        INTEGER id PK
        TEXT alias
        TEXT curso
    }
    PRESTAMO {
        INTEGER id PK
        INTEGER libro_id FK
        INTEGER socio_id FK
        TEXT fecha_salida
        TEXT fecha_devolucion
    }
    REGISTRO_NUI {
        INTEGER id PK
        TEXT tipo
        TEXT detalle
        TEXT fecha
    }
```

`REGISTRO_NUI` no tiene claves ajenas: es un registro independiente de eventos
de voz, movimiento, gestos y realidad aumentada.

## Sentencias CREATE TABLE

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE libro(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT NOT NULL,
  autor TEXT NOT NULL,
  isbn TEXT,
  genero TEXT
);

CREATE TABLE socio(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  alias TEXT NOT NULL,
  curso TEXT
);

CREATE TABLE prestamo(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  libro_id INTEGER NOT NULL,
  socio_id INTEGER NOT NULL,
  fecha_salida TEXT NOT NULL,
  fecha_devolucion TEXT,
  FOREIGN KEY(libro_id) REFERENCES libro(id),
  FOREIGN KEY(socio_id) REFERENCES socio(id)
);

CREATE TABLE registro_nui(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tipo TEXT NOT NULL,
  detalle TEXT NOT NULL,
  fecha TEXT NOT NULL
);

CREATE TABLE valoracion(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  libro_id INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  origen TEXT NOT NULL,
  fecha TEXT NOT NULL,
  FOREIGN KEY(libro_id) REFERENCES libro(id)
);
