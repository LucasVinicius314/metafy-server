// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    coverPicture: json['coverPicture'] as String,
    email: json['email'] as String,
    profilePicture: json['profilePicture'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'coverPicture': instance.coverPicture,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'username': instance.username,
    };
