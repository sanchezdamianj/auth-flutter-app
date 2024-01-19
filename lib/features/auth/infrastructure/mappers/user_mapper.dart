import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'] ?? '',
      roles:
          List<String>.from(json['roles'].map((role) => role)) ?? List.empty(),
      token: json['token'],
    );
  }
}
