# SMART E-KANTIN 🍽️

Aplikasi mobile Flutter untuk sistem kantin cerdas dengan fitur authentication, order management, dan payment integration.

## 📋 Daftar Isi
- [Fitur](#fitur)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Konfigurasi Firebase](#konfigurasi-firebase)
- [Struktur Project](#struktur-project)
- [Authentication](#authentication)
- [Contributing](#contributing)

## ✨ Fitur

### Authentication System
- ✅ **Registrasi Akun** - Pendaftaran dengan NIM, Email, dan Password
- ✅ **Login** - Autentikasi dual-field (NIM + Email)
- ✅ **Lupa Password** - 2-tahap verifikasi untuk reset password
- ✅ **Firebase Integration** - Secure authentication dengan Firebase Auth
- ✅ **Firestore Database** - Penyimpanan data mahasiswa terenkripsi

### Fitur Kantin
- 🛒 **Menu Produk** - Lihat daftar produk kantin
- 📦 **Keranjang** - Tambah/hapus produk dari keranjang
- 💳 **Pembayaran** - Integrasi payment gateway
- 📊 **Dashboard** - Analytics dan statistik penjualan

## 🛠 Tech Stack

- **Frontend**: Flutter 3.9.2+
- **Backend**: Firebase (Auth + Firestore)
- **Database**: Cloud Firestore
- **Authentication**: Firebase Authentication
- **State Management**: StatefulWidget
- **UI Framework**: Material Design 3

## 📦 Installation

### Prerequisites
- Flutter SDK 3.9.2 atau lebih tinggi
- Dart 3.9.2 atau lebih tinggi
- Git
- Firebase CLI (opsional)
- Android SDK atau Xcode (untuk development)

### Setup Steps

1. **Clone Repository**
```bash
git clone https://github.com/artfulabysswalker/SMART-E-KANTIN-.git
cd SMART-E-KANTIN-
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Konfigurasi Firebase** (lihat bagian berikut)

4. **Run Aplikasi**
```bash
flutter run
```

## 🔥 Konfigurasi Firebase

### 1. Setup Firebase Project
- Buka [Firebase Console](https://console.firebase.google.com/)
- Buat project baru dengan nama `SMART-E-KANTIN`
- Pilih region sesuai lokasi Anda

### 2. Enable Authentication
- Navigasi ke **Authentication** → **Sign-in method**
- Enable **Email/Password** authentication
- Enable **Anonymous** (opsional untuk testing)

### 3. Setup Firestore Database
- Navigasi ke **Firestore Database**
- Buat collection dengan nama `mahasiswa`
- Set security rules (copy dari `firebase_rules.json` jika ada)

### 4. Konfigurasi Project Flutter
```bash
# Login ke Firebase CLI
firebase login

# Konfigurasi Flutter untuk Firebase
flutterfire configure
```

### 5. Download Service Account Key (Android/iOS)
- Download `google-services.json` untuk Android
- Download `GoogleService-Info.plist` untuk iOS
- Tempatkan di folder yang sesuai

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── main_page.dart           # Main page navigation
├── firebase_options.dart    # Firebase configuration
├── dashboard_page.dart      # Dashboard/home page
├── auth/
│   ├── login_page.dart      # Login screen
│   ├── register_page.dart   # Registrasi screen
│   ├── forget_password.dart # Password reset screen
│   └── main_page.dart       # Auth main page
├── pages/
│   ├── home_page.dart       # Home page
│   └── item_page.dart       # Item listing page
└── Database/
    ├── model.dart           # Data models
    └── product_model.dart   # Product data model
```

## 🔐 Authentication

### Registrasi
```dart
// Validasi:
- NIM: minimum 8 karakter (numeric)
- Email: format email valid
- Password: minimum 6 karakter
- Confirm Password: harus sama dengan password

// Process:
1. Cek NIM belum terdaftar di Firestore
2. Cek Email belum terdaftar di Firestore
3. Create user di Firebase Authentication
4. Simpan data ke Firestore dengan NIM sebagai document ID
```

### Login
```dart
// Validasi:
- NIM: minimum 8 karakter
- Email: format valid
- Password: minimum 6 karakter

// Process:
1. Query Firestore untuk verifikasi NIM + Email
2. Sign in dengan Firebase Auth
3. Redirect ke Dashboard
```

### Lupa Password
```dart
// 2-Stage Process:
Stage 1: Verifikasi NIM + Email
- Input NIM dan Email
- Query Firestore untuk validasi
- Jika cocok, lanjut ke Stage 2

Stage 2: Reset Password
- Input password baru
- Validasi password rules
- Update di Firestore dan Firebase Auth
```

## 🗄️ Firestore Schema

### Collection: `mahasiswa`
```json
{
  "nim": "12345678",                    // Document ID
  "email": "student@university.edu",
  "uid": "firebase_user_id",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🚀 Development Guidelines

### Branch Strategy
- `main` - Production ready code
- `auth-navigation-update` - Authentication features
- `feature/*` - New features
- `fix/*` - Bug fixes

### Commit Convention
```
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Code formatting
refactor: Refactor code
test: Add tests
chore: Maintenance
```

### Testing
```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 API Documentation

### Register Endpoint (Local)
```dart
Future<void> _register() async {
  // Validates NIM, Email, Password
  // Creates Firebase Auth user
  // Stores data in Firestore
}
```

### Login Endpoint (Local)
```dart
Future<void> _login() async {
  // Validates NIM + Email existence
  // Signs in with Firebase Auth
  // Navigates to home
}
```

## 🔒 Security Considerations

- ✅ Password minimum 6 karakter (tingkatkan di production)
- ✅ Firebase Auth untuk secure authentication
- ✅ Firestore security rules (configure sesuai kebutuhan)
- ⚠️ TODO: Implement password hashing
- ⚠️ TODO: Add rate limiting untuk login attempts
- ⚠️ TODO: Implement email verification

## 🐛 Known Issues

- [ ] BuildContext warnings di forget_password.dart (perlu mounted check)
- [ ] Product model file naming convention
- [ ] Navigation to home page setelah login (TODO)

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)

## 👥 Contributors

- **Zen Vero Peno Pasa** (zenvero85@gmail.com)
- **Hillmi-Nazwar** (Hillminazwar12@gmail.com)
- **artfulabysswalker** (bloodborne6969240@gmail.com)

## 📄 License

Undecided - Hubungi maintainer untuk info lebih lanjut

## 📞 Support

Untuk issues atau pertanyaan, silakan buka issue di GitHub atau hubungi tim development.

---

**Last Updated**: December 6, 2025
**Version**: 1.0.0
