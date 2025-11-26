import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to the Dashboard!\nUser: ${currentUser?.email ?? "No user logged in"}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // ✔ Correct MaterialButton
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
