import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('saves a waste entry without leaving the dialog in a bad state', (
    tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar desperdício'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Pizza');
    await tester.enterText(find.byType(TextField).at(1), '1,5');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Motivo: Sobra'), findsOneWidget);
    expect(find.text('Total desperdiçado: 1.5 kg'), findsOneWidget);
  });
}
