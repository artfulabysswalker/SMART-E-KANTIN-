import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Database/product_model.dart';
import '../auth/main_page.dart'; // Make sure this is correct

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------- AppBar ----------------
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // Logout button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out user
              await FirebaseAuth.instance.signOut();

              // Reset navigation stack to MainPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false,
              );
            },
          ),
        ],
        // User info below the title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Logged in as: ${currentUser?.email ?? 'Unknown User'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),

      // ---------------- Body ----------------
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // No data
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
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: product.productImageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.productImageUrl,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image_not_supported, size: 40),
                  title: Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Price: ${product.productPrice}\nStock: ${product.stock}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
