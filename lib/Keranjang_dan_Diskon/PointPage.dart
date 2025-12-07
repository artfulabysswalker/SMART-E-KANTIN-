import 'package:ekantin/models/user_model_A1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'receiptpage.dart';
import 'cart.dart';


class PointsPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;
  final UserModel_A1 user;
  final NumberFormat rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  const PointsPage({
    super.key,
    required this.cartItems,
    required this.total,
    required this.user,
  });

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  bool _isLoading = false;

  Future<void> confirmTransaction(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final firestore = FirebaseFirestore.instance;

    // 1️⃣ Ensure user has enough points
    if (widget.user.points < widget.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Insufficient points!")),
      );
      setState(() => _isLoading = false);
      return;
    }

    // 2️⃣ Check stock for each item
    for (var item in widget.cartItems) {
      final doc =
          await firestore.collection('items').doc(item.product.productId_A1).get();
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
        setState(() => _isLoading = false);
        return;
      }
    }

    // 3️⃣ Batch write transaction
    final batch = firestore.batch();
    final trxRef = firestore.collection("Transactions").doc();
    final trxId = trxRef.id;

    final trxData = {
      "trx_id": trxId,
      "total": widget.total,
      "status": "Success",
      "items": widget.cartItems
          .map((e) => {
                "productId": e.product.productId_A1,
                "name": e.product.productName,
                "price": e.product.productPrice,
                "qty": e.quantity,
              })
          .toList(),
      "userId": widget.user.userId_A1,
      "created_at": FieldValue.serverTimestamp(),
    };
    batch.set(trxRef, trxData);

    // Deduct points
    final userRef = firestore.collection("mahasiswa").doc(widget.user.useruid_A1);
    final remainingPoints = (widget.user.points - widget.total).clamp(0, double.infinity);
    batch.update(userRef, {"points": remainingPoints});

    // Reduce stock
    for (var item in widget.cartItems) {
      final productRef = firestore.collection("items").doc(item.product.productId_A1);
      batch.update(productRef, {"stock": FieldValue.increment(-item.quantity)});
    }

    try {
      await batch.commit();

      Cart.clear();

      // Navigate to receipt page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute( // Removed const
          builder: (_) => ReceiptPage(trxData: trxData as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction failed!")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            child: Align(
              child: Text(
                "Points: ${widget.user.points.toStringAsFixed(2)}",
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
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          final subtotal = item.product.productPrice * item.quantity;

          return ListTile(
            title: Text(item.product.productName),
            subtitle: Text("Qty: ${item.quantity}"),
            trailing: Text(widget.rupiah.format(subtotal)),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: _isLoading ? null : () => confirmTransaction(context),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Pay with Points (${widget.total.toStringAsFixed(2)} pts)",
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }
}