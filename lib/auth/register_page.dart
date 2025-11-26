// register_page.dart
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk mengelola input NIM dari user
  final _nimController = TextEditingController();
  // Controller untuk mengelola input email dari user
  final _emailController = TextEditingController();
  // Controller untuk mengelola input password
  final _passwordController = TextEditingController();
  // Controller untuk mengelola input konfirmasi password
  final _confirmPasswordController = TextEditingController();
  
  // Global key untuk mengakses dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();
  
  // Flag untuk toggle visibility password (true = tersembunyi, false = terlihat)
  bool _obscurePassword = true;
  // Flag untuk toggle visibility konfirmasi password
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Membebaskan resource dari controller untuk mencegah memory leak
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memvalidasi input NIM
  String? _validateNIM(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    // NIM harus minimal 8 karakter (standar NIM universitas)
    if (value.length < 8) {
      return 'NIM minimal 8 karakter';
    }
    return null;
  }

  // Fungsi untuk memvalidasi input email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Validasi format email
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Fungsi untuk memvalidasi input password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    // Password harus minimal 6 karakter (keamanan basic)
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Fungsi untuk memvalidasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    // Membandingkan dengan password yang sudah diinput sebelumnya
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Fungsi untuk memproses registrasi user
  void _register() {
    // Memvalidasi semua field form (NIM, Email, Password, Confirm Password)
    if (_formKey.currentState!.validate()) {
      // Proses registrasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      // TODO: Implementasi logika registrasi ke Firebase atau backend
      // Di sini Anda bisa menambahkan:
      // - Pengiriman data ke Firebase Authentication menggunakan NIM dan Email
      // - Penyimpanan data user ke Firestore dengan NIM sebagai unique identifier
      // - Loading indicator saat proses upload
      // - Error handling jika registrasi gagal
      // - Validasi NIM tidak duplikat
      // - Validasi Email tidak duplikat
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // SingleChildScrollView membuat tampilan bisa di-scroll jika melebihi ukuran layar
          child: Form(
            // Form widget untuk mengelola validasi input
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Field Input NIM dengan validasi
                TextFormField(
                  controller: _nimController,
                  decoration: InputDecoration(
                    labelText: 'NIM (Nomor Identitas Mahasiswa)',
                    hintText: 'Masukkan NIM Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  validator: _validateNIM,
                  // Keyboard type angka untuk memudahkan input NIM
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Field Input Email dengan validasi
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email (domain kampus)',
                    hintText: 'Masukkan email Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Field Input Password dengan toggle show/hide
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Minimal 6 karakter',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    // Tombol untuk toggle visibility password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  // obscureText untuk menyembunyikan/menampilkan karakter password
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                // Field Input Konfirmasi Password dengan toggle show/hide
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Ulangi password Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    // Tombol untuk toggle visibility konfirmasi password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  // obscureText untuk menyembunyikan/menampilkan karakter
                  obscureText: _obscureConfirmPassword,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 24),
                // Tombol untuk submit form registrasi
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Link untuk login jika sudah punya akun
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? '),
                    GestureDetector(
                      onTap: () {
                        // Kembali ke halaman login
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login di sini',
                        style: TextStyle(
                          color: Colors.blue,
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
      ),
    );
  }
}
