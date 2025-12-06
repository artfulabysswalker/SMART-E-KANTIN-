import 'package:flutter/material.dart';
import 'forget_password.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // STEP 1: CONTROLLERS UNTUK INPUT DATA LOGIN
  // Controller untuk input NIM
  final _nimController = TextEditingController();
  // Controller untuk input email
  final _emailController = TextEditingController();
  // Controller untuk input password
  final _passwordController = TextEditingController();

  // STEP 2: FORM KEY DAN STATE VARIABLES
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();
  // Untuk menyembunyikan/menampilkan password
  bool _obscurePassword = true;
  // Untuk loading state saat proses login
  bool _isLoading = false;

  // STEP 3: FUNGSI-FUNGSI VALIDASI
  // Validasi NIM: tidak boleh kosong dan minimal 8 karakter
  String? _validateNIM(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'NIM minimal 8 karakter';
    }
    return null;
  }

  // Validasi Email: menggunakan regex untuk format email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Regex pattern untuk validasi email
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi Password: tidak boleh kosong dan minimal 6 karakter
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // STEP 4: FUNGSI LOGIN
  // Fungsi async untuk proses login
  Future<void> _login() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading true
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi delay untuk proses login (1.5 detik)
      await Future.delayed(const Duration(milliseconds: 1500));

      // TODO: Ganti dengan query Firestore sebenarnya
      // Contoh Firestore query:
      // final result = await FirebaseFirestore.instance
      //     .collection('mahasiswa')
      //     .where('nim', isEqualTo: _nimController.text)
      //     .where('email', isEqualTo: _emailController.text)
      //     .get();
      //
      // if (result.docs.isNotEmpty) {
      //   // Validasi password dari Firestore
      //   // Sebaiknya gunakan Firebase Auth atau hash comparison
      //   final doc = result.docs.first;
      //   if (doc['password'] == _passwordController.text) {
      //     // Login berhasil
      //   }
      // }

      // Set loading false
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      // TODO: Navigate ke home page setelah login berhasil
      // Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Set loading false
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose semua controller
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // STEP 5: UI - JUDUL LOGIN
              // Judul aplikasi
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'SMART E-KANTIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // STEP 6: UI - INPUT NIM
              // Field input untuk NIM
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan NIM Anda',
                ),
                validator: _validateNIM,
              ),
              const SizedBox(height: 16),

              // STEP 7: UI - INPUT EMAIL
              // Field input untuk email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan email Anda',
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // STEP 8: UI - INPUT PASSWORD
              // Field input untuk password dengan toggle show/hide
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan password Anda',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 8),

              // STEP 9: UI - LINK LUPA PASSWORD
              // Link untuk navigate ke forget password page
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // STEP 10: UI - TOMBOL LOGIN
              // Tombol untuk submit form login
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 12),

              // STEP 11: UI - LINK UNTUK REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Daftar di sini',
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
    );
  }
}
