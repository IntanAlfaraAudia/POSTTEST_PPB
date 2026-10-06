import 'package:flutter_test/flutter_test.dart';
// Sesuaikan nama package di bawah ini dengan nama proyek Anda
import 'package:POSTTEST3_2409106008_IntanAlfaraAudia/main.dart';

void main() {
  testWidgets('Aurora Gold Posttest smoke test', (WidgetTester tester) async {
    // Membangun aplikasi Aurora Gold
    await tester.pumpWidget(const AuroraGoldApp());

    // Memverifikasi apakah teks 'Aurora Gold' muncul di layar
    expect(find.text('Aurora Gold'), findsWidgets);

    // Memverifikasi apakah teks 'Keranjang' pada BottomNavigationBar muncul
    expect(find.text('Keranjang'), findsWidgets);
  });
}