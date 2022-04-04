import 'package:metafy_app/models/common.dart';
import 'package:metafy_app/utils/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Post {
  int id;
  String content;
  int userId;
  String createdAt;
  String updatedAt;
  int likeCount;
  int commentCount;
  int liked;
  dynamic user; //  User -email
  List<dynamic> likes;

  Post({
    required this.commentCount,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.likeCount,
    required this.liked,
    required this.likes,
    required this.updatedAt,
    required this.user,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  static Future<Info> create({
    required String content,
  }) async {
    return Info.fromJson(await Api.post('post/create', {
      'content': content,
    }));
  }

  static Future<List<Post>> all() async {
    return (await Api.post('post/all', {}) as List<dynamic>)
        .map((e) => Post.fromJson(e))
        .toList();
  }

  static Future<Info> like({
    required int id,
  }) async {
    return Info.fromJson(await Api.post('post/like', {
      'id': id.toString(),
    }));
  }

  static Future<Info> unlike({
    required int id,
  }) async {
    return Info.fromJson(await Api.post('post/unlike', {
      'id': id.toString(),
    }));
  }
}
