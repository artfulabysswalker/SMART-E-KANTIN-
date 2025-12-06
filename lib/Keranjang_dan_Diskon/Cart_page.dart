import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'cart.dart';
import 'TransactionPage.dart';
import '../Database/product_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final cart = Cart.cart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("items")
            .where('stock', isGreaterThan: 0)
            .snapshots(),
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

              final product = ProductModel(
                productId: doc.id,
                productName: data['productName'] ?? 'Unnamed',
                productPrice: (data['productPrice'] ?? 0).toDouble(),
                stock: data['stock'] ?? 0,
                productDescription: data['productDescription'] ?? '',
                productImageUrl: '', // No image
              );

              final quantity = Cart.getQuantity(product);

              if (quantity == 0) return const SizedBox.shrink();

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rupiah.format(product.productPrice),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                Cart.removeOne(product);
                              });
                            },
                          ),
                          Text(quantity.toString(),
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.green),
                            onPressed: () {
                              setState(() {
                                Cart.add(product);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionPage(
                        cartItems: Cart.cart,
                        total: Cart.totalPrice(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Proceed to Payment",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}