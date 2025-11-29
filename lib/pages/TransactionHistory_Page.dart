import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: currentUser == null
          ? const Center(child: Text("No user logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('mahasiswa')
                  .doc(currentUser.uid)
                  .collection('transactions') // your subcollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No transactions yet"));
                }

                final transactions = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      leading: const Icon(Icons.monetization_on, color: Colors.green),
                      title: Text(tx['type'] ?? 'Unknown'),
                      subtitle: Text(
                          "Amount: ${tx['amount'] ?? 0} - ${tx['timestamp']?.toDate() ?? ''}"),
                    );
                  },
                );
              },
            ),
    );
  }
}
