import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/user_model.dart';
import 'ReceiptPage.dart';

class DiscountPage extends StatefulWidget {
  final List cartItems;
  final double total;
  final UserModel user;

  const DiscountPage({super.key, required this.cartItems, required this.total, required this.user});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  late double discountPercent;
  late double discountAmount;
  late double shippingFee;
  late double finalTotal;

  @override
  void initState() {
    super.initState();
    discountPercent = _calculateDiscount(widget.user.usernim);
    // Default shipping fee (flat). If user gets free shipping, we'll set to 0.
    const defaultShipping = 2.0;
    // If discountPercent == 0 and last digit is even, we want free shipping.
    // Determine shipping based on NIM parity.
    final isLastDigitEven = _isLastDigitEven(widget.user.usernim);
    shippingFee = isLastDigitEven ? 0.0 : defaultShipping;
    discountAmount = widget.total * discountPercent;
    finalTotal = (widget.total - discountAmount + shippingFee).clamp(0, double.infinity);
  }
  bool _isLastDigitEven(String nim) {
    for (int i = nim.length - 1; i >= 0; i--) {
      final ch = nim[i];
      if (RegExp(r"\d").hasMatch(ch)) {
        final digit = int.tryParse(ch) ?? 0;
        return digit % 2 == 0;
      }
    }
    return false;
  }

  double _calculateDiscount(String nim) {
    // New rule: if last digit odd -> 5% discount; if even -> free shipping (0% discount)
    for (int i = nim.length - 1; i >= 0; i--) {
      final ch = nim[i];
      if (RegExp(r"\d").hasMatch(ch)) {
        final digit = int.tryParse(ch) ?? 0;
        if (digit % 2 == 1) {
          return 0.05; // 5% for odd
        } else {
          return 0.0; // 0% for even (free shipping instead)
        }
      }
    }
    return 0.0; // default no discount if no digit found
  }

  Future<void> _confirmDiscountTransaction(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    // 1) Check stock for each item
    for (var item in widget.cartItems) {
      final doc = await firestore.collection('items').doc(item.product.productId).get();
      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.product.productName} not found!')),
        );
        return;
      }
      final stock = doc['stock'] ?? 0;
      if (item.quantity > stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not enough stock for ${item.product.productName}')),
        );
        return;
      }
    }

    // 2) Batch write transaction
    final batch = firestore.batch();
    final trxRef = firestore.collection('Transactions').doc();
    final trxId = trxRef.id;

    final trxData = {
      'trx_id': trxId,
      'total': finalTotal,
      'original_total': widget.total,
      'discount_percent': discountPercent,
      'discount_amount': discountAmount,
      'status': 'Success',
      'items': widget.cartItems
          .map((e) => {
                'productId': e.product.productId,
                'name': e.product.productName,
                'price': e.product.productPrice,
                'qty': e.quantity,
              })
          .toList(),
      'userId': widget.user.useruid,
      'payment_method': 'NIM Discount',
      'created_at': FieldValue.serverTimestamp(),
    };

    batch.set(trxRef, trxData);

    // 3) Reduce stock
    for (var item in widget.cartItems) {
      final productRef = firestore.collection('items').doc(item.product.productId);
      batch.update(productRef, {'stock': FieldValue.increment(-item.quantity)});
    }

    try {
      await batch.commit();

      // Navigate to receipt page
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptPage(trxData: trxData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NIM Discount'), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${widget.user.fullname} (${widget.user.usernim})'),
            const SizedBox(height: 12),
            Text('Original Total: \$${widget.total.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Discount: ${(discountPercent * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 8),
            Text('Discount Amount: \$${discountAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Shipping: \$${shippingFee.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Final Total: \$${finalTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  final subtotal = item.product.productPrice * item.quantity;
                  return ListTile(
                    title: Text(item.product.productName),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => _confirmDiscountTransaction(context),
                child: Text('Confirm Payment (\$${finalTotal.toStringAsFixed(2)})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
