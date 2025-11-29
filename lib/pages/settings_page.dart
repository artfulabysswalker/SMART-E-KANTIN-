import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: ListView(
        children: [
          // ----------- ACCOUNT SETTINGS -----------
          ListTile(
            leading: const Icon(Icons.person, color: Colors.orange),
            title: const Text(
              "Account",
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),

          const Divider(),

          // ----------- NOTIFICATIONS -----------
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.orange),
            title: const Text(
              "Notifications",
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),

          const Divider(),

          // ----------- PRIVACY -----------
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: const Text(
              "Privacy",
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
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
