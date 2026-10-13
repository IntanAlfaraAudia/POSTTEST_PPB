import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Nyediain state provider secara global ke seluruh widget di bawahnya
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const AuroraGoldApp(),
    ),
  );
}

// Model data buat produk perhiasan
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imagePath;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.stock,
  });
}

// Provider buat ngatur data keranjang, stok, kategori, dan pencarian
class CartProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', name: 'Cincin Berlian Royal', category: 'Cincin', price: 12000000, imagePath: 'assets/ring.jpg', stock: 5),
    Product(id: '2', name: 'Kalung Emas Mutiara', category: 'Kalung', price: 18500000, imagePath: 'assets/necklace.jpg', stock: 3),
    Product(id: '3', name: 'Gelang Emas Berlian', category: 'Gelang', price: 15000000, imagePath: 'assets/bracelet.jpg', stock: 4),
    Product(id: '4', name: 'Anting Safir Berlian', category: 'Anting', price: 9500000, imagePath: 'assets/earrings.jpg', stock: 6),
    Product(id: '5', name: 'Cincin Solitaire Mewah', category: 'Cincin', price: 21000000, imagePath: 'assets/diamond_ring.jpg', stock: 2),
    Product(id: '6', name: 'Gelang Emas Klasik 24K', category: 'Gelang', price: 14000000, imagePath: 'assets/gold_bangle.jpg', stock: 5),
    Product(id: '7', name: 'Kalung Mutiara Laut Selatan', category: 'Kalung', price: 25000000, imagePath: 'assets/pearl_necklace.jpg', stock: 3),
    Product(id: '8', name: 'Anting Safir Biru Royal', category: 'Anting', price: 11000000, imagePath: 'assets/sapphire_earrings.jpg', stock: 4),
    Product(id: '9', name: 'Bros Emas Tabur Berlian', category: 'Bros', price: 8500000, imagePath: 'assets/brooch.jpg', stock: 7),
  ];

  List<Product> get products => _products;

  // Nyimpen jumlah item di keranjang pakai map (id produk -> jumlah)
  final Map<String, int> _cartQuantities = {};
  Map<String, int> get cartQuantities => _cartQuantities;

  // State buat nyari produk sama filter kategori
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'Semua';
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Fungsi buat nambahin barang ke keranjang sekaligus ngurangin stok
  void addToCart(Product product) {
    if (product.stock <= 0) return;
    product.stock--;
    _cartQuantities[product.id] = (_cartQuantities[product.id] ?? 0) + 1;
    notifyListeners(); // Ngasih tahu UI kalau ada perubahan data
  }

  // Fungsi buat update jumlah produk langsung dari keranjang
  void updateQuantity(Product product, int newQty) {
    int currentQty = _cartQuantities[product.id] ?? 0;
    if (newQty > currentQty) {
      int diff = newQty - currentQty;
      if (product.stock >= diff) {
        product.stock -= diff;
        _cartQuantities[product.id] = newQty;
      }
    } else if (newQty < currentQty) {
      int diff = currentQty - newQty;
      product.stock += diff;
      if (newQty <= 0) {
        _cartQuantities.remove(product.id);
      } else {
        _cartQuantities[product.id] = newQty;
      }
    }
    notifyListeners();
  }

  // Hitung total harga belanjaan secara otomatis
  double get grandTotal {
    double total = 0;
    _cartQuantities.forEach((productId, qty) {
      final product = _products.firstWhere((p) => p.id == productId);
      total += product.price * qty;
    });
    return total;
  }

  // Hitung total item buat badge di menu bawah
  int get totalItems {
    int total = 0;
    _cartQuantities.forEach((_, qty) => total += qty);
    return total;
  }

  // Kosongin keranjang pas udah checkout
  void checkout() {
    _cartQuantities.clear();
    notifyListeners();
  }
}

