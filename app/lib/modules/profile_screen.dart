import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metafy_app/exceptions/invalid_data_exception.dart';
import 'package:metafy_app/models/user.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/utils/services/networking.dart';
import 'package:metafy_app/utils/services/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const route = 'profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You\'re about to log out'),
          content: const Text('Are you sure about that?'),
          actions: [
            TextButton(
              child: const Text('Yeah, let me go'),
              onPressed: () async {
                await Prefs.unsetAuthorization();
                AppProvider.of(context).user = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            TextButton(
              child: const Text('No, nevermind'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageScope scope) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    await Api.multipart('picture/upload', scope, pickedFile.path);

    final user = (await User.validate()).flushTimestamps();

    AppProvider.of(context).user = user;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text('Image updated'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // TODO: onPressed
          },
        ),
      ),
    );
  }

  Future<void> _update() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });

      try {
        await User.update(
          username: _usernameController.text,
          email: _emailController.text,
        );

        final user = await User.validate();

        if (mounted) {
          AppProvider.of(context).user = user;
          FocusScope.of(context).unfocus();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Profile updated'),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {
                  // TODO: onPressed
                },
              ),
            ),
          );
        }
      } on InvalidDataException catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Warning'),
                content: Text(e.message),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final user = AppProvider.of(context).user;

    if (user == null) return;

    _usernameController.text = user.username;
    _emailController.text = user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          final user = value.user;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              Tooltip(
                message: 'Change cover',
                child: InkWell(
                  child: Image.network(
                    Api.cdnAsset(user.coverPicture),
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  onTap: () {
                    _pickImage(ImageScope.cover);
                  },
                ),
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -48),
                      child: Tooltip(
                        message: 'Change profile picture',
                        child: Material(
                          elevation: 16,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(48),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            foregroundImage: NetworkImage(
                              Api.cdnAsset(user.profilePicture),
                            ),
                            child: InkWell(
                              onTap: () {
                                _pickImage(ImageScope.profile);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconTheme(
                      data: Theme.of(context).iconTheme.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Logout',
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              _logout(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          child: const Text('Update'),
                          onPressed: _loading ? null : _update,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
