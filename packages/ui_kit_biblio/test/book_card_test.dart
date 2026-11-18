import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit_biblio/ui_kit_biblio.dart';

Widget _envolver(Widget hijo) => MaterialApp(home: Scaffold(body: hijo));

void main() {
  group('BookCard (widget)', () {
    testWidgets('muestra título, autor y estado disponible', (tester) async {
      await tester.pumpWidget(_envolver(
        const BookCard(title: 'Dune', author: 'Frank Herbert'),
      ));

      expect(find.text('Dune'), findsOneWidget);
      expect(find.text('Frank Herbert · Available'), findsOneWidget);
    });

    testWidgets('muestra el estado prestado con los textos recibidos',
        (tester) async {
      await tester.pumpWidget(_envolver(
        const BookCard(
          title: 'Dune',
          author: 'Frank Herbert',
          borrowed: true,
          borrowedLabel: 'Prestado',
        ),
      ));

      expect(find.text('Frank Herbert · Prestado'), findsOneWidget);
    });

    testWidgets('onTap se dispara al pulsar la tarjeta', (tester) async {
      var pulsado = false;
      await tester.pumpWidget(_envolver(
        BookCard(
          title: 'Dune',
          author: 'Frank Herbert',
          onTap: () => pulsado = true,
        ),
      ));

      await tester.tap(find.text('Dune'));
      expect(pulsado, isTrue);
    });

    testWidgets('onLoan se dispara si el libro está disponible',
        (tester) async {
      var prestado = false;
      await tester.pumpWidget(_envolver(
        BookCard(
          title: 'Dune',
          author: 'Frank Herbert',
          onLoan: () => prestado = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.outbox));
      expect(prestado, isTrue);
    });

    testWidgets('onLoan no se dispara si el libro está prestado',
        (tester) async {
      var prestado = false;
      await tester.pumpWidget(_envolver(
        BookCard(
          title: 'Dune',
          author: 'Frank Herbert',
          borrowed: true,
          onLoan: () => prestado = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.outbox));
      expect(prestado, isFalse);
    });

    testWidgets('golden: aspecto de la tarjeta', (tester) async {
      await tester.pumpWidget(_envolver(
        const BookCard(title: 'Dune', author: 'Frank Herbert'),
      ));

      await expectLater(
        find.byType(BookCard),
        matchesGoldenFile('goldens/book_card.png'),
      );
    });
  });

  group('BookCard (validaciones)', () {
    test('un título vacío lanza AssertionError', () {
      const vacio = '';
      expect(
        () => BookCard(title: vacio, author: 'Frank Herbert'),
        throwsAssertionError,
      );
    });
  });
}
