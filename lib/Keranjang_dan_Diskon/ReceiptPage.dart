import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> trxData;
  const ReceiptPage({super.key, required this.trxData});

  @override
  Widget build(BuildContext context) {
    final items = trxData["items"] as List;

    final NumberFormat rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transaction ID: ${trxData['trx_id']}"),
            Text("Total: ${rupiahFormat.format(trxData['total'])}"),
            Text("Status: ${trxData['status']}"),
            const SizedBox(height: 16),
//
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final double price = (item['price'] ?? 0).toDouble();
                  final int qty = item['qty'] ?? 1;

                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("Qty: $qty"),
                    trailing: Text(
                      rupiahFormat.format(price * qty),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // TODO: Add print functionality
              },
              child: const Text("Print Receipt"),
            ),
          ],
        ),
      ),
    );
  }
}