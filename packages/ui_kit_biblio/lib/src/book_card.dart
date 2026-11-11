import 'package:flutter/material.dart';

/// Tarjeta de un libro con portada, título, autor y estado de préstamo.
///
/// Ejemplo de uso:
///
/// ```dart
/// BookCard(
///   title: 'Dune',
///   author: 'Frank Herbert',
///   borrowed: false,
///   onTap: () => print('abrir la ficha'),
///   onLoan: () => print('prestar el libro'),
/// )
/// ```
class BookCard extends StatelessWidget {
  /// Crea una tarjeta de libro.
  ///
  /// [title] y [author] son obligatorios y [title] no puede estar vacío.
  /// Si [borrowed] es `true`, el botón de prestar queda desactivado.
  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.borrowed = false,
    this.onTap,
    this.onLoan,
    this.borrowedLabel = 'Borrowed',
    this.availableLabel = 'Available',
    this.loanTooltip = 'Lend',
  }) : assert(title != '', 'title no puede estar vacío');

  /// Título del libro.
  final String title;

  /// Autor del libro.
  final String author;

  /// Indica si el libro está prestado. Por defecto, `false` (disponible).
  final bool borrowed;

  /// Se dispara cuando el usuario pulsa la tarjeta.
  final VoidCallback? onTap;

  /// Se dispara cuando el usuario pulsa el botón de prestar.
  /// Nunca se dispara si [borrowed] es `true`.
  final VoidCallback? onLoan;

  /// Texto del estado cuando el libro está prestado.
  final String borrowedLabel;

  /// Texto del estado cuando el libro está disponible.
  final String availableLabel;

  /// Texto de ayuda del botón de prestar.
  final String loanTooltip;

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
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('$author · ${borrowed ? borrowedLabel : availableLabel}'),
        trailing: IconButton(
          tooltip: loanTooltip,
          icon: const Icon(Icons.outbox),
          onPressed: borrowed ? null : onLoan,
        ),
      ),
    );
  }
}