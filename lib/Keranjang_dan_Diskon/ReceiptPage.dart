import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> trxData;
  const ReceiptPage({super.key, required this.trxData});

  @override
  Widget build(BuildContext context) {
    final items = trxData["items"] as List;

    return Scaffold(
      appBar: AppBar(title: const Text("Receipt"), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Transaction ID: ${trxData['trx_id']}"),
            Text("Total: ${trxData['total']}"),
            Text("Status: ${trxData['status']}"),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("Qty: ${item['qty']}"),
                    trailing: Text("Price: ${item['price'] * item['qty']}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement print functionality here if needed
              },
              child: const Text("Print Receipt"),
            ),
          ],
        ),
      ),
    );
  }
}