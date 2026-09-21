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
  testWidgets('Aurora Gold smoke test', (WidgetTester tester) async {
    // Membangun aplikasi Aurora Gold dan memicu frame.
    // Menggunakan AuroraGoldApp sesuai nama class MaterialApp di main.dart Anda.
    await tester.pumpWidget(const AuroraGoldApp());

    // Memverifikasi apakah teks judul 'Aurora Gold' muncul di layar.
    expect(find.text('Aurora Gold'), findsOneWidget);

    // Memverifikasi apakah elemen pencarian (hintText) atau teks koleksi muncul.
    expect(find.text('Koleksi Eksklusif'), findsOneWidget);
  });
}