import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'topup_page.dart';
import 'TransactionHistory_Page.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
      ),

      body: ListView(
        children: [

          // ----------- NOTIFICATIONS -----------
        ListTile(
  leading: const Icon(Icons.history, color: Colors.blue),
  title: const Text(
    "Transaction History",
    style: TextStyle(fontSize: 16),
  ),
  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
  onTap: () {
    // Navigate to transaction history page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionHistoryPage()),
    );
  },
),

          // ----------- PRIVACY -----------
       // ----------- WALLET -----------
ListTile(
  leading: const Icon(
    Icons.account_balance_wallet,
    color: Colors.green,
  ),
  title: const Text("Wallet", style: TextStyle(fontSize: 16)),
  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TopUpPage()),
    );
  },
),


          const Divider(),

          // ----------- LOGOUT -----------
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
    );
  }
}
