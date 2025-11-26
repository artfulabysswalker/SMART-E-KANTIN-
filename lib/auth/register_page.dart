import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? showLoginPage;
  const RegisterPage({Key? key, this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nimController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  String? _validateNIM(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < 8) {
      return 'NIM minimal 8 karakter';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    if (value.trim().length < 2) {
      return 'Nama terlalu pendek';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  @override
  void dispose() {
    // Dispose semua controller (including name)
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Check if a mahasiswa document with the same NIM already exists.
  Future<bool> _nimExists(String nim) async {
    final q = await FirebaseFirestore.instance
        .collection('mahasiswa')
        .where('usernim', isEqualTo: nim)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  /// Create firebase auth account
  Future<UserCredential> _createFirebaseUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Add the user document to Firestore using a random generated doc id.
  /// We also store the auth uid inside the document (authUid) for possible future linking.
  Future<void> _addUserDetails({
    required String usernim,
    required String email,
    required String fullname,
    required String authUid,
  }) async {
    // generate random document id
    final useruid = FirebaseFirestore.instance.collection('mahasiswa').doc().id;

    final newuser = UserModel(
      useruid: useruid,
      usernim: usernim,
      email: email,
      fullname: fullname,
      // if your model supports more fields, you can pass authUid there; if not, we'll add via map
    );

    final userJson = newuser.toJson();

    // attach authUid in the saved document so it's possible to correlate later
    userJson['authUid'] = authUid;

    await FirebaseFirestore.instance
        .collection('mahasiswa')
        .doc(useruid)
        .set(userJson);
  }

  Future<void> _register() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nim = _nimController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      // 1) Check NIM uniqueness (since you wanted random Firestore ID, we enforce unique NIM if required)
      final exists = await _nimExists(nim);
      if (exists) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NIM sudah terdaftar. Gunakan NIM lain.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 2) Create Firebase Auth user
      UserCredential userCredential;
      try {
        userCredential = await _createFirebaseUser(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        // Specific FirebaseAuth error handling
        setState(() {
          _isLoading = false;
        });
        String message = 'Terjadi kesalahan pada pendaftaran.';
        if (e.code == 'email-already-in-use') {
          message = 'Email sudah digunakan.';
        } else if (e.code == 'weak-password') {
          message = 'Password terlalu lemah.';
        } else if (e.code == 'invalid-email') {
          message = 'Email tidak valid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        return;
      }

      final authUid = userCredential.user?.uid ?? '';

      // 3) Save to Firestore using random document id. If Firestore fails, remove the created auth user to avoid orphan account.
      try {
        await _addUserDetails(
          usernim: nim,
          email: email,
          fullname: name,
          authUid: authUid,
        );
      } catch (e) {
        // Firestore write failed: cleanup created auth user
        try {
          await userCredential.user?.delete();
        } catch (_) {
          // ignore deletion errors, but log if needed
        }

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data pengguna: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Success
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register berhasil! Silakan login'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // General fallback error
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // INPUT NIM
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

              // INPUT FULL NAME
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan nama lengkap',
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              // INPUT EMAIL
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan email (format: email@domain.com)',
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // INPUT PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan password (r)',
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

              // INPUT CONFIRM PASSWORD
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

              // BUTTON REGISTER
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Daftar'),
              ),
              const SizedBox(height: 12),

              // LINK TO LOGIN
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
