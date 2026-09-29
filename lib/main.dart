import 'package:flutter/material.dart';

void main() {
  runApp(const AuroraGoldApp());
}

// MaterialApp: Widget wrapper utama aplikasi
class AuroraGoldApp extends StatelessWidget {
  const AuroraGoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Gold',
      debugShowCheckedModeBanner: false,
      // Mengatur tema warna mewah (Hitam dan Emas)
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Warna latar abu-abu sangat muda
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // Warna Emas Premium
          primary: const Color(0xFFD4AF37),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

// StatefulWidget: Digunakan agar BottomNavigationBar bisa mengubah halaman
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Variabel penentu index tab navigasi
  int _currentIndex = 0;

  // List halaman untuk Navigation Bar
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(), // Halaman Studi Kasus Modul 3
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: Struktur dasar halaman aplikasi
    return Scaffold(
      body: _pages[_currentIndex],
      
      // BottomNavigationBar: Widget navigasi di bagian bawah layar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD4AF37), // Warna emas saat aktif
        unselectedItemColor: Colors.grey.shade400,
        elevation: 10,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.diamond_outlined), // Ikon bernuansa perhiasan
            activeIcon: Icon(Icons.diamond),
            label: 'Eksklusif',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}

// ================= HALAMAN 1: BERANDA (TAMPILAN MEWAH) =================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // SafeArea: Menghindari konten tertutup poni/notch layar
    return SafeArea(
      // SingleChildScrollView: Agar layar tidak error jika ditarik ke bawah
      child: SingleChildScrollView(
        // Padding: Memberikan jarak tepi konten
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // Column: Menyusun widget secara vertikal
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text: Menampilkan judul halaman
              const Text(
                'Aurora Gold',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w800, 
                  letterSpacing: 1.5,
                  color: Color(0xFF1A1A1A)
                ),
              ),
              const Text(
                'Koleksi Perhiasan Eksklusif',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // SizedBox: Memberikan jarak kosong vertikal
              const SizedBox(height: 30),
              
              // Container: Kartu promo mewah
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A), // Hitam elegan
                  borderRadius: BorderRadius.circular(16),
                  // BoxShadow: Widget Modul 3 untuk bayangan
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cincin Berlian Royal\nEdisi Terbatas',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 16),
                    // ElevatedButton: Tombol untuk memicu navigasi
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37), // Tombol emas
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Navigator.push: Berpindah halaman ke navigation stack (Modul 3)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DetailPage()),
                        );
                      },
                      child: const Text('Lihat Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HALAMAN DETAIL =================
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar: Bilah atas halaman detail
      appBar: AppBar(
        title: const Text('Detail Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        centerTitle: true,
        // IconButton: Tombol ikon untuk aksi kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // Navigator.pop: Kembali dengan menghapus halaman dari stack (Modul 3)
            Navigator.pop(context);
          },
        ),
      ),
      // Center: Menengahkan letak widget anak
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset: Menampilkan gambar perhiasan di halaman detail (Modul 3)
            Image.asset('assets/product.jpg', height: 200),
            const SizedBox(height: 20),
            const Text('Cincin Berlian Royal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Emas 18 Karat - Desain Premium', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ================= HALAMAN 2: KERANJANG (STUDI KASUS MODUL 3) =================
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      // Stack: Widget Modul 3 untuk menumpuk list produk di belakang dan total harga di atasnya
      body: Stack(
        children: [
          // SingleChildScrollView: Memungkinkan daftar produk bisa di-scroll
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
            child: Column(
              children: [
                _buildCartItem(),
                const SizedBox(height: 16),
                _buildCartItem(),
                const SizedBox(height: 16),
                _buildCartItem(),
              ],
            ),
          ),
          
          // Positioned: Widget Modul 3 mengatur letak baris total di bawah layar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // Container: Membungkus bar ringkasan harga
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                // BoxShadow: Widget Modul 3 untuk efek bayangan melayang
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              // Row: Menyusun teks total harga dan tombol checkout horizontal
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Total Harga', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        'Rp 12.000.000',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A), 
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shopping_bag, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat kartu produk di keranjang yang estetik
  Widget _buildCartItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: Bayangan halus pada setiap item keranjang (Modul 3)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ClipRRect: Memotong sudut gambar agar melengkung rapi
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            // Image.asset: Widget Modul 3 memuat gambar dari assets
            child: Image.asset(
              'assets/product.jpg',
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Expanded: Memaksa widget teks memenuhi ruang horizontal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cincin Berlian Royal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                const Text('Emas Kuning 18K', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Rp 12.000.000', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFD4AF37), fontSize: 14)),
              ],
            ),
          ),
          // SizedBox mengatur ukuran area input text
          SizedBox(
            width: 45,
            height: 45,
            // TextField: Modul 3 mengatur input hanya angka
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: '1',
              ),
            ),
          )
        ],
      ),
    );
  }
}