import 'package:flutter/material.dart';
import 'package:metafy_app/core/auth/auth_screen.dart';
import 'package:metafy_app/core/main_screen.dart';
import 'package:metafy_app/models/user.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/utils/assets.dart';
import 'package:metafy_app/utils/services/shared_preferences.dart';
import 'package:metafy_app/widgets/metafy_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const route = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final authorization = await Prefs.getAuthorization();

      try {
        if (authorization != null) {
          AppProvider.of(context).user = await User.validate();

          await Navigator.of(context).pushReplacementNamed(MainScreen.route);

          return;
        }

        await Navigator.of(context).pushReplacementNamed(AuthScreen.route);
      } catch (e) {
        await Navigator.of(context).pushReplacementNamed(AuthScreen.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  MetafyLogo(),
                  CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
