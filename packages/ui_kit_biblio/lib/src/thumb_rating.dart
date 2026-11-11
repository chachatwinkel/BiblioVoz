import 'package:flutter/material.dart';

/// Evento de [ThumbRating]: recibe -1 (pulgar abajo), 0 (sin valorar)
/// o 1 (pulgar arriba).
typedef RatingChanged = ValueChanged<int>;

/// Valoración con pulgar arriba o abajo.
///
/// Pulsar el pulgar que ya está seleccionado lo deselecciona (valor 0).
///
/// Ejemplo de uso:
///
/// ```dart
/// ThumbRating(
///   initialValue: 0,
///   onChanged: (valor) => print('valoración: $valor'),
/// )
/// ```
class ThumbRating extends StatefulWidget {
  /// Crea un selector de pulgar.
  ///
  /// [initialValue] debe estar entre -1 y 1 y [iconSize] debe ser mayor que 0.
  const ThumbRating({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    this.iconSize = 56,
    this.downTooltip = 'Thumbs down',
    this.upTooltip = 'Thumbs up',
  })  : assert(initialValue >= -1 && initialValue <= 1,
            'initialValue debe estar entre -1 y 1'),
        assert(iconSize > 0, 'iconSize debe ser mayor que 0');

  /// Valor con el que empieza el componente. Por defecto, 0 (sin valorar).
  final int initialValue;

  /// Se dispara cada vez que el usuario pulsa un pulgar, con el valor nuevo.
  final RatingChanged onChanged;

  /// Tamaño de los iconos. Por defecto, 56.
  final double iconSize;

  /// Texto de ayuda del pulgar abajo.
  final String downTooltip;

  /// Texto de ayuda del pulgar arriba.
  final String upTooltip;

  @override
  State<ThumbRating> createState() => _ThumbRatingState();
}

class _ThumbRatingState extends State<ThumbRating> {
  late int _valor = widget.initialValue;

  void _cambiar(int nuevo) {
    setState(() => _valor = _valor == nuevo ? 0 : nuevo);
    widget.onChanged(_valor);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: widget.iconSize,
          tooltip: widget.downTooltip,
          isSelected: _valor == -1,
          icon: const Icon(Icons.thumb_down_outlined),
          selectedIcon: const Icon(Icons.thumb_down),
          onPressed: () => _cambiar(-1),
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: widget.iconSize,
          tooltip: widget.upTooltip,
          isSelected: _valor == 1,
          icon: const Icon(Icons.thumb_up_outlined),
          selectedIcon: const Icon(Icons.thumb_up),
          onPressed: () => _cambiar(1),
        ),
      ],
    );
  }
}