import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'controlador.dart';
import 'db.dart';

/// Interfaz natural: voz, respuesta hablada y movimiento (sacudida).
final Nui nui = Nui();

/// Estado del permiso de micrófono (la pantalla de Ajustes lo traduce).
enum EstadoMic { sinComprobar, disponible, noDisponible }

class Nui extends ChangeNotifier {
  final SpeechToText _voz = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  StreamSubscription<AccelerometerEvent>? _sensor;
  DateTime _ultimaSacudida = DateTime(2000);

  bool vozDisponible = false;
  bool escuchando = false;
  bool hablar = true;
  EstadoMic estadoMic = EstadoMic.sinComprobar;
  String ultimoTexto = '';
  String respuesta = '';
  Libro? sugerencia;

  /// true si la app está en inglés (afecta a la voz y al reconocimiento).
  bool get _ingles => idioma.value.languageCode == 'en';

  // ---------------- Voz ----------------

  /// Inicializa el reconocimiento (el navegador pide permiso de micrófono).
  Future<bool> iniciarVoz() async {
    try {
      vozDisponible = await _voz.initialize(
        onStatus: (s) {
          if (s == 'done' || s == 'notListening') {
            escuchando = false;
            notifyListeners();
          }
        },
        onError: (e) {
          escuchando = false;
          respuesta = textos.errorVoz(e.errorMsg);
          notifyListeners();
        },
      );
    } catch (_) {
      vozDisponible = false;
    }
    estadoMic =
        vozDisponible ? EstadoMic.disponible : EstadoMic.noDisponible;
    notifyListeners();
    return vozDisponible;
  }

  Future<void> escuchar() async {
    if (!vozDisponible && !await iniciarVoz()) {
      respuesta = textos.noPuedoMicrofono;
      notifyListeners();
      return;
    }
    ultimoTexto = '';
    escuchando = true;
    notifyListeners();
    await _voz.listen(
      listenOptions: SpeechListenOptions(
        localeId: _ingles ? 'en_US' : 'es_ES',
        pauseFor: const Duration(seconds: 3),
      ),
      onResult: (r) {
        ultimoTexto = r.recognizedWords;
        notifyListeners();
        if (r.finalResult) {
          escuchando = false;
          ejecutar(r.recognizedWords);
        }
      },
    );
  }

  Future<void> detener() async {
    await _voz.stop();
    escuchando = false;
    notifyListeners();
  }

  /// Interpreta una orden (hablada o escrita) y la guarda en SQLite.
  /// Se entienden las órdenes en español y en inglés:
  ///  - «Busca libros de ciencia ficción» / "Search books about science fiction"
  ///    -> lee de SQLite
  ///  - «Devuelve el préstamo del libro Dune» / "Return the loan of the book Dune"
  ///    -> escribe en SQLite
  Future<void> ejecutar(String texto) async {
    final orden =
        texto.toLowerCase().replaceAll(RegExp(r'[.,;!?¿¡]'), '').trim();
    final busca = RegExp(
      r'(?:busca(?:r)?\s+libros\s+(?:de|sobre)|search(?:\s+for)?\s+books\s+(?:about|on|of))\s+(.+)',
    ).firstMatch(orden);
    final devuelve = RegExp(
      r'(?:devuelve(?:\s+el)?\s+pr[eé]stamo\s+del\s+libro|return\s+the\s+loan\s+of(?:\s+the\s+book)?)\s+(.+)',
    ).firstMatch(orden);

    String r;
    if (busca != null) {
      final tema = busca.group(1)!.trim();
      await ctrl.buscar(tema);
      r = textos.encontradosLibros(ctrl.libros.length, tema);
    } else if (devuelve != null) {
      final titulo = await ctrl.devolverPorTitulo(devuelve.group(1)!.trim());
      r = titulo != null
          ? textos.prestamoDevuelto(titulo)
          : textos.noEncuentroPrestamo;
    } else {
      r = textos.noEntendido;
    }
    respuesta = r;
    ultimoTexto = texto;
    notifyListeners();
    await ctrl.registrarNui('voz', texto);
    await _decir(r);
  }

  Future<void> _decir(String texto) async {
    if (!hablar) return;
    try {
      await _tts.setLanguage(_ingles ? 'en-US' : 'es-ES');
      await _tts.speak(texto);
    } catch (_) {}
  }

  void cambiarHablar(bool v) {
    hablar = v;
    notifyListeners();
  }

  // ---------------- Movimiento ----------------

  /// Escucha el acelerómetro (solo funciona en móviles; en PC usa F2).
  void iniciarSacudida() {
    _sensor?.cancel();
    try {
      _sensor = accelerometerEventStream().listen((e) {
        final fuerza = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
        final ahora = DateTime.now();
        if (fuerza > 25 &&
            ahora.difference(_ultimaSacudida) > const Duration(seconds: 2)) {
          _ultimaSacudida = ahora;
          sacudir();
        }
      }, onError: (_) {});
    } catch (_) {}
  }

  /// Propone un libro al azar. Se dispara con la sacudida, con F2 o con el botón.
  Future<void> sacudir() async {
    final libro = ctrl.libroAlAzar();
    sugerencia = libro;
    respuesta = libro == null
        ? textos.sinLibrosDisponibles
        : textos.tePropongo(libro.titulo);
    notifyListeners();
    await ctrl.registrarNui('movimiento', respuesta);
    await _decir(respuesta);
  }

  // ---------------- Recursos ----------------

  /// Libera sensor, micrófono y voz sintetizada.
  Future<void> liberar() async {
    await _sensor?.cancel();
    _sensor = null;
    await _voz.cancel();
    await _tts.stop();
  }
}
