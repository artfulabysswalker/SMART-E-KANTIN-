import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dashboard_page.dart';
import 'auth_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // Still loading Firebase → show spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logged in → go to dashboard
        if (snapshot.hasData) {
          return const DashboardPage();
        }

        // User NOT logged in → go to login/register page
        return const AuthPage();
      },
    );
  }
}
