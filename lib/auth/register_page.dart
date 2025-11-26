import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // STEP 1: CONTROLLERS UNTUK MENGINPUT DATA
  // Controller untuk input NIM (8+ karakter)
  final _nimController = TextEditingController();
  // Controller untuk input email (format email yang valid)
  final _emailController = TextEditingController();
  // Controller untuk input password (minimal 6 karakter)
  final _passwordController = TextEditingController();
  // Controller untuk input konfirmasi password
  final _confirmPasswordController = TextEditingController();

  // STEP 2: FORM KEY UNTUK VALIDASI FORM
  // Key ini digunakan untuk memvalidasi form sebelum submit
  final _formKey = GlobalKey<FormState>();

  // STEP 3: STATE VARIABLES UNTUK MANAGE STATE
  // Untuk menyembunyikan/menampilkan password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  // Untuk loading state saat proses register
  bool _isLoading = false;

  // STEP 4: FUNGSI-FUNGSI VALIDASI
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

  // Validasi Confirm Password: harus sama dengan password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  // STEP 5: FUNGSI REGISTER
  // Fungsi async untuk proses register ke database
  Future<void> _register() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading true
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi delay untuk proses register (2 detik)
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Ganti dengan query Firestore sebenarnya
      // Contoh Firestore query:
      // await FirebaseFirestore.instance.collection('mahasiswa').doc(nimController.text).set({
      //   'nim': _nimController.text,
      //   'email': _emailController.text,
      //   'password': _passwordController.text, // Sebaiknya encrypt password
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      // Set loading false
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register berhasil! Silakan login'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate ke login page
      Navigator.pushReplacementNamed(context, '/login');
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // STEP 6: UI - INPUT NIM
              // Field input untuk NIM
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan NIM (minimal 8 karakter)',
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
                  hintText: 'Masukkan email (format: email@domain.com)',
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
                  hintText: 'Masukkan password (minimal 6 karakter)',
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
              const SizedBox(height: 16),

              // STEP 9: UI - INPUT CONFIRM PASSWORD
              // Field input untuk konfirmasi password dengan toggle show/hide
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan ulang password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 24),

              // STEP 10: UI - TOMBOL REGISTER
              // Tombol untuk submit form register
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
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
                    : const Text('Daftar'),
              ),
              const SizedBox(height: 12),

              // STEP 11: UI - LINK UNTUK LOGIN
              // Link untuk ke halaman login jika sudah punya akun
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
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
    );
  }
}
