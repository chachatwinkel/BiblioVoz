import 'package:sqflite/sqflite.dart';

/// Días que dura un préstamo antes de considerarse vencido.
const int diasPrestamo = 15;

// ====================== MODELOS ======================

class Libro {
  final int? id;
  final String titulo, autor, isbn, genero;

  const Libro({
    this.id,
    required this.titulo,
    required this.autor,
    this.isbn = '',
    this.genero = '',
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'autor': autor,
        'isbn': isbn,
        'genero': genero,
      };

  factory Libro.fromMap(Map<String, Object?> m) => Libro(
        id: m['id'] as int?,
        titulo: m['titulo'] as String,
        autor: m['autor'] as String,
        isbn: (m['isbn'] as String?) ?? '',
        genero: (m['genero'] as String?) ?? '',
      );
}

class Socio {
  final int? id;
  final String alias, curso;

  const Socio({this.id, required this.alias, this.curso = ''});

  Map<String, Object?> toMap() =>
      {if (id != null) 'id': id, 'alias': alias, 'curso': curso};

  factory Socio.fromMap(Map<String, Object?> m) => Socio(
        id: m['id'] as int?,
        alias: m['alias'] as String,
        curso: (m['curso'] as String?) ?? '',
      );
}

class Prestamo {
  final int? id;
  final int libroId, socioId;
  final String fechaSalida;
  final String? fechaDevolucion;

  const Prestamo({
    this.id,
    required this.libroId,
    required this.socioId,
    required this.fechaSalida,
    this.fechaDevolucion,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'libro_id': libroId,
        'socio_id': socioId,
        'fecha_salida': fechaSalida,
        'fecha_devolucion': fechaDevolucion,
      };

  factory Prestamo.fromMap(Map<String, Object?> m) => Prestamo(
        id: m['id'] as int?,
        libroId: m['libro_id'] as int,
        socioId: m['socio_id'] as int,
        fechaSalida: m['fecha_salida'] as String,
        fechaDevolucion: m['fecha_devolucion'] as String?,
      );
}

// ====================== BASE DE DATOS ======================

/// Acceso único (singleton) a la base SQLite.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database>? _db;
  Future<Database> get database => _db ??= _abrir();

  Future<Database> _abrir() {
    return openDatabase(
      'bibliovoz.db',
      version: 1,
      // Las claves ajenas vienen desactivadas por defecto en SQLite.
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _crear,
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }

  Future<void> _crear(Database db, int version) async {
    await db.execute('''
      CREATE TABLE libro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        isbn TEXT,
        genero TEXT
      )''');
    await db.execute('''
      CREATE TABLE socio(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alias TEXT NOT NULL,
        curso TEXT
      )''');
    await db.execute('''
      CREATE TABLE prestamo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libro_id INTEGER NOT NULL,
        socio_id INTEGER NOT NULL,
        fecha_salida TEXT NOT NULL,
        fecha_devolucion TEXT,
        FOREIGN KEY(libro_id) REFERENCES libro(id),
        FOREIGN KEY(socio_id) REFERENCES socio(id)
      )''');
    // Lo que detecta la interfaz natural (voz, movimiento, gestos).
    await db.execute('''
      CREATE TABLE registro_nui(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        detalle TEXT NOT NULL,
        fecha TEXT NOT NULL
      )''');

    // ---- Datos de ejemplo (solo la primera vez) ----
    final batch = db.batch();
    const libros = [
      ['Dune', 'Frank Herbert', 'Ciencia ficción'],
      ['Fundación', 'Isaac Asimov', 'Ciencia ficción'],
      ['Neuromante', 'William Gibson', 'Ciencia ficción'],
      ['El problema de los tres cuerpos', 'Liu Cixin', 'Ciencia ficción'],
      ['El Hobbit', 'J.R.R. Tolkien', 'Fantasía'],
      ['El nombre del viento', 'Patrick Rothfuss', 'Fantasía'],
      ['Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Fantasía'],
      ['Don Quijote de la Mancha', 'Miguel de Cervantes', 'Clásico'],
      ['La sombra del viento', 'Carlos Ruiz Zafón', 'Misterio'],
      ['Estudio en escarlata', 'Arthur Conan Doyle', 'Misterio'],
      ['Sapiens', 'Yuval Noah Harari', 'Divulgación'],
      ['Cosmos', 'Carl Sagan', 'Divulgación'],
    ];
    for (var i = 0; i < libros.length; i++) {
      batch.insert('libro', {
        'titulo': libros[i][0],
        'autor': libros[i][1],
        'isbn': '978-84-0000-${(i + 1).toString().padLeft(3, '0')}-0',
        'genero': libros[i][2],
      });
    }
    const socios = [
      ['lince', '2º DAM'],
      ['nova', '1º DAM'],
      ['pixel', '1º DAW'],
      ['raven', '2º DAM'],
      ['zorro', '1º ASIR'],
    ];
    for (final s in socios) {
      batch.insert('socio', {'alias': s[0], 'curso': s[1]});
    }
    String hace(int dias) =>
        DateTime.now().subtract(Duration(days: dias)).toIso8601String();
    void prestamo(int libro, int socio, int salida, [int? devuelto]) {
      batch.insert('prestamo', {
        'libro_id': libro,
        'socio_id': socio,
        'fecha_salida': hace(salida),
        'fecha_devolucion': devuelto == null ? null : hace(devuelto),
      });
    }

    prestamo(1, 1, 30); // vencido
    prestamo(3, 2, 20); // vencido
    prestamo(9, 4, 18); // vencido
    prestamo(5, 3, 5); // activo
    prestamo(8, 1, 2); // activo
    prestamo(2, 4, 40, 30); // devuelto
    prestamo(1, 5, 60, 50); // devuelto
    prestamo(6, 2, 45, 35); // devuelto
    prestamo(11, 3, 25, 18); // devuelto
    await batch.commit(noResult: true);
  }
}

// ====================== REPOSITORIO (CRUD) ======================

/// Todas las consultas usan parámetros (?) y whereArgs: nunca concatenación.
class Repositorio {
  Future<Database> get _db => DatabaseHelper.instance.database;

