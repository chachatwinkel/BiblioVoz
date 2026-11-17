import 'package:flutter/material.dart';
import 'package:ui_kit_biblio/ui_kit_biblio.dart';
import 'package:widgetbook/widgetbook.dart';

void main() => runApp(const CatalogoBiblio());

/// Marco común: da un Scaffold (para los IconButton) y un ancho razonable.
Widget _caja(Widget hijo) => Scaffold(
      body: Center(child: SizedBox(width: 420, child: hijo)),
    );

class CatalogoBiblio extends StatelessWidget {
  const CatalogoBiblio({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookComponent(
          name: 'BookCard',
          useCases: [
            WidgetbookUseCase(
              name: 'Disponible',
              builder: (context) => _caja(
                const BookCard(title: 'Dune', author: 'Frank Herbert'),
              ),
            ),
            WidgetbookUseCase(
              name: 'Prestado (botón desactivado)',
              builder: (context) => _caja(
                const BookCard(
                  title: 'Dune',
                  author: 'Frank Herbert',
                  borrowed: true,
                ),
              ),
            ),
            WidgetbookUseCase(
              name: 'Título muy largo (se recorta)',
              builder: (context) => _caja(
                const BookCard(
                  title: 'Harry Potter y la piedra filosofal, edición '
                      'ilustrada del vigésimo aniversario con notas del autor',
                  author: 'J.K. Rowling',
                ),
              ),
            ),
            WidgetbookUseCase(
              name: 'Textos en español',
              builder: (context) => _caja(
                const BookCard(
                  title: 'El Hobbit',
                  author: 'J.R.R. Tolkien',
                  borrowed: true,
                  borrowedLabel: 'Prestado',
                  availableLabel: 'Disponible',
                  loanTooltip: 'Prestar',
                ),
              ),
            ),
            WidgetbookUseCase(
              name: 'Eventos onTap y onLoan',
              builder: (context) => _caja(
                Builder(
                  builder: (ctx) => BookCard(
                    title: 'Fundación',
                    author: 'Isaac Asimov',
                    onTap: () => ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('onTap: se abre la ficha')),
                    ),
                    onLoan: () => ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('onLoan: se presta el libro')),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        WidgetbookComponent(
          name: 'ThumbRating',
          useCases: [
            WidgetbookUseCase(
              name: 'Sin valorar',
              builder: (context) => _caja(
                Center(child: ThumbRating(onChanged: (_) {})),
              ),
            ),
            WidgetbookUseCase(
              name: 'Pulgar arriba',
              builder: (context) => _caja(
                Center(child: ThumbRating(initialValue: 1, onChanged: (_) {})),
              ),
            ),
            WidgetbookUseCase(
              name: 'Pulgar abajo',
              builder: (context) => _caja(
                Center(child: ThumbRating(initialValue: -1, onChanged: (_) {})),
              ),
            ),
            WidgetbookUseCase(
              name: 'Iconos pequeños',
              builder: (context) => _caja(
                Center(
                  child: ThumbRating(iconSize: 32, onChanged: (_) {}),
                ),
              ),
            ),
            WidgetbookUseCase(
              name: 'Evento onChanged',
              builder: (context) {
                var ultimo = 'ninguno';
                return _caja(
                  StatefulBuilder(
                    builder: (context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ThumbRating(
                          onChanged: (v) => setState(() => ultimo = '$v'),
                        ),
                        const SizedBox(height: 12),
                        Text('Último valor recibido: $ultimo'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}