import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torilabs_duoc/src/models/preferences_model.dart';
import 'package:torilabs_duoc/src/models/user_model.dart';
import 'package:torilabs_duoc/src/presentation/pages/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => PreferencesModel(sharedPreferences),
    ),
    ChangeNotifierProvider(
      create: (context) => UserModel(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const AuthPage(),
    );
  }
}
