import 'package:flutter/material.dart';

import 'db.dart';

/// Tarjeta de libro: portada, título y estado de préstamo.
/// [onTap] se dispara al pulsar la tarjeta; [onLoan] al pulsar el botón de prestar.
class BookCard extends StatelessWidget {
  final Libro libro;
  final bool prestado;
  final VoidCallback? onTap;
  final VoidCallback? onLoan;

  const BookCard({
    super.key,
    required this.libro,
    this.prestado = false,
    this.onTap,
    this.onLoan,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 60,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.menu_book, color: cs.onPrimaryContainer),
        ),
        title: Text(libro.titulo),
        subtitle: Text('${libro.autor} · ${prestado ? 'Prestado' : 'Disponible'}'),
        trailing: IconButton(
          tooltip: 'Prestar',
          icon: const Icon(Icons.outbox),
          onPressed: prestado ? null : onLoan,
        ),
      ),
    );
  }
}

/// Valoración con pulgar. [onChanged] recibe -1 (abajo), 0 (nada) o 1 (arriba)
/// cada vez que el usuario pulsa un pulgar.
class ThumbRating extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const ThumbRating({super.key, this.initialValue = 0, required this.onChanged});

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
          iconSize: 56,
          tooltip: 'Pulgar abajo',
          isSelected: _valor == -1,
          icon: const Icon(Icons.thumb_down_outlined),
          selectedIcon: const Icon(Icons.thumb_down),
          onPressed: () => _cambiar(-1),
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: 56,
          tooltip: 'Pulgar arriba',
          isSelected: _valor == 1,
          icon: const Icon(Icons.thumb_up_outlined),
          selectedIcon: const Icon(Icons.thumb_up),
          onPressed: () => _cambiar(1),
        ),
      ],
    );
  }
}
