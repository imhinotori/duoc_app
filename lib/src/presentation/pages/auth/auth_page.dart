import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:torilabs_duoc/src/modules/duoc_requests.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/home_page.dart';
import 'package:torilabs_duoc/src/presentation/pages/loading/loading_page.dart';
import 'package:torilabs_duoc/src/presentation/pages/login/login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<bool>? _userConnected;
  final storage = const FlutterSecureStorage();

  Future<bool> _checkConnection() async {
    try {
      await DuocRequest.getAccessToken();
      return true;
    } on WrongUserAuthException {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _userConnected = _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userConnected,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else {
            return const LoadingPage();
          }
        });
  }
}
