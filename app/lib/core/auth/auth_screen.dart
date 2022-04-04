import 'package:flutter/material.dart';
import 'package:metafy_app/core/main_screen.dart';
import 'package:metafy_app/exceptions/invalid_data_exception.dart';
import 'package:metafy_app/models/user.dart';
import 'package:metafy_app/providers/app_provider.dart';
import 'package:metafy_app/utils/assets.dart';
import 'package:metafy_app/utils/constants.dart';
import 'package:metafy_app/widgets/metafy_logo_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const route = 'auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _info() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;

    showAboutDialog(
      context: context,
      applicationVersion: version,
      applicationIcon: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(resolveAsset(ImageAssets.logoIconT)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Constants.appName),
          actions: [
            IconButton(
              onPressed: _info,
              // TODO: fix, mdi icons
              icon: const Icon(Icons.info_outline),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(resolveAsset(ImageAssets.background)),
            ),
          ),
          child: const TabBarView(
            children: [
              LoginTab(),
              RegisterTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      AppProvider.of(context).user = await User.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.of(context).pushNamed(MainScreen.route);
    } on InvalidDataException catch (e) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(e.message),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(const Size.fromWidth(768)),
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const MetafyLogo(),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        right: 16,
                        left: 16,
                      ),
                      child: Column(
                        children: [
                          // TODO: fix, extract
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                          ),
                          // TODO: fix, extract
                          TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterTab extends StatefulWidget {
  const RegisterTab({Key? key}) : super(key: key);

  @override
  _RegisterTabState createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      AppProvider.of(context).user = await User.register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.of(context).pushNamed(MainScreen.route);
    } on InvalidDataException catch (e) {
      if (!mounted) return;

      await showDialog(
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
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(const Size.fromWidth(768)),
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: MetafyLogo()),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        right: 16,
                        left: 16,
                      ),
                      child: Column(
                        children: [
                          // TODO: fix, extract
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              icon: Icon(Icons.person),
                            ),
                          ),
                          // TODO: fix, extract
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                          ),
                          // TODO: fix, extract
                          TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _register,
                        child: const Text(
                          'Create account',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
