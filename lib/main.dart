import 'package:flutter/material.dart';

void main() {
  runApp(const AuroraGoldApp());
}

// MaterialApp: Widget wrapper utama dari aplikasi yang dibangun menggunakan Flutter
class AuroraGoldApp extends StatelessWidget {
  const AuroraGoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Gold',
      debugShowCheckedModeBanner: false, // Menonaktifkan tulisan debug di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: Struktur dasar halaman aplikasi mobile
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      
      // AppBar: Bar di bagian atas aplikasi yang berisi judul
      appBar: AppBar(
        title: const Text(
          'Aurora Gold',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      // SafeArea: Memastikan konten tidak tertutup oleh area notch/sistem perangkat
      body: SafeArea(
        // SingleChildScrollView: Memungkinkan halaman utama dapat di-scroll secara vertikal
        child: SingleChildScrollView(
          child: Padding(
            // Padding: Memberikan jarak ruang di sekeliling konten utama
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // TextField: Widget untuk input teks pencarian perhiasan
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kalung, cincin, berlian...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    // SuffixIcon: Menampilkan ikon pencarian di ujung kanan TextField
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
                ),
                
                // SizedBox: Memberikan jarak kosong vertikal antar widget
                const SizedBox(height: 20),
                
                // Text: Judul bagian koleksi unggulan
                const Text(
                  'Koleksi Eksklusif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Column: Menyusun daftar card produk perhiasan secara vertikal
                Column(
                  children: [
                    _buildJewelryCard(
                      name: 'Cincin Berlian Royal Gold',
                      category: 'Cincin 18K Yellow Gold',
                      price: 'Rp14.500.000',
                    ),
                    const SizedBox(height: 12),
                    _buildJewelryCard(
                      name: 'Kalung Emas Aurora Classic',
                      category: 'Kalung Mewah Berkilau',
                      price: 'Rp8.200.000',
                    ),
                    const SizedBox(height: 12),
                    _buildJewelryCard(
                      name: 'Gelang Permata Diamond Luxe',
                      category: 'Gelang Berlian Eropa',
                      price: 'Rp21.000.000',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      
      // BottomNavigationBar: Navigasi di bagian bawah layar aplikasi
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.amber.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // Widget helper untuk merakit Card Produk Perhiasan
  Widget _buildJewelryCard({required String name, required String category, required String price}) {
    // Container: Membungkus elemen card untuk mengatur dekorasi, warna latar, border, dan radius
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade100),
      ),
      // Row: Menyusun gambar produk di kiri dan detail teks di kanan secara horizontal
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container sebagai placeholder gambar perhiasan
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.diamond, size: 40, color: Colors.amber.shade700),
          ),
          
          const SizedBox(width: 12),
          
          // Expanded: Memaksa widget anak mengisi sisa ruang secara horizontal di dalam Row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: Menampilkan nama produk perhiasan
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Text: Menampilkan kategori atau deskripsi singkat perhiasan
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // Text: Menampilkan harga perhiasan
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Container sebagai tombol "Masukkan Keranjang" kustom
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // Row di dalam tombol untuk menyusun ikon dan teks tombol secara horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Masukkan Keranjang',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}