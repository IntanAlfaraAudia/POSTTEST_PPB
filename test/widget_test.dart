import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Aurora Gold Posttest 2 smoke test', (WidgetTester tester) async {
    // Membangun aplikasi Aurora Gold
    await tester.pumpWidget(const AuroraGoldApp());

    // Memverifikasi apakah teks 'Koleksi Aurora Gold' (di halaman Beranda) muncul di layar
    expect(find.text('Koleksi Aurora Gold'), findsWidgets);
    
    // Memverifikasi apakah teks 'Keranjang' pada BottomNavigationBar muncul
    expect(find.text('Keranjang'), findsWidgets);
  });
}