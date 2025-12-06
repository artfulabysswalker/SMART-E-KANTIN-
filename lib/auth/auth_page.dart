// ===== IMPORT LIBRARIES =====
/// Material Design Flutter untuk UI components
import 'package:flutter/material.dart';
/// Import login page untuk authentication
import 'login_page.dart';
/// Import register page untuk user registration
import 'register_page.dart';

/// AuthPage adalah halaman router untuk navigasi antara login dan register
/// Menampilkan LoginPage atau RegisterPage berdasarkan showLoginPage state
/// Creator: Development Team
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

/// State class untuk AuthPage
/// Mengelola toggle antara halaman login dan register
class _AuthPageState extends State<AuthPage> {
  // ===== STATE VARIABLES =====
  /// Flag untuk menentukan halaman mana yang ditampilkan (login atau register)
  /// true = tampilkan LoginPage, false = tampilkan RegisterPage
  bool showLoginPage = true;

  // ===== TOGGLE FUNCTION =====
  
  /// Toggle halaman antara login dan register
  /// Dijalankan ketika user klik "LOGIN"/"SIGN UP" button di halaman lain
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  // ===== UI BUILD FUNCTION =====
  
  /// Build method untuk menampilkan LoginPage atau RegisterPage
  /// Berdasarkan nilai showLoginPage state
  @override
  Widget build(BuildContext context) {
    // Jika showLoginPage true, tampilkan LoginPage
    if (showLoginPage) {
      return LoginPage(showRegisterPage: togglePages);
    }
    // Jika false, tampilkan RegisterPage
    else {
      return RegisterPage(showLoginPage: togglePages);
    }
  }
}
