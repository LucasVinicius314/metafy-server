// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    commentCount: json['commentCount'] as int,
    content: json['content'] as String,
    createdAt: json['createdAt'] as String,
    id: json['id'] as int,
    likeCount: json['likeCount'] as int,
    liked: json['liked'] as int,
    likes: json['likes'] as List<dynamic>,
    updatedAt: json['updatedAt'] as String,
    user: json['user'],
    userId: json['userId'] as int,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'liked': instance.liked,
      'user': instance.user,
      'likes': instance.likes,
    };
