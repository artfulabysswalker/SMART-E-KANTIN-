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
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // STEP 6: UI - JUDUL
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Atur Ulang Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // JIKA BELUM VERIFIKASI: TAMPILKAN FORM VERIFIKASI NIM & EMAIL
              if (!_credentialsVerified) ...[
                // Teks keterangan
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Masukkan NIM dan Email Anda untuk verifikasi',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // STEP 7: UI - INPUT NIM (TAHAP VERIFIKASI)
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

                // STEP 8: UI - INPUT EMAIL (TAHAP VERIFIKASI)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan email Anda',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 24),

                // STEP 9: UI - TOMBOL VERIFIKASI
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCredentials,
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
                      : const Text('Verifikasi'),
                ),
              ] else ...[
                // JIKA SUDAH VERIFIKASI: TAMPILKAN FORM RESET PASSWORD

                // Teks keterangan
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Silakan buat password baru Anda',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // STEP 10: UI - INPUT PASSWORD BARU
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan password baru (minimal 6 karakter)',
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
                const SizedBox(height: 16),

                // STEP 11: UI - INPUT CONFIRM PASSWORD BARU
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan ulang password baru',
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

                // STEP 12: UI - TOMBOL RESET PASSWORD
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
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
                      : const Text('Atur Ulang Password'),
                ),

                // STEP 13: UI - TOMBOL KEMBALI KE VERIFIKASI
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _credentialsVerified = false;
                      _nimController.clear();
                      _emailController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Kembali ke Verifikasi'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
