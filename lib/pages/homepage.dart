import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import 'cart_page.dart';
import 'profile_page.dart';


class MenuItem {
  final String imagePath;
  final String title;
  final String description;
  final String price;
  final String category;

  const MenuItem({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;

  final List<String> categories = [
    "All Items",
    "Main Dishes",
    "Drinks",
    "Snacks",
  ];

  // List of menu items. You can add more items here.
  // NOTE: Make sure to add the corresponding images to your 'assets/images/' folder.
  final List<MenuItem> menuItems = [
    const MenuItem(
      imagePath: "assets/images/nasigoreng.jpg",
      title: "Nasi Goreng Spesial",
      description: "Nasi goreng spesial dengan telur, ayam, dan sayuran.",
      price: "Rp 25.000",
      category: "Main Dishes",
    ),
    const MenuItem(
      imagePath:
          "assets/images/churos.jpg", // TODO: Change to a different image
      title: "churos Coklat",
      description: "manis gurih bisa dicocol.",
      price: "Rp 10.000",
      category: "Snacks",
    ),
    const MenuItem(
      imagePath:
          "assets/images/lumpia.jpg", // TODO: Change to a different image
      title: "lumpia",
      description: "isi bihun.",
      price: "Rp 3.000",
      category: "Snacks",
    ),
    const MenuItem(
      imagePath:
          "assets/images/piscok.jpg", // TODO: Change to a different image
      title: "pisang lumer coklat",
      description: "piscok cocok buat ngemil.",
      price: "Rp 3.000",
      category: "Snacks",
    ),
    const MenuItem(
      imagePath: "assets/images/onde.jpg", // TODO: Change to a different image
      title: "onde  klat",
      description: "onde onde isi coklat.",
      price: "Rp 4.000",
      category: "Snacks",
    ),
    // === MINUMAN  ===
    const MenuItem(
      imagePath: "assets/images/badboy.jpg", // TODO: Ganti dengan gambar es teh
      title: "Es badboy",
      description: "cocok untuk buat orang ganti ganti pasangan.",
      price: "Rp 20.000",
      category: "Drinks",
    ),
    const MenuItem(
      imagePath: "assets/images/kuwut.jpg",
      title: "es Kuwut",
      description: "nyegerno pikiran bar ujian.",
      price: "Rp 7.000",
      category: "Drinks",
    ),
    const MenuItem(
      imagePath: "assets/images/dawet.jpg",
      title: "es dawet",
      description: "cocok nggo seng pengen ngerasakno vibe sawah.",
      price: "Rp 12.000",
      category: "Drinks",
    ),
    const MenuItem(
      imagePath: "assets/images/kopi.jpg",
      title: "es kopi",
      description: "cocok gae wong sg seneng game karo asap-asap.",
      price: "Rp 8.000",
      category: "Drinks",
    ),
    const MenuItem(
      imagePath: "assets/images/martebe.jpg",
      title: "es martebe",
      description: "es e wong londo.",
      price: "Rp 22.000",
      category: "Drinks",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter menu items based on the selected category
    final filteredMenuItems = menuItems.where((item) {
      final selectedCategoryName = categories[selectedCategory];
      if (selectedCategoryName == "All Items") {
        return true; // Show all items
      }
      return item.category == selectedCategoryName;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1E1E1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ==== HEADER ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EKantin",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Order your favorite food",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Gunakan Consumer untuk hanya me-rebuild badge keranjang
                        Consumer<CartService>(
                          builder: (context, cart, child) {
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CartPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (cart.itemCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        cart.itemCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        // Tombol untuk navigasi ke ProfilePage
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==== SEARCH BAR ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search menu...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==== CATEGORY TABS ====
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    bool active = index == selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: active ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ==== MENU ITEMS LIST ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(filteredMenuItems.length, (index) {
                    final menuItem = filteredMenuItems[index];
                    // Berikan menuItem ke MenuItemCard
                    return MenuItemCard(
                      imagePath: menuItem.imagePath,
                      title: menuItem.title,
                      description: menuItem.description,
                      price: menuItem.price,
                      menuItem: menuItem, // Perbaikan: Kirim objek menuItem
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable widget to display a single menu item card.
class MenuItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String price;
  final MenuItem menuItem; // Tambahkan ini

  const MenuItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.menuItem, // Tambahkan ini
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Panggil CartService untuk menambahkan item
                        Provider.of<CartService>(
                          context,
                          listen: false,
                        ).addItem(menuItem);

                        // Tampilkan notifikasi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${menuItem.title} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "+ Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
