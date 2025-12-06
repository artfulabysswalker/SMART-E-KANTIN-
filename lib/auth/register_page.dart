// ===== IMPORT LIBRARIES =====
import 'package:ekantin/dashboard_page.dart'; // Untuk navigasi ke dashboard
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import '../Database/user_model.dart'; // Model data pengguna
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database

/// RegisterPage adalah halaman untuk pendaftaran akun pengguna baru
/// Memungkinkan user memasukkan NIM, nama, email, dan password
/// Creator: mathew, zenvero
class RegisterPage extends StatefulWidget {
  // Callback untuk menampilkan halaman login (opsional)
  final VoidCallback? showLoginPage;
  const RegisterPage({Key? key, this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// State class untuk RegisterPage
/// Menangani validasi form, Firebase auth, dan Firestore data storage
/// Creator: zenvero
class _RegisterPageState extends State<RegisterPage> {
  // ===== TEXT FIELD CONTROLLERS =====
  /// Controller untuk input NIM (Nomor Induk Mahasiswa)
  final _nimController = TextEditingController();
  /// Controller untuk input nama lengkap mahasiswa
  final _nameController = TextEditingController();
  /// Controller untuk input email
  final _emailController = TextEditingController();
  /// Controller untuk input password
  final _passwordController = TextEditingController();
  /// Controller untuk konfirmasi password
  final _confirmPasswordController = TextEditingController();

  // ===== FORM & STATE VARIABLES =====
  /// Global key untuk mengelola state form dan validasi
  final _formKey = GlobalKey<FormState>();
  /// Flag untuk toggle visibility password field
  bool _obscurePassword = true;
  /// Flag untuk toggle visibility confirm password field
  bool _obscureConfirmPassword = true;
  /// Flag untuk menampilkan loading indicator saat proses registrasi
  bool _isLoading = false;

  // ===== VALIDATION FUNCTIONS =====
  /// Validasi NIM: memastikan NIM tidak kosong dan minimal 8 karakter
  /// Creator: zenvero
  String? _validateNIM(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIM tidak boleh kosong';
    if (value.trim().length < 8) return 'NIM minimal 8 karakter';
    return null;
  }

  /// Validasi nama: memastikan nama tidak kosong dan minimal 2 karakter
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (value.trim().length < 2) return 'Nama terlalu pendek';
    return null;
  }

  /// Validasi email: menggunakan regex untuk format email yang valid
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Email tidak boleh kosong';
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value.trim()))
      return 'Email tidak valid';
    return null;
  }

  /// Validasi password: memastikan password tidak kosong dan minimal 6 karakter
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  /// Validasi konfirmasi password: memastikan cocok dengan password field
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Konfirmasi password kosong';
    if (value != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  /// Cleanup semua text controllers saat widget di-dispose
  /// Creator: zenvero
  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ===== FIREBASE FUNCTIONS =====

  /// Cek apakah NIM sudah terdaftar di Firestore
  /// Melakukan query ke collection 'mahasiswa' dengan field 'usernim'
  /// Creator: Mathew
  Future<bool> _nimExists(String nim) async {
    final q = await FirebaseFirestore.instance
        .collection('mahasiswa')
        .where('usernim', isEqualTo: nim)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  /// Buat user baru di Firebase Authentication
  /// Menggunakan email dan password untuk sign up
  Future<UserCredential> _createFirebaseUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Simpan data user detail ke Firestore collection 'mahasiswa'
  /// Menyimpan: uid, nim, email, nama lengkap, dan points
  Future<void> _addUserDetails({
  required String usernim,
  required String email,
  required String fullname,
  required String authUid,
}) async {
  // Buat object UserModel dengan data yang diberikan
  final newUser = UserModel(
    useruid: authUid, 
    usernim: usernim,
    email: email,
    fullname: fullname,
    points: 0.0,
  );

  // Konversi model ke JSON dan tambahkan authUid
  final userJson = newUser.toJson();
  userJson['authUid'] = authUid;
  
  // Simpan ke Firestore dengan document ID = authUid
  await FirebaseFirestore.instance
      .collection('mahasiswa')
      .doc(authUid) 
      .set(userJson);
}

  // ===== MAIN REGISTER FUNCTION =====
  /// Proses registrasi user baru dengan langkah-langkah berikut:
  /// 1. Validasi form input
  /// 2. Cek NIM tidak sudah terdaftar
  /// 3. Buat user di Firebase Auth
  /// 4. Simpan detail user ke Firestore
  /// Creator: zenvero
  Future<void> _register() async {
    // Validasi semua input field terlebih dahulu
    if (!_formKey.currentState!.validate()) return;

    // Ambil dan trim semua input
    final nim = _nimController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Tampilkan loading indicator
    setState(() => _isLoading = true);

    try {
      // STEP 1: Cek apakah NIM sudah terdaftar
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

      // STEP 2: Buat user di Firebase Authentication
      UserCredential cred;
      try {
        cred = await _createFirebaseUser(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);

        // Tampilkan error message yang sesuai dengan error code Firebase
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

      // Ambil UID dari user yang baru dibuat
      final uid = cred.user?.uid ?? '';

      // STEP 3: Simpan detail user ke Firestore
      try {
        await _addUserDetails(
          usernim: nim,
          email: email,
          fullname: name,
          authUid: uid,
        );
      } catch (e) {
        // Jika gagal simpan ke Firestore, hapus user dari Firebase Auth
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

      // Registrasi sukses
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register berhasil! Silakarn login.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi ke dashboard
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

  // ====================== UI BUILD FUNCTION ======================
  /// Builder untuk membuat UI register page dengan tema dark
  /// Creator: Baruna
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background warna gelap untuk dark theme
      backgroundColor: const Color(0xFF1E1E1E),
      
      // App bar dengan warna orange dan teks putih
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      // Body dengan SingleChildScrollView agar responsif
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======= TOP HEADER SECTION ========
            /// Header dengan background pattern dan welcome text
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

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= NIM INPUT FIELD ==================
                      /// Label untuk field NIM
                      const Text(
                        "NIM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      /// Input field untuk NIM dengan custom styling
                      _inputField(
                        controller: _nimController,
                        validator: _validateNIM,
                        hint: "Masukkan NIM",
                      ),

                      const SizedBox(height: 15),

                      // ================= FULL NAME INPUT FIELD ==================
                      /// Label untuk field nama lengkap
                      const Text(
                        "Nama Lengkap",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      /// Input field untuk nama dengan custom styling
                      _inputField(
                        controller: _nameController,
                        validator: _validateName,
                        hint: "Masukkan nama lengkap",
                      ),

                      const SizedBox(height: 15),

                      // ================= EMAIL INPUT FIELD ==================
                      /// Label untuk field email
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      /// Input field untuk email dengan custom styling
                      _inputField(
                        controller: _emailController,
                        validator: _validateEmail,
                        hint: "example@gmail.com",
                      ),

                      const SizedBox(height: 15),

                      // ================= PASSWORD INPUT FIELD ==================
                      /// Label untuk field password
                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      /// Password field dengan toggle visibility icon
                      _passwordField(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggle: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 15),

                      // ================= CONFIRM PASSWORD INPUT FIELD ==================
                      /// Label untuk field konfirmasi password
                      const Text(
                        "Konfirmasi Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      /// Confirm password field dengan toggle visibility icon
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
                      /// Tombol register dengan loading indicator
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
                      /// Link untuk masuk ke halaman login jika sudah punya akun
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

  // ======== HELPER WIDGET FUNCTIONS ========

  /// Widget untuk input field biasa (NIM, Nama, Email)
  /// Menampilkan container dengan background abu-abu dan border radius
  /// Creator: zenvero, Baruna
  Widget _inputField({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required String hint,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4), // Background abu-abu
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

  /// Widget untuk password field dengan toggle visibility
  /// Menampilkan password/dots dan icon untuk show/hide
  /// Creator: zenvero, Baruna
  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4), // Background abu-abu
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure, // Toggle untuk show/hide password
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "***********",
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          // Icon untuk toggle visibility
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
