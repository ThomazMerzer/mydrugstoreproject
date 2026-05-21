// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mydrugstoreproject/main.dart';

void main() {
  testWidgets('Pharmacist workplace smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PharmacistWorkplaceApp());

    // Verify that the app title is displayed
    expect(find.text('Рабочее место фармацевта'), findsOneWidget);
    
    // Verify that the cart is empty initially
    expect(find.text('Чек пуст. Отсканируйте штрихкод или QR-код товара.'), findsOneWidget);
    
    // Verify that mode buttons are present
    expect(find.text('Режим продаж'), findsOneWidget);
    expect(find.text('Режим приемки'), findsOneWidget);
    expect(find.text('Энциклопедия'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Добавить товар'), findsOneWidget);
  });
}
