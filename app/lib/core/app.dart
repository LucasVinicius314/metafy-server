import 'package:flutter/material.dart';
import 'package:metafy_app/core/auth/auth_screen.dart';
import 'package:metafy_app/core/main_screen.dart';
import 'package:metafy_app/core/splash_screen.dart';
import 'package:metafy_app/modules/profile_screen.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/providers/theme_provider.dart';
import 'package:metafy_app/utils/constants.dart';
import 'package:provider/provider.dart';

// TODO: fix, import all font weights
// TODO: l10n
// TODO: widget testing
// TODO: integration testing
// TODO: major refactor
// TODO: redesign the app's logo

final buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(24)),
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => AppProvider(),
          builder: (context, child) {
            return Consumer<ThemeProvider>(
              builder: (context, value, child) {
                return MaterialApp(
                  title: Constants.appName,
                  themeMode: value.themeMode,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    fontFamily: 'Poppins',
                    primarySwatch: Colors.red,
                    textButtonTheme: TextButtonThemeData(style: buttonStyle),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: buttonStyle,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: buttonStyle,
                    ),
                  ),
                  routes: {
                    SplashScreen.route: (_) => const SplashScreen(),
                    MainScreen.route: (_) => const MainScreen(),
                    AuthScreen.route: (_) => const AuthScreen(),
                    ProfileScreen.route: (_) => const ProfileScreen(),
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
