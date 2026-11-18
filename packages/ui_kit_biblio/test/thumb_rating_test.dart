import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit_biblio/ui_kit_biblio.dart';

Widget _envolver(Widget hijo) => MaterialApp(home: Scaffold(body: hijo));

void main() {
  group('ThumbRating (widget)', () {
    testWidgets('pulgar arriba envía 1', (tester) async {
      final valores = <int>[];
      await tester.pumpWidget(_envolver(ThumbRating(onChanged: valores.add)));

      await tester.tap(find.byIcon(Icons.thumb_up_outlined));
      await tester.pump();

      expect(valores, [1]);
      expect(find.byIcon(Icons.thumb_up), findsOneWidget); // icono relleno
    });

    testWidgets('pulgar abajo envía -1', (tester) async {
      final valores = <int>[];
      await tester.pumpWidget(_envolver(ThumbRating(onChanged: valores.add)));

      await tester.tap(find.byIcon(Icons.thumb_down_outlined));
      await tester.pump();

      expect(valores, [-1]);
    });

    testWidgets('pulsar dos veces el mismo pulgar lo deselecciona (0)',
        (tester) async {
      final valores = <int>[];
      await tester.pumpWidget(_envolver(ThumbRating(onChanged: valores.add)));

      await tester.tap(find.byIcon(Icons.thumb_up_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.thumb_up));
      await tester.pump();

      expect(valores, [1, 0]);
      expect(find.byIcon(Icons.thumb_up_outlined), findsOneWidget);
    });

    testWidgets('empieza con el valor inicial recibido', (tester) async {
      await tester.pumpWidget(_envolver(
        ThumbRating(initialValue: -1, onChanged: (_) {}),
      ));

      expect(find.byIcon(Icons.thumb_down), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_outlined), findsOneWidget);
    });

    testWidgets('golden: aspecto de los pulgares', (tester) async {
      await tester.pumpWidget(_envolver(
        Center(child: ThumbRating(initialValue: 1, onChanged: (_) {})),
      ));

      await expectLater(
        find.byType(ThumbRating),
        matchesGoldenFile('goldens/thumb_rating.png'),
      );
    });
  });

  group('ThumbRating (validaciones)', () {
    test('initialValue fuera de rango lanza AssertionError', () {
      expect(
        () => ThumbRating(initialValue: 2, onChanged: (_) {}),
        throwsAssertionError,
      );
    });

    test('iconSize menor o igual que 0 lanza AssertionError', () {
      expect(
        () => ThumbRating(iconSize: 0, onChanged: (_) {}),
        throwsAssertionError,
      );
    });
  });
}
