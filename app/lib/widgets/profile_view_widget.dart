import 'package:flutter/material.dart';
import 'package:metafy_app/models/user.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/utils/services/networking.dart';
import 'package:provider/provider.dart';

// TODO: improvement, pass either a logged user object or a regular user object

class ProfileViewWidget extends StatelessWidget {
  const ProfileViewWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  bool _shouldRestrict(User testUser) {
    // TODO: change email check to id check
    return testUser.email == user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, value, child) {
        final user = value.user;
        final restricted = _shouldRestrict(this.user);
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              Api.cdnAsset(user.coverPicture),
              fit: BoxFit.cover,
              height: 100,
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
                          tooltip: 'Add friend',
                          icon: const Icon(Icons.person_add),
                          onPressed: restricted
                              ? null
                              : () {
                                  // TODO: onPressed add friend
                                },
                        ),
                        IconButton(
                          tooltip: 'Send message',
                          icon: const Icon(Icons.chat),
                          onPressed: restricted
                              ? null
                              : () {
                                  // TODO: onPressed send message
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      user.username,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
