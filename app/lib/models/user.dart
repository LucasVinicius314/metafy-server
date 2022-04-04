import 'package:metafy_app/utils/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class User {
  String coverPicture;
  final String email;
  String profilePicture;
  final String username;

  User({
    required this.coverPicture,
    required this.email,
    required this.profilePicture,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User flushTimestamps() {
    final now = DateTime.now().toString();
    coverPicture =
        '${coverPicture.replaceAll(RegExp(r'\?.*$', dotAll: true), '')}?q=$now';
    profilePicture =
        '${profilePicture.replaceAll(RegExp(r'\?.*$', dotAll: true), '')}?q=$now';
    return this;
  }

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    return User.fromJson(await Api.post('user/login', {
      'email': email,
      'password': password,
    }));
  }

  static Future<User> validate() async {
    return User.fromJson(await Api.post('user/validate', {}));
  }

  static Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return User.fromJson(await Api.post('user/register', {
      'username': username,
      'email': email,
      'password': password,
    }));
  }

  static Future<User> update({
    required String username,
    required String email,
    // required String password,
  }) async {
    return User.fromJson(await Api.post('user/update', {
      'username': username,
      'email': email,
      // 'password': password,
    }));
  }
}
