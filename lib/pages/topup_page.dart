import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key? key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _topUpPoints() async {
    if (_amountController.text.isEmpty) return;

    double pointsToAdd = double.tryParse(_amountController.text) ?? 0;
    if (pointsToAdd <= 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw 'No user logged in';

      final userDoc = FirebaseFirestore.instance
          .collection('mahasiswa')
          .doc(currentUser.uid);

      // Get current points
      final snapshot = await userDoc.get();
      double currentPoints = (snapshot.data()?['points'] ?? 0).toDouble();

      // Update points
      await userDoc.update({'points': currentPoints + pointsToAdd});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top-up successful!')),
      );

      _amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Up Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _topUpPoints,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Top Up'),
            ),
          ],
        ),
      ),
    );
  }
}