  // ---- Libros ----
  Future<List<Libro>> libros([String texto = '']) async {
    final db = await _db;
    final p = '%$texto%';
    final filas = await db.query(
      'libro',
      where: 'titulo LIKE ? OR autor LIKE ? OR genero LIKE ?',
      whereArgs: [p, p, p],
      orderBy: 'titulo',
    );
    return filas.map(Libro.fromMap).toList();
  }

  Future<int> insertarLibro(Libro l) async =>
      (await _db).insert('libro', l.toMap());

  Future<int> actualizarLibro(Libro l) async => (await _db)
      .update('libro', l.toMap(), where: 'id = ?', whereArgs: [l.id]);

  Future<int> borrarLibro(int id) async =>
      (await _db).delete('libro', where: 'id = ?', whereArgs: [id]);

  // ---- Socios ----
  Future<List<Socio>> socios() async {
    final filas = await (await _db).query('socio', orderBy: 'alias');
    return filas.map(Socio.fromMap).toList();
  }

  Future<int> insertarSocio(Socio s) async =>
      (await _db).insert('socio', s.toMap());

  Future<int> actualizarSocio(Socio s) async => (await _db)
      .update('socio', s.toMap(), where: 'id = ?', whereArgs: [s.id]);

  Future<int> borrarSocio(int id) async =>
      (await _db).delete('socio', where: 'id = ?', whereArgs: [id]);

  // ---- Préstamos ----
  Future<int> insertarPrestamo(Prestamo p) async =>
      (await _db).insert('prestamo', p.toMap());

  Future<int> devolverPrestamo(int id) async => (await _db).update(
        'prestamo',
        {'fecha_devolucion': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<int> borrarPrestamo(int id) async =>
      (await _db).delete('prestamo', where: 'id = ?', whereArgs: [id]);

  /// JOIN libro–socio–préstamo: préstamos sin devolver.
  /// Con [soloVencidos] = true, solo los que superan [diasPrestamo].
  Future<List<Map<String, Object?>>> prestamosActivos(
      {bool soloVencidos = false}) async {
    final limite = DateTime.now()
        .subtract(const Duration(days: diasPrestamo))
        .toIso8601String();
    return (await _db).rawQuery('''
      SELECT p.id AS prestamo_id, p.libro_id, l.titulo, s.alias, p.fecha_salida
      FROM prestamo p
      JOIN libro l ON l.id = p.libro_id
      JOIN socio s ON s.id = p.socio_id
      WHERE p.fecha_devolucion IS NULL
        AND (? = 0 OR p.fecha_salida < ?)
      ORDER BY p.fecha_salida
    ''', [soloVencidos ? 1 : 0, limite]);
  }

  /// JOIN: historial de préstamos de un socio.
  Future<List<Map<String, Object?>>> prestamosDeSocio(int socioId) async {
    return (await _db).rawQuery('''
      SELECT l.titulo, p.fecha_salida, p.fecha_devolucion
      FROM prestamo p
      JOIN libro l ON l.id = p.libro_id
      WHERE p.socio_id = ?
      ORDER BY p.fecha_salida DESC
    ''', [socioId]);
  }

  /// Agregado (COUNT): préstamos por género.
  Future<Map<String, int>> contarPorGenero() async {
    final filas = await (await _db).rawQuery('''
      SELECT l.genero AS genero, COUNT(*) AS total
      FROM prestamo p
      JOIN libro l ON l.id = p.libro_id
      GROUP BY l.genero
      ORDER BY total DESC
    ''');
    return {
      for (final f in filas) '${f['genero']}': f['total'] as int,
    };
  }

  // ---- Interfaz natural ----
  Future<int> registrarNui(String tipo, String detalle) async =>
      (await _db).insert('registro_nui', {
        'tipo': tipo,
        'detalle': detalle,
        'fecha': DateTime.now().toIso8601String(),
      });

  Future<List<Map<String, Object?>>> registrosNui() async =>
      (await _db).query('registro_nui', orderBy: 'id DESC', limit: 50);
}
