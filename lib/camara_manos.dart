import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

// Puente con web/manos.js (MediaPipe: detección de manos con la cámara).

@JS('biblioManos.crearVista')
external JSObject _crearVista();

@JS('biblioManos.iniciar')
external JSPromise<JSBoolean> _iniciar(JSFunction alGesto);

@JS('biblioManos.detener')
external void _detener();

const String _tipoVista = 'bibliovoz-manos';
bool _vistaRegistrada = false;

/// Estado del permiso de cámara, visible en la pantalla de Ajustes.
final ValueNotifier<String> estadoCamara = ValueNotifier('Sin comprobar');

/// Cámara con detección de pulgar arriba / abajo.
///
/// [onGesto] recibe 1 (pulgar arriba) o -1 (pulgar abajo) cuando el gesto se
/// mantiene estable unos instantes. Mientras está activa se dibuja el esqueleto
/// de la mano sobre el vídeo (superposición visual) y una barra de progreso.
/// La alternativa táctil sigue siendo el widget `ThumbRating`.
///
/// La cámara se pide solo al pulsar «Activar cámara» y se libera al pulsar
/// «Desactivar» o al salir de la pantalla (`dispose`).
class VistaManos extends StatefulWidget {
  final ValueChanged<int> onGesto;

  /// Widget que se dibuja encima del vídeo (la ficha flotante de AR).
  final Widget? superposicion;

  const VistaManos({super.key, required this.onGesto, this.superposicion});
  @override
  State<VistaManos> createState() => _VistaManosState();
}

class _VistaManosState extends State<VistaManos> {
  bool _activa = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    if (!_vistaRegistrada) {
      ui_web.platformViewRegistry
          .registerViewFactory(_tipoVista, (int id) => _crearVista());
      _vistaRegistrada = true;
    }
  }

  Future<void> _activar() async {
    setState(() => _cargando = true);
    final ok = (await _iniciar(((JSString gesto) {
      widget.onGesto(gesto.toDart == 'up' ? 1 : -1);
    }).toJS).toDart)
        .toDart;
    estadoCamara.value =
        ok ? 'Cámara activa' : 'No disponible o permiso denegado';
    if (!mounted) {
      _detener();
      return;
    }
    setState(() {
      _activa = ok;
      _cargando = false;
    });
  }

  void _desactivar() {
    _detener();
    estadoCamara.value = 'Cámara apagada';
    setState(() => _activa = false);
  }

  @override
  void dispose() {
    // Libera la cámara al salir de la pantalla.
    _detener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // El vídeo se mantiene siempre en el árbol: así el elemento HTML
        // creado por manos.js no se destruye al activar/desactivar.
        Offstage(
          offstage: !_activa,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const HtmlElementView(viewType: _tipoVista),
                      if (widget.superposicion != null) widget.superposicion!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: _activa
              ? OutlinedButton.icon(
                  onPressed: _desactivar,
                  icon: const Icon(Icons.videocam_off),
                  label: const Text('Desactivar cámara'),
                )
              : FilledButton.icon(
                  onPressed: _cargando ? null : _activar,
                  icon: _cargando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.videocam),
                  label: Text(_cargando
                      ? 'Cargando detector…'
                      : 'Valorar con la cámara (pulgar)'),
                ),
        ),
        const SizedBox(height: 4),
        const Text(
          'La cámara solo se enciende al pulsar el botón. La imagen se procesa '
          'en tu navegador y no se envía ni se guarda.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
