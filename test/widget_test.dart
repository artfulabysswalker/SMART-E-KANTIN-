// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ekantin/main.dart';

void main() {
  testWidgets('App starts and shows a widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This test will fail if Firebase isn't initialized.
    // For real-world apps, you'd mock Firebase for testing.
    await tester.pumpWidget(const MyApp());

    // Verify that the MaterialApp widget is present.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
