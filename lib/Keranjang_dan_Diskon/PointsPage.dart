import 'package:flutter/material.dart';
import '../Database/user_model.dart';
import 'receiptpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointsPage extends StatelessWidget {
  final List cartItems;
  final double total;
  final UserModel user;

  const PointsPage({
    super.key,
    required this.cartItems,
    required this.total,
    required this.user,
  });

  Future<void> confirmTransaction(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    // 1️⃣ Ensure user has enough points
    if (user.points < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Insufficient points!")),
      );
      return;
    }

    // 2️⃣ Check stock for each item
    for (var item in cartItems) {
      final doc =
          await firestore.collection('items').doc(item.product.productId).get();
      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.product.productName} not found!")),
        );
        return;
      }
      final stock = doc['stock'] ?? 0;
      if (item.quantity > stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Not enough stock for ${item.product.productName}")),
        );
        return;
      }
    }

    // 3️⃣ Batch write transaction
    final batch = firestore.batch();
    final trxRef = firestore.collection("Transactions").doc();
    final trxId = trxRef.id;

    final trxData = {
      "trx_id": trxId,
      "total": total,
      "status": "Success",
      "items": cartItems
          .map((e) => {
                "productId": e.product.productId,
                "name": e.product.productName,
                "price": e.product.productPrice,
                "qty": e.quantity,
              })
          .toList(),
      "userId": user.useruid,
      "created_at": FieldValue.serverTimestamp(),
    };
    batch.set(trxRef, trxData);

    // Deduct points
    final userRef = firestore.collection("mahasiswa").doc(user.useruid);
    final remainingPoints = (user.points - total).clamp(0, double.infinity);
    batch.update(userRef, {"points": remainingPoints});

    // Reduce stock
    for (var item in cartItems) {
      final productRef = firestore.collection("items").doc(item.product.productId);
      batch.update(productRef, {"stock": FieldValue.increment(-item.quantity)});
    }

    try {
      await batch.commit();
      // Optional: update local user points if you want instant feedback
      user.points = remainingPoints.toDouble();

      // Navigate to receipt page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptPage(trxData: trxData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction failed!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Transaction"),
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "Points: ${user.points.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final subtotal = item.product.productPrice * item.quantity;

          return ListTile(
            title: Text(item.product.productName),
            subtitle: Text("Qty: ${item.quantity}"),
            trailing: Text("\$${subtotal.toStringAsFixed(2)}"),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () => confirmTransaction(context),
          child: Text(
            "Pay with Points (${total.toStringAsFixed(2)} pts)",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
