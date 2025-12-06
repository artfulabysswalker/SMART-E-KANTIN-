class UserModel {
  final String useruid;
  final String usernim;
  final String email;
  final String fullname;
  double points;

  UserModel({
    required this.useruid,
    required this.usernim,
    required this.email,
    required this.fullname,
    required this.points,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      useruid: json['useruid'],
      usernim: json['usernim'],
      email: json['email'],
      fullname: json['fullname'],
      points: (json['points'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useruid': useruid,
      'usernim': usernim,
      'email': email,
      'fullname': fullname,
      'points': points,
    };
  }
}
