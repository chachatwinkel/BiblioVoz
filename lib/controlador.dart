import 'dart:math';

import 'package:flutter/material.dart';

import 'db.dart';

/// Tema elegido por el usuario (claro/oscuro).
final ValueNotifier<ThemeMode> modoTema = ValueNotifier(ThemeMode.light);

/// Controlador único de la app (patrón MVC con ChangeNotifier).
final BibliotecaController ctrl = BibliotecaController();

class BibliotecaController extends ChangeNotifier {
  final Repositorio _repo = Repositorio();

  List<Libro> todos = []; // todos los libros
  List<Libro> libros = []; // libros filtrados por el buscador
  List<Socio> socios = [];
  List<Map<String, Object?>> activos = []; // JOIN: préstamos sin devolver
  List<Map<String, Object?>> vencidos = []; // JOIN: préstamos vencidos
  Map<String, int> porGenero = {}; // COUNT por género
  List<Map<String, Object?>> registrosNui = [];
  Set<int> librosPrestados = {};
  String filtro = '';

  Future<void> cargar() async {
    todos = await _repo.libros();
    libros = await _repo.libros(filtro);
    socios = await _repo.socios();
    activos = await _repo.prestamosActivos();
    vencidos = await _repo.prestamosActivos(soloVencidos: true);
    porGenero = await _repo.contarPorGenero();
    registrosNui = await _repo.registrosNui();
    librosPrestados = activos.map((f) => f['libro_id'] as int).toSet();
    notifyListeners();
  }

  // ---- Libros ----
  Future<void> buscar(String texto) async {
    filtro = texto;
    libros = await _repo.libros(texto);
    notifyListeners();
  }

  Future<void> guardarLibro(Libro l) async {
    if (l.id == null) {
      await _repo.insertarLibro(l);
    } else {
      await _repo.actualizarLibro(l);
    }
    await cargar();
  }

  /// Devuelve false si no se puede borrar (tiene préstamos).
  Future<bool> borrarLibro(int id) async {
    try {
      await _repo.borrarLibro(id);
      await cargar();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- Socios ----
  Future<void> guardarSocio(Socio s) async {
    if (s.id == null) {
      await _repo.insertarSocio(s);
    } else {
      await _repo.actualizarSocio(s);
    }
    await cargar();
  }

  Future<bool> borrarSocio(int id) async {
    try {
      await _repo.borrarSocio(id);
      await cargar();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, Object?>>> prestamosDeSocio(int id) =>
      _repo.prestamosDeSocio(id);

  // ---- Préstamos ----
  /// Devuelve un mensaje de error o null si todo fue bien.
  Future<String?> nuevoPrestamo(int libroId, int socioId) async {
    if (librosPrestados.contains(libroId)) return 'Ese libro ya está prestado';
    await _repo.insertarPrestamo(Prestamo(
      libroId: libroId,
      socioId: socioId,
      fechaSalida: DateTime.now().toIso8601String(),
    ));
    await cargar();
    return null;
  }

  Future<void> devolver(int prestamoId) async {
    await _repo.devolverPrestamo(prestamoId);
    await cargar();
  }

  /// Devuelve el título del libro devuelto, o null si no hay préstamo activo.
  Future<String?> devolverPorTitulo(String texto) async {
    final t = texto.toLowerCase();
    for (final a in activos) {
      final titulo = a['titulo'] as String;
      if (titulo.toLowerCase().contains(t)) {
        await devolver(a['prestamo_id'] as int);
        return titulo;
      }
    }
    return null;
  }

  // ---- Interfaz natural ----
  Future<void> registrarNui(String tipo, String detalle) async {
    await _repo.registrarNui(tipo, detalle);
    registrosNui = await _repo.registrosNui();
    notifyListeners();
  }

  Future<void> valorar(Libro libro, int valor) =>
      registrarNui('gesto', 'Valoración de "${libro.titulo}": $valor');

  /// Libro al azar que no esté prestado.
  Libro? libroAlAzar() {
    final disponibles =
        todos.where((l) => !librosPrestados.contains(l.id)).toList();
    if (disponibles.isEmpty) return null;
    return disponibles[Random().nextInt(disponibles.length)];
  }
}