// Widget utama aplikasi
class AuroraGoldApp extends StatelessWidget {
  const AuroraGoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp buat ngatur tema dan halaman awal
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

// State buat ngatur navigasi tab bawah
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold buat nampilin kerangka halaman dan menu navigasi bawah
    return Scaffold(
      body: _pages[_currentIndex],
      // Container pembungkus bottom nav biar ada bayangannya
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        // Consumer buat mantau jumlah keranjang secara reaktif
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFFD4AF37),
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_outlined),
                  activeIcon: Icon(Icons.storefront),
                  label: 'Katalog',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: cart.totalItems > 0,
                    label: Text('${cart.totalItems}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: cart.totalItems > 0,
                    label: Text('${cart.totalItems}'),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  label: 'Keranjang',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Halaman utama buat nampilin katalog produk
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Cincin', 'Kalung', 'Gelang', 'Anting', 'Bros'];

    // SafeArea biar konten gak tertutup notch HP
    return SafeArea(
      // SingleChildScrollView biar halamannya bisa di-scroll
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        // Column buat nyusun layout dari atas ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row buat header judul toko sama icon profil
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Aurora Gold',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Color(0xFF1A1A1A)),
                    ),
                    SizedBox(height: 2),
                    Text('Luxury & Elegance Collection', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                // CircleAvatar buat nampilin logo toko buatan
                const CircleAvatar(
                  backgroundColor: Color(0xFFD4AF37),
                  radius: 20,
                  child: Icon(Icons.diamond, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // TextField buat kotak pencarian produk
            TextField(
              onChanged: (value) => context.read<CartProvider>().setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Cari koleksi perhiasan mewah...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Container buat banner promo toko
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Diskon Spesial 20%', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Koleksi Emas Murni 24K', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Garansi keaslian sertifikat internasional.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SizedBox buat bungkus list kategori kesamping
            SizedBox(
              height: 38,
              // ListView horizontal buat pilihan kategori
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      bool isSelected = cart.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        // ChoiceChip buat tombol filter kategori
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFFD4AF37),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                          onSelected: (selected) {
                            cart.setSelectedCategory(cat);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Consumer buat ngambil data produk yang sesuai filter pencarian/kategori
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                final visibleProducts = cart.products.where((product) {
                  bool matchesSearch = product.name.toLowerCase().contains(cart.searchQuery);
                  bool matchesCategory = cart.selectedCategory == 'Semua' || product.category == cart.selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (visibleProducts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Perhiasan tidak ditemukan.', style: TextStyle(color: Colors.grey))),
                  );
                }

                // GridView.builder buat nampilin produk jadi 3 kolom rapat proporsional
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: visibleProducts.length,
                  itemBuilder: (context, index) {
                    final product = visibleProducts[index];
                    // InkWell biar card bisa diklik buat buka detail
                    return InkWell(
                      onTap: () {
                        // Navigator.push buat pindah ke halaman detail produk
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage(product: product)),
                        );
                      },
                      // Card buat kotak pembungkus produk ala butik
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AspectRatio 1.0 bikin gambar produk jadi kotak persegi (1:1) sempurna
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: const Color(0xFFFAFAFA),
                                    child: Image.asset(product.imagePath, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    // Container buat badge sisa stok
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Stok: ${product.stock}',
                                        style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded biar bagian teks dan tombol ngisi sisa ruang secara rapi dan rapat
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.category.toUpperCase(),
                                          style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1A1A1A)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp${product.price.toStringAsFixed(0)}',
                                          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w900, fontSize: 10.5),
                                        ),
                                      ],
                                    ),
                                    
                                    // SizedBox buat tombol beli cepat
                                    SizedBox(
                                      width: double.infinity,
                                      height: 26,
                                      // ElevatedButton buat tombol tambah ke keranjang
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: product.stock > 0 ? const Color(0xFF1A1A1A) : Colors.grey.shade300,
                                          foregroundColor: product.stock > 0 ? Colors.white : Colors.grey.shade600,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        ),
                                        onPressed: product.stock > 0
                                            ? () {
                                                context.read<CartProvider>().addToCart(product);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('${product.name} berhasil ditambahkan!'),
                                                    duration: const Duration(milliseconds: 600),
                                                    backgroundColor: const Color(0xFF1A1A1A),
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Text(product.stock > 0 ? 'Beli' : 'Habis', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman buat nampilin detail produk lengkap dalam bentuk kotak box elegan
class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Scaffold buat kerangka halaman detail
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar buat tombol kembali ke katalog
      appBar: AppBar(
        title: const Text('Detail Perhiasan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // SingleChildScrollView buat area teks panjang di detail
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        // Column buat nyusun info produk dari atas ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(product.imagePath, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 20),
            Text(product.category.toUpperCase(), style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 6),
            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 12),
            Text('Stok Tersedia: ${product.stock} pcs', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            const Text('Deskripsi Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            const Text(
              'Perhiasan mewah asli bersertifikat resmi dengan balutan emas pilihan dan tatahan batu mulia berkualitas tinggi. Dirancang khusus untuk memberikan kilau elegan di setiap momen spesial Anda.',
              style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman buat nampilin daftar belanjaan di keranjang
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold buat kerangka halaman keranjang
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar buat judul halaman keranjang
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // Consumer buat ngambil data item yang masuk keranjang dari provider
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final cartItems = cart.products.where((p) => (cart.cartQuantities[p.id] ?? 0) > 0).toList();

          // Stack buat numpuk list keranjang sama bar pembayaran melayang di bawah
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
                child: cartItems.isNotEmpty
                    // ListView.builder buat nampilin item yang dibeli
                    ? ListView.builder(
                        itemCount: cartItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          final qty = cart.cartQuantities[product.id] ?? 0;

                          // Card pembungkus item keranjang
                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            // Padding dalam item keranjang
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              // Row buat nyusun gambar, teks, sama input jumlah ke samping
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(product.imagePath, width: 60, height: 60, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    // Column buat nama produk dan harga
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        const SizedBox(height: 4),
                                        Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11.5, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  // SizedBox buat kotak input jumlah barang
                                  SizedBox(
                                    width: 45,
                                    height: 38,
                                    // TextField buat ngetik jumlah kuantitas produk secara reaktif
                                    child: TextField(
                                      controller: TextEditingController(text: '$qty')..selection = TextSelection.fromPosition(TextPosition(offset: '$qty'.length)),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                      onChanged: (value) {
                                        final parsed = int.tryParse(value);
                                        if (parsed != null && parsed >= 0) {
                                          cart.updateQuantity(product, parsed);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                        child: Padding(
                          padding: EdgeInsets.only(top: 120),
                          child: Text('Keranjang belanja Anda masih kosong.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                      ),
              ),
              
              // Positioned buat nempelin bar total harga dan tombol checkout di bawah layar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                // Container latar belakang bar pembayaran
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  // Row buat nyusun total harga dan tombol checkout
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Harga', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          // Text buat nampilin grand total reaktif dari provider
                          Text(
                            'Rp${cart.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
                          ),
                        ],
                      ),
                      
                      // ElevatedButton tombol buat proses checkout
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: cart.grandTotal > 0
                            ? () {
                                cart.checkout();
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
                              }
                            : null,
                        child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}