import 'package:ekantin/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage_baruna extends StatefulWidget {
  //pembuat mathew 
  // callback to show login page
  final VoidCallback? showLoginPage;
  const RegisterPage_baruna({Key? key, this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage_baruna> createState() => _RegisterPageState();
}
// pembuat zenvero
class _RegisterPageState extends State<RegisterPage_baruna> {
  final _nimController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
//pembuat zenvero
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // --- VALIDATIONS ---
  // pembuat zenvero
  String? _validateNIM(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIM tidak boleh kosong';
    if (value.trim().length < 8) return 'NIM minimal 8 karakter';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (value.trim().length < 2) return 'Nama terlalu pendek';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email tidak boleh kosong';
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value.trim()))
      return 'Email tidak valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Konfirmasi password kosong';
    if (value != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  @override
  // pembuat zenvero
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ===== FIREBASE FUNCTIONS =====
  // pembuat Mathew
  Future<bool> _nimExists(String nim) async {
    final q = await FirebaseFirestore.instance
        .collection('mahasiswa')
        .where('usernim', isEqualTo: nim)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  Future<UserCredential> _createFirebaseUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> _addUserDetails({
  required String usernim,
  required String email,
  required String fullname,
  required String authUid,
}) async {
  
  final newUser = UserModel(
    useruid: authUid, 
    usernim: usernim,
    email: email,
    fullname: fullname,
    points: 0.0,
  );

  final userJson = newUser.toJson();
  userJson['authUid'] = authUid;
  await FirebaseFirestore.instance
      .collection('mahasiswa')
      .doc(authUid) 
      .set(userJson);
}

  // ===== REGISTER FUNCTION =====
  // pembuat zenvero
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final nim = _nimController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      if (await _nimExists(nim)) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NIM sudah terdaftar'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      UserCredential cred;
      try {
        cred = await _createFirebaseUser(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);

        String message = 'Terjadi kesalahan.';
        if (e.code == 'email-already-in-use')
          message = 'Email sudah digunakan.';
        if (e.code == 'weak-password') message = 'Password terlalu lemah.';
        if (e.code == 'invalid-email') message = 'Email tidak valid.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        return;
      }

      final uid = cred.user?.uid ?? '';

      try {
        await _addUserDetails(
          usernim: nim,
          email: email,
          fullname: name,
          authUid: uid,
        );
      } catch (e) {
        await cred.user?.delete();
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register berhasil! Silakarn login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ====================== UI START ======================
  //pembuat Baruna
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
//app bar
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======= TOP HEADER ========
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
                    "Create your new account",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // ======= WHITE CARD =======
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= NIM ==================
                      const Text(
                        "NIM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),

                      _inputField(
                        controller: _nimController,
                        validator: _validateNIM,
                        hint: "Masukkan NIM",
                      ),

                      const SizedBox(height: 15),

                      // ================= FULL NAME ==================
                      const Text(
                        "Nama Lengkap",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),

                      _inputField(
                        controller: _nameController,
                        validator: _validateName,
                        hint: "Masukkan nama lengkap",
                      ),

                      const SizedBox(height: 15),

                      // ================= EMAIL ==================
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),

                      _inputField(
                        controller: _emailController,
                        validator: _validateEmail,
                        hint: "example@gmail.com",
                      ),

                      const SizedBox(height: 15),

                      // ================= PASSWORD ==================
                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),

                      _passwordField(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggle: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 15),

                      // ================= CONFIRM PASSWORD ==================
                      const Text(
                        "Konfirmasi Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),

                      _passwordField(
                        controller: _confirmPasswordController,
                        obscure: _obscureConfirmPassword,
                        onToggle: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                        validator: _validateConfirmPassword,
                      ),

                      const SizedBox(height: 25),

                      // ================= REGISTER BUTTON ==================
                      GestureDetector(
                        onTap: _isLoading ? null : _register,
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
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    "REGISTER",
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

                      // ================= LOGIN LINK ==================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sudah punya akun? "),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, "/"),
                            child: const Text(
                              "LOGIN",
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
            ),
          ],
        ),
      ),
    );
  }

  // ======== INPUT FIELD ==========
  // pembuat zenvero dan Baruna
  Widget _inputField({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required String hint,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  // ======== PASSWORD FIELD ==========
   // pembuat zenvero dan Baruna
  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "***********",
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
