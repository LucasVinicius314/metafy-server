import 'package:flutter/material.dart';
import 'package:metafy_app/exceptions/invalid_data_exception.dart';
import 'package:metafy_app/extensions/date_time.dart';
import 'package:metafy_app/models/post.dart';
import 'package:metafy_app/modules/profile_screen.dart';
import 'package:metafy_app/utils/assets.dart';
import 'package:metafy_app/widgets/profile_view_widget.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/providers/theme_provider.dart';
import 'package:metafy_app/utils/services/networking.dart';
import 'package:metafy_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        AppProvider.of(context).posts = await Post.all();
      } finally {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metafy'),
        actions: [
          IconButton(
            tooltip: 'New post',
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                builder: (context) {
                  return const NewPostWidget();
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconTheme(
                    data: Theme.of(context).primaryIconTheme,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Edit profile',
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ProfileScreen.route);
                          },
                        ),
                        IconButton(
                          tooltip: 'Settings',
                          icon: const Icon(Icons.settings),
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              clipBehavior: Clip.antiAlias,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return const SettingsWidget();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(resolveAsset(ImageAssets.logoT)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, value, child) {
                  final user = value.user;
                  if (user == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Scaffold(
                    body: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Recent chats',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ...List.generate(3, (index) {
                          return ListTile(
                            title: const Text('Silvi'),
                            leading: const CircleAvatar(),
                            onTap: () {
                              // TODO: actual chats
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    floatingActionButton: Tooltip(
                      message: user.username,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(28),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          foregroundImage: NetworkImage(
                            Api.cdnAsset(user.profilePicture),
                          ),
                          child: InkWell(
                            onTap: () async {
                              // TODO: extract
                              await showModalBottomSheet(
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (context) {
                                  return ProfileViewWidget(user: user);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: BottomAppBar(
                      notchMargin: 6,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircularNotchedRectangle(),
                      child: BottomNavigationBar(
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        unselectedItemColor:
                            Theme.of(context).colorScheme.secondary,
                        items: const [
                          BottomNavigationBarItem(
                            label: 'Home',
                            icon: Icon(Icons.home),
                          ),
                          BottomNavigationBarItem(
                            label: 'Friends',
                            icon: Icon(Icons.people),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _loading ? const LoadingWidget() : const PostsWidget(),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SwitchListTile(
                title: const Text('Dark theme'),
                value: value.themeMode == ThemeMode.dark,
                onChanged: (themeMode) {
                  value.themeMode =
                      themeMode ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class NewPostWidget extends StatefulWidget {
  const NewPostWidget({Key? key}) : super(key: key);

  @override
  _NewPostWidgetState createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  bool _loading = false;

  final _contentController = TextEditingController();

  Future<void> _create() async {
    try {
      if (_loading) return;

      setState(() {
        _loading = true;
      });

      final res = await Post.create(content: _contentController.text);

      AppProvider.of(context).posts = await Post.all();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(res.message),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // TODO: onPressed
            },
          ),
        ),
      );
    } on InvalidDataException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(e.message),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // TODO: onPressed
              },
            ),
          ),
        );

        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'New post',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _contentController,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('Post'),
                    onPressed: _loading ? null : _create,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _liked = false;
  bool _loaded = true;

  Future<void> _toggleLike() async {
    try {
      if (_loaded) {
        setState(() {
          _loaded = false;
        });

        final res = await (_liked
            ? Post.unlike(id: widget.post.id)
            : Post.like(id: widget.post.id));

        setState(() {
          _liked = !_liked;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(res.message),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // TODO: onPressed
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    setState(() {
      _liked = widget.post.liked == 1;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(post.user['username']),
            subtitle: Text(
              DateTime.parse(post.createdAt).toFormat(),
              style: Theme.of(context).textTheme.caption,
            ),
            leading: CircleAvatar(
              foregroundImage: NetworkImage(
                Api.cdnAsset(
                  post.user['profilePicture'],
                ),
              ),
              child: InkWell(
                onTap: () async {
                  // TODO: extract
                  await showModalBottomSheet(
                    context: context,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return ProfileViewWidget(user: post.user);
                    },
                  );
                },
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: open menu
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: _loaded ? _toggleLike : null,
                child: Icon(
                  _liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  color: _liked ? null : Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostsWidget extends StatelessWidget {
  const PostsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, value, child) {
        final posts = value.posts;
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostWidget(post: post);
          },
        );
      },
    );
  }
}
