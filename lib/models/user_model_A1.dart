// user_model_A1.dart

class UserModel_A1 {
  final String userId_A1;    // user_id (Primary Key/NIM)
  final String email_A1;     // email (Validasi: Wajib domain kampus)
  final String fullName_A1;  // full_name (Nama Lengkap)
  final String password_A1;  // password (Min. 6 Char)
  
  UserModel_A1({
    required this.userId_A1,
    required this.email_A1,
    required this.fullName_A1,
    required this.password_A1,
  });

  factory UserModel_A1.fromJson_A1(Map<String, dynamic> json) {
    return UserModel_A1(
      userId_A1: json['user_id'] as String,
      email_A1: json['email'] as String,
      fullName_A1: json['full_name'] as String,
      password_A1: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson_A1() {
    return {
      'user_id': userId_A1,
      'email': email_A1,
      'full_name': fullName_A1,
      'password': password_A1,
    };
  }
}