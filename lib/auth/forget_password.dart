// forget_password.dart
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  // ===== STEP 1: Input Controllers =====
  // Controller untuk mengelola input NIM dari user
  final _nimController = TextEditingController();
  // Controller untuk mengelola input email dari user
  final _emailController = TextEditingController();
  // Controller untuk mengelola input password baru dari user
  final _newPasswordController = TextEditingController();
  // Controller untuk mengelola input konfirmasi password baru dari user
  final _confirmPasswordController = TextEditingController();
  
  // ===== STEP 2: Form & State Management =====
  // Global key untuk mengakses dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();
  
  // Flag untuk menunjukkan status loading saat proses verifikasi/reset
  bool _isLoading = false;
  
  // Flag untuk menunjukkan apakah NIM dan Email sudah berhasil diverifikasi
  bool _credentialsVerified = false;
  
  // Flag untuk toggle visibility password baru
  bool _obscureNewPassword = true;
  // Flag untuk toggle visibility konfirmasi password baru
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Membebaskan resource dari semua controller untuk mencegah memory leak
    _nimController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ===== STEP 3: Validation Functions =====
  // Fungsi untuk memvalidasi input NIM
  // Mengembalikan pesan error jika validasi gagal, atau null jika valid
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
  // Memastikan format email valid
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Validasi format email menggunakan regex
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Fungsi untuk memvalidasi input password baru
  // Memastikan password tidak kosong dan minimal 6 karakter
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru tidak boleh kosong';
    }
    // Password harus minimal 6 karakter untuk keamanan
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Fungsi untuk memvalidasi konfirmasi password
  // Memastikan password dan konfirmasi password cocok
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    // Membandingkan dengan password baru yang sudah diinput
    if (value != _newPasswordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // ===== STEP 4: Verify Credentials Function =====
  // Fungsi untuk memverifikasi NIM dan Email di database
  // Jika kedua data ditemukan, tampilkan form reset password
  void _verifyCredentials() async {
    // Validasi input NIM dan Email terlebih dahulu
    if (_validateNIM(_nimController.text) == null &&
        _validateEmail(_emailController.text) == null) {
      // Set loading state saat proses verifikasi
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implementasi query ke database untuk verifikasi NIM dan Email
        // Contoh dengan Firestore:
        // final userSnap = await _firestore
        //     .collection('users')
        //     .where('nim', isEqualTo: _nimController.text)
        //     .where('email', isEqualTo: _emailController.text)
        //     .get();
        // bool credentialsValid = userSnap.docs.isNotEmpty;

        // Simulasi delay untuk proses verifikasi database (1 detik)
        await Future.delayed(const Duration(seconds: 1));

        // TODO: Ganti simulasi ini dengan hasil query sebenarnya
        // Ubah true ke false jika ingin test NIM & Email tidak ketemu
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
        // Handle error saat proses verifikasi
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ===== STEP 5: Reset Password Function =====
  // Fungsi untuk reset password setelah NIM dan Email terverifikasi
  // Update password di database berdasarkan NIM dan Email
  void _resetPassword() async {
    // Validasi semua field password (password baru dan konfirmasi)
    if (_formKey.currentState!.validate()) {
      // Set loading state saat proses reset
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implementasi update password di database
        // Contoh dengan Firestore:
        // await _firestore
        //     .collection('users')
        //     .where('nim', isEqualTo: _nimController.text)
        //     .where('email', isEqualTo: _emailController.text)
        //     .get()
        //     .then((querySnapshot) {
        //       for (var doc in querySnapshot.docs) {
        //         doc.reference.update({'password': _newPasswordController.text});
        //       }
        //     });

        // Simulasi delay untuk proses update password (2 detik)
        await Future.delayed(const Duration(seconds: 2));

        // Set loading false untuk mengakhiri proses loading
        setState(() {
          _isLoading = false;
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil direset!'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman login setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } catch (e) {
        // Handle error saat proses reset password
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
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
                const SizedBox(height: 40),
                // Judul halaman
                const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Deskripsi halaman
                const Text(
                  'Masukkan NIM dan Email Anda untuk mereset password',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // ===== STEP 1: Input NIM dan Email (Tahap Verifikasi) =====
                // Field Input NIM dengan validasi
                TextFormField(
                  controller: _nimController,
                  // Disable input setelah credentials terverifikasi
                  enabled: !_isLoading && !_credentialsVerified,
                  decoration: InputDecoration(
                    labelText: 'NIM (Nomor Identitas Mahasiswa)',
                    hintText: 'Masukkan NIM Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.badge),
                    // Tampilkan icon check jika credentials sudah verified
                    suffixIcon: _credentialsVerified
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  validator: _validateNIM,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Field Input Email dengan validasi
                TextFormField(
                  controller: _emailController,
                  // Disable input setelah credentials terverifikasi
                  enabled: !_isLoading && !_credentialsVerified,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                    // Tampilkan icon check jika credentials sudah verified
                    suffixIcon: _credentialsVerified
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                // Tombol Verifikasi NIM dan Email (hanya tampil jika belum verified)
                if (!_credentialsVerified)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCredentials,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            // Loading indicator berputar saat proses verifikasi
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Verifikasi NIM & Email',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),

                // ===== STEP 2: Input Password Baru (Tampil setelah credentials verified) =====
                // Bagian ini hanya tampil setelah NIM dan Email berhasil diverifikasi
                if (_credentialsVerified) ...[
                  const SizedBox(height: 30),
                  // Divider untuk pemisah antar section
                  const Divider(),
                  const SizedBox(height: 20),
                  // Judul section password baru
                  const Text(
                    'Buat Password Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Field input password baru dengan toggle show/hide
                  TextFormField(
                    controller: _newPasswordController,
                    // Disable saat loading
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      hintText: 'Minimal 6 karakter',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      // Tombol untuk toggle visibility password baru
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          // Toggle visibility password baru
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    // obscureText untuk menyembunyikan/menampilkan karakter
                    obscureText: _obscureNewPassword,
                    validator: _validateNewPassword,
                  ),
                  const SizedBox(height: 16),
                  
                  // Field input konfirmasi password dengan toggle show/hide
                  TextFormField(
                    controller: _confirmPasswordController,
                    // Disable saat loading
                    enabled: !_isLoading,
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
                          // Toggle visibility konfirmasi password
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
                  
                  // Tombol submit reset password
                  ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            // Loading indicator berputar saat proses reset
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
                
                const SizedBox(height: 16),
                // Link untuk kembali ke halaman login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ingat password Anda? '),
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
