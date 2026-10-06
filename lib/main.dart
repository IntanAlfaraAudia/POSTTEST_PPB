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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4AF37)),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

// Model data untuk produk perhiasan
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imagePath;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    this.quantity = 0,
  });
}

// StatefulWidget: Mengelola state navigasi dan daftar produk reaktif
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // State: Index tab navigasi aktif
  int _currentIndex = 0;

  // State: Daftar katalog produk perhiasan mewah
  final List<Product> products = [
    Product(id: '1', name: 'Cincin Berlian Royal', category: 'Cincin 18K', price: 12000000, imagePath: 'assets/ring.jpg'),
    Product(id: '2', name: 'Kalung Emas Mutiara', category: 'Kalung Eksklusif', price: 18500000, imagePath: 'assets/necklace.jpg'),
    Product(id: '3', name: 'Gelang Emas Berlian', category: 'Gelang Mewah', price: 15000000, imagePath: 'assets/bracelet.jpg'),
    Product(id: '4', name: 'Anting Safir Berlian', category: 'Anting Permata', price: 9500000, imagePath: 'assets/earrings.jpg'),
  ];

  // Fungsi menambah jumlah produk ke keranjang
  void addToCart(Product product) {
    setState(() {
      product.quantity++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} berhasil ditambahkan!'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    );
  }

  // Fungsi memperbarui kuantitas langsung dari keranjang
  void updateQuantity(Product product, int newQty) {
    setState(() {
      product.quantity = newQty;
    });
  }

  // Menghitung total harga keseluruhan secara reaktif (derived state)
  double get grandTotal {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Menghitung total item di keranjang untuk badge navigasi
  int get totalItems {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    // List halaman aplikasi
    final List<Widget> pages = [
      HomePage(products: products, onAddToCart: addToCart),
      CartPage(
        products: products.where((p) => p.quantity > 0).toList(),
        grandTotal: grandTotal,
        onQuantityChanged: updateQuantity,
        onCheckout: () {
          setState(() {
            for (var p in products) {
              p.quantity = 0; // Reset keranjang setelah checkout
            }
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Checkout Berhasil'),
              content: const Text('Pesanan perhiasan mewah Aurora Gold Anda sedang diproses.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    ];

    // Scaffold: Kerangka dasar halaman
    return Scaffold(
      body: pages[_currentIndex],
      // BottomNavigationBar: Widget navigasi bawah dengan badge jumlah item
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.diamond_outlined),
            activeIcon: Icon(Icons.diamond),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: totalItems > 0,
              label: Text('$totalItems'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: totalItems > 0,
              label: Text('$totalItems'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}

// ================= HALAMAN KELAS BERANDA (KATALOG) =================
class HomePage extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart;

  const HomePage({super.key, required this.products, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    // SafeArea: Menjaga konten dari poni layar
    return SafeArea(
      // SingleChildScrollView: Membuat halaman katalog bisa di-scroll
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        // Column: Menyusun teks header dan grid produk secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text: Judul utama toko
            const Text(
              'Aurora Gold',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            // Text: Subjudul deskripsi singkat
            const Text('Koleksi Perhiasan Mewah & Eksklusif', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            
            // GridView.builder: Menyusun katalog produk dalam bentuk grid 2 kolom yang rapi
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                // InkWell: Memberikan efek sentuhan saat produk ditekan untuk melihat detail
                return InkWell(
                  onTap: () {
                    // Navigator.push: Berpindah ke halaman detail produk
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
                    );
                  },
                  // Card: Kartu pembungkus produk dengan sudut melengkung
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      // Column: Menyusun gambar, nama, kategori, harga, dan tombol dalam card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded: Memaksa area gambar mengambil ruang fleksibel
                          Expanded(
                            // ClipRRect: Melengkungkan sudut gambar produk
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              // Image.asset: Memuat gambar produk dari folder lokal
                              child: Image.asset(
                                product.imagePath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Text: Kategori produk
                          Text(product.category, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          // Text: Nama produk
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
                          const SizedBox(height: 4),
                          // Text: Harga produk
                          Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 6),
                          
                          // SizedBox: Tombol beli cepat
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            // ElevatedButton: Tombol tambah ke keranjang
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A1A),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => onAddToCart(product),
                              child: const Text('Beli', style: TextStyle(fontSize: 12)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HALAMAN DETAIL PRODUK =================
class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Scaffold: Kerangka halaman detail produk
    return Scaffold(
      // AppBar: Bilah atas halaman detail
      appBar: AppBar(
        title: const Text('Detail Perhiasan'),
        backgroundColor: Colors.white,
        // IconButton: Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop: Kembali ke halaman katalog sebelumnya
            Navigator.pop(context);
          },
        ),
      ),
      // SingleChildScrollView: Agar konten detail aman dari overflow
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        // Column: Menyusun detail produk secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect: Melengkungkan sudut gambar besar di halaman detail
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              // Image.asset: Menampilkan gambar besar produk
              child: Image.asset(
                product.imagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // Text: Kategori produk
            Text(product.category.toUpperCase(), style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 6),
            // Text: Nama produk lengkap
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Text: Harga produk
            Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 20),
            // Text: Deskripsi produk
            const Text(
              'Perhiasan mewah asli bersertifikat dengan balutan emas pilihan dan tatahan batu mulia berkualitas tinggi. Dirancang khusus untuk memberikan kilau elegan di setiap momen spesial Anda.',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HALAMAN KERANJANG =================
class CartPage extends StatelessWidget {
  final List<Product> products;
  final double grandTotal;
  final Function(Product, int) onQuantityChanged;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.products,
    required this.grandTotal,
    required this.onQuantityChanged,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold: Kerangka halaman keranjang belanja
    return Scaffold(
      // AppBar: Bilah atas keranjang
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      // Stack: Menumpuk daftar item belanja di belakang dan bar checkout melayang di depan
      body: Stack(
        children: [
          // SingleChildScrollView: Area daftar keranjang yang bisa digulir
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            child: products.isNotEmpty
                // ListView.builder alternatif dengan shrinkWrap untuk menampilkan item keranjang
                ? ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      // Card: Kartu untuk setiap item di keranjang
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          // Row: Menyusun gambar, detail, dan input jumlah secara horizontal
                          child: Row(
                            children: [
                              // Image.asset: Thumbnail gambar produk di keranjang
                              Image.asset(product.imagePath, width: 65, height: 65, fit: BoxFit.cover),
                              const SizedBox(width: 12),
                              // Expanded: Memperluas ruang teks nama dan harga item
                              Expanded(
                                // Column: Menyusun nama dan harga item secara vertikal
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text: Nama item keranjang
                                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    // Text: Harga satuan item
                                    Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
                                  ],
                                ),
                              ),
                              // SizedBox: Mengatur lebar area input teks jumlah produk
                              SizedBox(
                                width: 45,
                                height: 40,
                                // TextField: Input angka kuantitas produk reaktif
                                child: TextField(
                                  controller: TextEditingController(text: '${product.quantity}')..selection = TextSelection.fromPosition(TextPosition(offset: '${product.quantity}'.length)),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    final parsed = int.tryParse(value);
                                    if (parsed != null && parsed >= 0) {
                                      onQuantityChanged(product, parsed);
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    // Text: Tampilan jika keranjang belanja kosong
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text('Keranjang Anda masih kosong.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ),
          ),
          
          // Positioned: Menempelkan bar total harga dan tombol checkout di bagian paling bawah layar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // Container: Kontainer latar belakang bar pembayaran
            child: Container(
              padding: const EdgeInsets.all(20),
              // BoxDecoration: Dekorasi latar putih dengan sudut atas melengkung
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                // BoxShadow: Efek bayangan melayang agar kontras dengan latar belakang
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              // Row: Menyusun informasi nominal total dan tombol checkout secara horizontal
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column: Menampilkan label total harga dan nominalnya
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text: Label keterangan total
                      const Text('Total Harga', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 2),
                      // Text: Nominal Grand Total reaktif
                      Text(
                        'Rp${grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  // ElevatedButton: Tombol checkout turunan (aktif otomatis jika grandTotal > 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: grandTotal > 0 ? onCheckout : null,
                    child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}