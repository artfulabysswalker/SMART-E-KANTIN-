// ignore_for_file: use_build_context_synchronously
/// Ignore warning untuk penggunaan context di async functions

// ===== IMPORT LIBRARIES =====
/// Material Design Flutter untuk UI components
import 'package:flutter/material.dart';

/// ForgetPasswordPage adalah halaman untuk reset password pengguna
/// Menggunakan 2-stage verification: NIM+Email verification → Password reset
/// Creator: Development Team
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

/// State class untuk ForgetPasswordPage
/// Menangani validasi form, verifikasi credentials, dan password reset
class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  // ===== TEXT FIELD CONTROLLERS =====
  /// Controller untuk input NIM saat verifikasi credentials
  final _nimController = TextEditingController();
  /// Controller untuk input email saat verifikasi credentials
  final _emailController = TextEditingController();
  /// Controller untuk input password baru
  final _newPasswordController = TextEditingController();
  /// Controller untuk input konfirmasi password baru
  final _confirmPasswordController = TextEditingController();

  // ===== FORM & STATE VARIABLES =====
  /// Global key untuk form validation
  final _formKey = GlobalKey<FormState>();
  /// Flag untuk tracking apakah NI
  /// M + Email sudah terverifikasi
  bool _credentialsVerified = false;
  /// Flag untuk menampilkan loading indicator saat proses
  bool _isLoading = false;
  /// Flag untuk toggle visibility password baru
  bool _obscureNewPassword = true;
  /// Flag untuk toggle visibility konfirmasi password
  bool _obscureConfirmPassword = true;

  // ===== VALIDATION FUNCTIONS =====
  
  /// Validasi NIM: memastikan tidak kosong dan minimal 8 karakter
  String? _validateNIM(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'NIM minimal 8 karakter';
    }
    return null;
  }

  /// Validasi Email: menggunakan regex untuk format yang valid
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Regex pattern untuk validasi format email
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi Password Baru: tidak boleh kosong dan minimal 6 karakter
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Validasi Konfirmasi Password: harus sama dengan password baru
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _newPasswordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  // ===== VERIFICATION & RESET FUNCTIONS =====
  
  /// Verifikasi NIM dan Email user
  /// STEP 1: Validasi form
  /// STEP 2: Query ke database untuk cek NIM + Email match
  /// STEP 3: Set credentialsVerified = true jika valid
  Future<void> _verifyCredentials() async {
    // Validasi form input terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Tampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // STEP 1: Simulasi delay untuk proses verifikasi database (1 detik)
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Ganti dengan actual Firestore query untuk verifikasi NIM + Email
      // Contoh query:
      // QuerySnapshot result = await FirebaseFirestore.instance
      //     .collection('mahasiswa')
      //     .where('usernim', isEqualTo: _nimController.text)
      //     .where('email', isEqualTo: _emailController.text)
      //     .limit(1)
      //     .get();
      // bool credentialsValid = result.docs.isNotEmpty;
      
      // Untuk testing: set ke true, ubah ke false jika ingin test error case
      bool credentialsValid = true;

      // Set loading false untuk mengakhiri proses loading
      setState(() {
        _isLoading = false;
      });

      // STEP 2: Cek apakah NIM dan Email valid
      if (credentialsValid) {
        // Update state untuk menampilkan form reset password (2nd stage)
        setState(() {
          _credentialsVerified = true;
        });

        // Tampilkan pesan sukses
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('NIM dan Email terverifikasi! Silakan buat password baru'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Set loading false jika terjadi error
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Reset password user dengan password baru
  /// STEP 1: Validasi form input (password requirements)
  /// STEP 2: Update password di database
  /// STEP 3: Kembali ke login page
  Future<void> _resetPassword() async {
    // Validasi form input terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Tampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // STEP 1: Simulasi delay untuk proses update password (2 detik)
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Ganti simulasi ini dengan update Firebase Auth sebenarnya
      // Contoh menggunakan Firebase Password Reset:
      // 1. Get current user dari Firebase Auth
      // 2. Update password menggunakan updatePassword()
      // 3. Update data di Firestore jika diperlukan
      // Contoh code:
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user != null) {
      //   await user.updatePassword(_newPasswordController.text);
      //   await FirebaseFirestore.instance
      //       .collection('mahasiswa')
      //       .doc(user.uid)
      //       .update({
      //     'passwordChangedAt': FieldValue.serverTimestamp(),
      //   });
      // }

      // Set loading false setelah selesai
      setState(() {
        _isLoading = false;
      });

      // STEP 2: Tampilkan pesan sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah! Silakan login dengan password baru'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // STEP 3: Kembali ke halaman login
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Set loading false jika terjadi error
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Cleanup semua text controllers saat widget di-destroy
  @override
  void dispose() {
    // Dispose semua text field controllers
    _nimController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ====================== UI BUILD FUNCTION ======================
  
  /// Build method untuk membuat UI forget password page
  /// Menampilkan 2-stage UI berdasarkan credentialsVerified state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar dengan judul
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      // Body dengan scrollable area dan form
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ======= PAGE TITLE ========
              /// Judul halaman reset password
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

                // ======= EMAIL INPUT (VERIFICATION STAGE) ========
                /// Input field untuk email saat tahap verifikasi
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

                // ======= VERIFY BUTTON ========
                /// Tombol untuk verifikasi NIM + Email
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
                // ======= PASSWORD RESET STAGE (AFTER VERIFICATION) ========
                /// Tampilkan form reset password setelah verifikasi berhasil

                // Teks keterangan
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Silakan buat password baru Anda',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // ======= NEW PASSWORD INPUT ========
                /// Input field untuk password baru
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan password baru (minimal 6 karakter)',
                    // Icon untuk toggle show/hide password
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

                // ======= CONFIRM PASSWORD INPUT ========
                /// Input field untuk konfirmasi password baru
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan ulang password baru',
                    // Icon untuk toggle show/hide password
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

                // ======= RESET PASSWORD BUTTON ========
                /// Tombol untuk submit password baru
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

                // ======= BACK TO VERIFICATION BUTTON ========
                /// Tombol untuk kembali ke tahap verifikasi
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      // Reset state ke verification stage
                      _credentialsVerified = false;
                      // Clear semua input fields
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
