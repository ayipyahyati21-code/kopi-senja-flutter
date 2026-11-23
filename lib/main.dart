
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const KopiSenjaApp());
}

class KopiSenjaApp extends StatelessWidget {
  const KopiSenjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kopi Senja',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F0E8),
      ),
      home: const KatalogPage(),
    );
  }
}

class Menu {
  final String nama;
  final int harga;
  bool tersedia;

  Menu(this.nama, this.harga, {this.tersedia = true});
}

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  final List<Menu> menus = [
    Menu('Espresso', 18000),
    Menu('Americano', 22000),
    Menu('Cafe Latte', 28000),
    Menu('Cappuccino', 28000),
    Menu('Caramel Macchiato', 32000),
    Menu('Mocha', 30000),
    Menu('Matcha Latte', 29000),
    Menu('Chocolate', 27000),
    Menu('Croissant', 20000),
    Menu('Cinnamon Roll', 24000),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String formatHarga(int harga) {
    return 'Rp${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4E342E),
        foregroundColor: Colors.white,
        title: const Text(
          'Kopi Senja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4E342E), Color(0xFF8D6E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _rotationController,
                    child: const Icon(
                      Icons.coffee_rounded,
                      color: Colors.white,
                      size: 58,
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Temukan Kopi Favoritmu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Nikmati rasa dan aroma terbaik setiap hari',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu Kami',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];

                return MenuCard(
                  key: ValueKey(menu.nama),
                  nama: menu.nama,
                  harga: formatHarga(menu.harga),
                  tersedia: menu.tersedia,
                  onLongPress: () {
                    setState(() {
                      menu.tersedia = !menu.tersedia;
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          nama: menu.nama,
                          harga: formatHarga(menu.harga),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String nama;
  final String harga;
  final bool tersedia;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.nama,
    required this.harga,
    required this.tersedia,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: tersedia ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF795548), Color(0xFF4E342E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD7B899)),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'menu_$nama',
                createRectTween: (begin, end) =>
                    MenuRectTween(begin: begin, end: end),
                child: Material(
                  color: const Color(0xFFE8D5C4),
                  shape: const CircleBorder(),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.coffee_rounded,
                        color: Color(0xFF4E342E),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      harga,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFD7A8),
                      ),
                    ),
                    if (!tersedia)
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Habis',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                tersedia ? Icons.arrow_forward_ios : Icons.block,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuRectTween extends RectTween {
  MenuRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    final curvedT = Curves.easeInOutCubic.transform(t);
    return Rect.lerp(begin, end, curvedT)!;
  }
}

class DetailPage extends StatelessWidget {
  final String nama;
  final String harga;

  const DetailPage({
    super.key,
    required this.nama,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4E342E),
        foregroundColor: Colors.white,
        title: const Text('Detail Menu'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'menu_$nama',
                createRectTween: (begin, end) =>
                    MenuRectTween(begin: begin, end: end),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF795548), Color(0xFF4E342E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.coffee_rounded,
                        size: 100,
                        color: Color(0xFFE8D5C4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                harga,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF8D6E63),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dibuat dengan bahan pilihan untuk '
                'menghadirkan cita rasa kopi terbaik.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.brown),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Katalog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E342E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
