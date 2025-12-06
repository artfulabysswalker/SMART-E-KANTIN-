// ===== IMPORT LIBRARIES =====
/// Library Material Design Flutter untuk UI components
import 'package:flutter/material.dart';
/// Firebase Authentication untuk login dan sign up
import 'package:firebase_auth/firebase_auth.dart';
/// SharedPreferences untuk menyimpan data lokal (Remember Me feature)
import 'package:shared_preferences/shared_preferences.dart';
/// Import forget password page untuk navigation
import 'forget_password.dart';
/// Import register page untuk navigation
import 'register_page.dart';

/// LoginPage adalah halaman untuk user melakukan login ke aplikasi
/// Menggunakan Firebase Authentication untuk verifikasi email dan password
/// Memiliki fitur "Remember Me" untuk menyimpan credentials secara lokal
class LoginPage extends StatefulWidget {
  /// Callback opsional untuk menampilkan register page
  final VoidCallback? showRegisterPage;
  const LoginPage({Key? key, this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State class untuk LoginPage
/// Menangani validasi form, Firebase authentication, dan SharedPreferences
class _LoginPageState extends State<LoginPage> {
  // ===== TEXT FIELD CONTROLLERS =====
  /// Controller untuk input email
  final _emailController = TextEditingController();
  /// Controller untuk input password
  final _passwordController = TextEditingController();
  
  // ===== FORM & STATE VARIABLES =====
  /// Global key untuk form validation
  final _formKey = GlobalKey<FormState>();
  /// Flag untuk toggle password visibility (show/hide password)
  bool _obscurePassword = true;
  /// Flag untuk menampilkan loading indicator saat proses login
  bool _isLoading = false;
  /// Flag untuk Remember Me feature (auto-fill credentials)
  bool _rememberMe = false;

  // ===== VALIDATION FUNCTIONS =====
  
  /// Validasi email menggunakan regex pattern
  /// Memastikan format email valid (contoh: user@domain.com)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi password: memastikan tidak kosong
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    return null;
  }

  // ===== FIREBASE AUTHENTICATION =====
  
  /// Main login function yang menangani proses autentikasi
  /// Langkah-langkah:
  /// 1. Validasi form input
  /// 2. Tampilkan loading indicator
  /// 3. Sign in dengan Firebase Authentication
  /// 4. Simpan credentials ke SharedPreferences jika Remember Me aktif
  /// 5. Navigasi ke dashboard jika login berhasil
  Future<void> _login() async {
    // Validasi semua input terlebih dahulu
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan loading indicator
    setState(() => _isLoading = true);

    try {
      // STEP 1: Sign in dengan email dan password ke Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // STEP 2: Simpan credentials jika Remember Me diaktifkan
      if (_rememberMe) {
        // Simpan credentials ke local storage menggunakan SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', _emailController.text.trim());
        await prefs.setString('saved_password', _passwordController.text.trim());
        await prefs.setBool('remember_me', true);
      } else {
        // Hapus credentials jika Remember Me dinonaktifkan
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('saved_email');
        await prefs.remove('saved_password');
        await prefs.setBool('remember_me', false);
      }

      // Cek apakah widget masih mounted sebelum update state
      if (!mounted) return;
      setState(() => _isLoading = false);

      // STEP 3: Tampilkan success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      // STEP 4: Navigasi ke dashboard page
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      // Cek apakah widget masih mounted sebelum update state
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // Tampilkan error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Load saved credentials dari SharedPreferences jika Remember Me aktif
  /// Dijalankan saat initState untuk auto-fill email dan password
  Future<void> _loadSavedCredentials() async {
    // Ambil SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Cek apakah Remember Me pernah diaktifkan sebelumnya
    final rememberMe = prefs.getBool('remember_me') ?? false;
    // Ambil saved email dari local storage
    final savedEmail = prefs.getString('saved_email') ?? '';
    // Ambil saved password dari local storage
    final savedPassword = prefs.getString('saved_password') ?? '';

    // Update UI jika widget masih mounted dan Remember Me aktif
    if (mounted) {
      setState(() {
        _rememberMe = rememberMe;
        // Auto-fill email dan password jika Remember Me aktif
        if (rememberMe) {
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
        }
      });
    }
  }


  /// initState: dijalankan saat widget pertama kali dibuat
  /// Load saved credentials dari SharedPreferences
  @override
  void initState() {
    super.initState();
    // Load saved credentials untuk Remember Me feature
    _loadSavedCredentials();
  }

  /// dispose: cleanup resources saat widget di-destroy
  /// Dispose semua text field controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===== UI BUILD FUNCTION =====
  
  /// Build method untuk membuat UI login page dengan dark theme
  /// Layout: Header + White Card dengan form input
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background warna gelap untuk dark theme
      backgroundColor: const Color(0xFF1E1E1E),
      
      // App bar dengan warna orange
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      // Body dengan scrollable area
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ======= HEADER SECTION ========
              /// Container header dengan background pattern dan welcome text
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A0A23),
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_pattern.png"),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SMART E-KANTIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Please sign in to your existing account",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // ======= WHITE CARD FOR FORM ========
              /// Card putih dengan form input menggunakan Transform untuk overlap effect
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ======= EMAIL INPUT ========
                      /// Label untuk email field
                      const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),

                      /// Input field untuk email
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "example@gmail.com",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ======= PASSWORD INPUT ========
                      /// Label untuk password field
                      const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),

                      /// Input field untuk password dengan toggle visibility
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: _validatePassword,
                          decoration: InputDecoration(
                            hintText: "***********",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            // Icon untuk toggle show/hide password
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ======= REMEMBER ME & FORGOT PASSWORD ========
                      /// Row dengan Remember Me checkbox dan Lupa Password link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Remember Me checkbox untuk auto-fill credentials
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() => _rememberMe = value ?? false);
                                },
                                activeColor: Colors.orange,
                              ),
                              const Text(
                                'Ingat saya',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          /// Link ke forget password page
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ======= LOGIN BUTTON ========
                      /// Tombol login dengan loading indicator
                      GestureDetector(
                        onTap: _isLoading ? null : _login,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                : const Text(
                                    "LOG IN",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======= SIGN UP LINK ========
                      /// Link ke register page untuk user baru
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
