import 'package:ekantin/models/user_model_A1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ReceiptPage.dart';

class DiscountPage extends StatefulWidget {
  final List cartItems;
  final double total;
  final UserModel_A1 user;

  const DiscountPage({
    super.key,
    required this.cartItems,
    required this.total,
    required this.user,
  });

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  late double discountPercent;
  late double discountAmount;
  late double shippingFee;
  late double finalTotal;

  final NumberFormat rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    discountPercent = _calculateDiscount(widget.user.usernim);

    const defaultShipping = 2000; // Rp2.000
    final isLastDigitEven = _isLastDigitEven(widget.user.usernim);

    shippingFee = isLastDigitEven ? 0.0 : defaultShipping.toDouble();
    discountAmount = widget.total * discountPercent;

// Total akhir setelah diskon dan ongkir
    finalTotal =
        (widget.total - discountAmount + shippingFee).clamp(0, double.infinity);
  }

// cek apakah digit terakhir NIM genap
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

// kalkuasi diskon berdasarkan digit terakhir NIM
  double _calculateDiscount(String nim) {
    for (int i = nim.length - 1; i >= 0; i--) {
      final ch = nim[i];
      if (RegExp(r"\d").hasMatch(ch)) {
        final digit = int.tryParse(ch) ?? 0;
        return digit % 2 == 1 ? 0.05 : 0.0;
      }
    }
    return 0.0;
  }

  Future<void> _confirmDiscountTransaction(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    for (var item in widget.cartItems) {
      final doc = await firestore
          .collection('items')
          .doc(item.product.productId_A1)
          .get();
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
                'productId': e.product.productId_A1,
                'name': e.product.productName,
                'price': e.product.productPrice,
                'qty': e.quantity,
              })
          .toList(),
      'userId': widget.user.useruid_A1,
      'payment_method': 'NIM Discount',
      'created_at': FieldValue.serverTimestamp(),
    };

    batch.set(trxRef, trxData);

// Pengurangan stok barang
    for (var item in widget.cartItems) {
      final productRef =
          firestore.collection('items').doc(item.product.productId_A1);
      batch.update(productRef, {'stock': FieldValue.increment(-item.quantity)});
    }

    try {
      await batch.commit();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute( // Removed const
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
      appBar: AppBar(
        title: const Text('NIM Discount'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${widget.user.fullName_A1} (${widget.user.usernim_A1})'),
            const SizedBox(height: 12),

            Text('Original Total: ${rupiahFormat.format(widget.total)}'),
            const SizedBox(height: 8),

            Text('Discount: ${(discountPercent * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 8),

            Text('Discount Amount: ${rupiahFormat.format(discountAmount)}'),
            const SizedBox(height: 8),

            Text('Shipping: ${rupiahFormat.format(shippingFee)}'),
            const SizedBox(height: 8),

            Text(
              'Final Total: ${rupiahFormat.format(finalTotal)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  final subtotal =
                      item.product.productPrice * item.quantity;

                  return ListTile(
                    title: Text(item.product.productName),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(
                      rupiahFormat.format(subtotal),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => _confirmDiscountTransaction(context),
                child: Text(
                  'Confirm Payment (${rupiahFormat.format(finalTotal)})',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}