import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/user_model.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late double userPoints = 0;

  Future<void> topUpPoints(BuildContext context, double amount) async {
    final userRef = firestore.collection("mahasiswa").doc(widget.userId);

    try {
      final doc = await userRef.get();
      final data = doc.data() as Map<String, dynamic>?;

      final currentPoints = (data?['points'] ?? 0).toDouble();

      await userRef.update({"points": currentPoints + amount});

      setState(() {
        userPoints = currentPoints + amount;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Added $amount points!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add points")));
    }
  }

  void showTopUpDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Top Up Points"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter points"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  topUpPoints(context, amount);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection("mahasiswa").doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("User not found")));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final userPoints = (data['points'] ?? 0).toDouble();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text("Profile"),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: showTopUpDialog,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined),
                      const SizedBox(width: 4),
                      Text(userPoints.toStringAsFixed(0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UID: ${data['useruid']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Email: ${data['email']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Full Name: ${data['fullname'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 16),
                ),

                Text(
                  "NIM: ${data['usernim'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
