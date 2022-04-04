import 'package:flutter/material.dart';
import 'package:metafy_app/models/post.dart';
import 'package:metafy_app/models/user.dart';
import 'package:provider/provider.dart';

class AppProvider with ChangeNotifier {
  User? _user;
  List<Post> _posts = [];

  // User

  User? get user {
    return _user;
  }

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  // Posts

  List<Post> get posts {
    return _posts;
  }

  set posts(List<Post> posts) {
    _posts = posts;
    notifyListeners();
  }

  static AppProvider of(BuildContext context) {
    return Provider.of<AppProvider>(context, listen: false);
  }

  static AppProvider listen(BuildContext context) {
    return Provider.of<AppProvider>(context, listen: true);
  }
}
