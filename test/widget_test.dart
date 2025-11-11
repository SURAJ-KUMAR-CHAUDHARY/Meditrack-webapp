// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  // Pump the Dashboard directly (avoids splash timer in the app's initial route).
  await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

  // Verify that the dashboard shows the app title in the AppBar.
  expect(find.text('MediTrack'), findsWidgets);
  });
}
