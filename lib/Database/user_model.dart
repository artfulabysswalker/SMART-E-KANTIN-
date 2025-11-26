
class UserModel {
  final String useruid;
  final String usernim;
  final String email;
  final String fullname;

  UserModel({
    required this.useruid,
    required this.usernim,
    required this.email,
    required this.fullname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      useruid: json['useruid'],
      usernim: json['usernim'],
      email: json['email'],
      fullname: json['fullname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useruid': useruid,
      'usernim': usernim,
      'email': email,
      'fullname': fullname,
    };
  }
}
