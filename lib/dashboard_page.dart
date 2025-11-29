import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Database/product_model.dart';
import '../Database/user_model.dart';
import 'keranjang_dan_Diskon/cart.dart';
import 'keranjang_dan_Diskon/cart_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? firebaseUser;
  UserModel? currentUserModel;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection("mahasiswa")
          .doc(firebaseUser!.uid)
          .get();

      if (doc.exists) {
        currentUserModel = UserModel.fromJson(doc.data()!);
      } else {
        currentUserModel = UserModel(
          useruid: firebaseUser!.uid,
          usernim: "N/A",
          email: firebaseUser!.email ?? "",
          fullname: firebaseUser!.displayName ?? "Unknown",
          points: 0,
        );

        await FirebaseFirestore.instance
            .collection("mahasiswa")
            .doc(firebaseUser!.uid)
            .set(currentUserModel!.toJson());
      }
    }

    if (mounted) {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              if (currentUserModel != null) {
                profilepage(context, currentUserModel!);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentUserModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User not loaded yet")),
            );
          }
        },
        child: const Icon(Icons.shopping_cart),
      ),
      body: isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("items").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No items found"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final product = ProductModel.fromJson(doc.id, data);

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: product.productImageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: product.productImageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                              Icons.image_not_supported,
                                              size: 60),
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Price: \$${product.productPrice}\nStock: ${product.stock}\n${product.productDescription}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Cart.add(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${product.productName} added to cart"),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
    );
  }
}
