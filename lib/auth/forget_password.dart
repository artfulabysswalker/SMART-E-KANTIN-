// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  // STEP 1: INPUT CONTROLLERS
  // Controller untuk input NIM saat verifikasi
  final _nimController = TextEditingController();
  // Controller untuk input email saat verifikasi
  final _emailController = TextEditingController();
  // Controller untuk input password baru
  final _newPasswordController = TextEditingController();
  // Controller untuk input konfirmasi password baru
  final _confirmPasswordController = TextEditingController();

  // STEP 2: FORM & STATE MANAGEMENT
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();
  // State untuk tracking apakah credentials sudah terverifikasi
  bool _credentialsVerified = false;
  // State untuk loading indicator
  bool _isLoading = false;
  // State untuk toggle password visibility
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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

  // Validasi Password Baru: tidak boleh kosong dan minimal 6 karakter
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Validasi Confirm Password: harus sama dengan password baru
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _newPasswordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  // STEP 4: FUNGSI VERIFIKASI CREDENTIALS (NIM + EMAIL)
  // Fungsi async untuk verifikasi NIM dan Email di database
  Future<void> _verifyCredentials() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading true
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi delay untuk proses verifikasi database (1 detik)
      await Future.delayed(const Duration(seconds: 1));

      // Sekarang set ke true, ubah ke false jika ingin test tidak ketemu
      bool credentialsValid = true;

      // Set loading false untuk mengakhiri proses loading
      setState(() {
        _isLoading = false;
      });

      // Jika NIM dan Email valid
      if (credentialsValid) {
        // Update state untuk menampilkan form reset password
        setState(() {
          _credentialsVerified = true;
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NIM dan Email terverifikasi! Silakan buat password baru'),
            backgroundColor: Colors.green,
          ),
        );
      }
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

  // STEP 5: FUNGSI RESET PASSWORD
  // Fungsi async untuk update password di database
  Future<void> _resetPassword() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading true
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi delay untuk proses update password (2 detik)
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Ganti simulasi ini dengan update Firestore sebenarnya
      // Contoh Firestore update password:
      // await FirebaseFirestore.instance
      //     .collection('mahasiswa')
      //     .doc(_nimController.text)
      //     .update({
      //   'password': _newPasswordController.text, // Sebaiknya encrypt password
      //   'updatedAt': FieldValue.serverTimestamp(),
      // });

      // Set loading false
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diubah! Silakan login dengan password baru'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate kembali ke login page
      Navigator.pop(context);
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
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Lupa Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header dengan background pattern
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A0A23),
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_pattern.png'),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Atur Ulang Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Masukkan data Anda untuk melanjutkan',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Card Form
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

              // JIKA BELUM VERIFIKASI: TAMPILKAN FORM VERIFIKASI NIM & EMAIL
              if (!_credentialsVerified) ...[
                // Teks keterangan
                const Text(
                  'Verifikasi Data Diri',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // STEP 7: UI - INPUT NIM (TAHAP VERIFIKASI)
                const Text(
                  'NIM',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan NIM Anda',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    validator: _validateNIM,
                  ),
                ),
                const SizedBox(height: 16),

                // STEP 8: UI - INPUT EMAIL (TAHAP VERIFIKASI)
                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan email Anda',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(height: 24),

                // STEP 9: UI - TOMBOL VERIFIKASI
                GestureDetector(
                  onTap: _isLoading ? null : _verifyCredentials,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Verifikasi',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ] else ...[
                // JIKA SUDAH VERIFIKASI: TAMPILKAN FORM RESET PASSWORD

                // Teks keterangan
                const Text(
                  'Buat Password Baru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // STEP 10: UI - INPUT PASSWORD BARU
                const Text(
                  'Password Baru',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: 'Minimal 6 karakter',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: _validateNewPassword,
                  ),
                ),
                const SizedBox(height: 16),

                // STEP 11: UI - INPUT CONFIRM PASSWORD BARU
                const Text(
                  'Konfirmasi Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan ulang password baru',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
                const SizedBox(height: 24),

                // STEP 12: UI - TOMBOL RESET PASSWORD
                GestureDetector(
                  onTap: _isLoading ? null : _resetPassword,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Atur Ulang Password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                // STEP 13: UI - TOMBOL KEMBALI KE VERIFIKASI
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _credentialsVerified = false;
                      _nimController.clear();
                      _emailController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Kembali ke Verifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
