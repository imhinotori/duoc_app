import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../modules/duoc_requests.dart';
import '../../../theme/theme_constants.dart';
import '../home/home_page.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginError = false;

  void onLoginError() {
    setState(() {
      loginError = true;
    });

    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToriColor.secondary,
      body: Stack(children: [
        Positioned(
          bottom: 410,
          left: 130,
          child: Container(
            height: 600,
            width: 600,
            decoration: const BoxDecoration(
              color: ToriColor.main,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "¡Hola! 👋",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: loginError,
                        child: const Text(
                          "Revisa tus credenciales",
                          style:
                              TextStyle(color: ToriColor.error, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CredentialsGroup(loginError: loginError),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            text: "Recuperar contraseña",
                            style: const TextStyle(fontSize: 16),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: LoginButton(
                            onLoginError: onLoginError,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class CredentialsGroup extends StatelessWidget {
  const CredentialsGroup({
    super.key,
    required this.loginError,
  });

  final bool loginError;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: LoginInput(
              hintText: "Correo Electronico",
              hintTextColor: loginError ? ToriColor.error : ToriColor.gray,
            ),
          ),
          PasswordInput(
            hintText: "Contraseña",
            hintTextColor: loginError ? ToriColor.error : ToriColor.gray,
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onLoginError,
  });

  final VoidCallback onLoginError;

  void login(BuildContext context, VoidCallback onLoginError) async {
    Map<String, dynamic> jsonResponse = await DuocRequest.postLoginRequest(
        emailController.text, passwordController.text);

    if (jsonResponse.containsKey("token")) {
      await storage.write(key: "access_token", value: jsonResponse["token"]);
      if (context.mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } else {
      onLoginError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        login(context, onLoginError);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(ToriColor.main)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "Iniciar Sesión",
          style: TextStyle(color: ToriColor.white, fontSize: 20),
        ),
      ),
    );
  }
}

class LoginInput extends StatelessWidget {
  const LoginInput(
      {super.key, required this.hintText, required this.hintTextColor});

  final String hintText;
  final Color hintTextColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: const [AutofillHints.email],
      controller: emailController,
      style: const TextStyle(color: ToriColor.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: hintTextColor),
            borderRadius: BorderRadius.circular(15)),
        hintText: hintText,
        hintStyle: TextStyle(color: hintTextColor, fontWeight: FontWeight.w300),
        fillColor: ToriColor.white,
        filled: true,
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput(
      {super.key, required this.hintText, required this.hintTextColor});

  final String hintText;
  final Color hintTextColor;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: const [AutofillHints.password],
      controller: passwordController,
      obscureText: !_passwordVisible,
      style: const TextStyle(color: ToriColor.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.hintTextColor),
            borderRadius: BorderRadius.circular(15)),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  color: widget.hintTextColor,
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: _passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
              Icon(
                Icons.info,
                color: widget.hintTextColor,
              ),
            ],
          ),
        ),
        hintText: widget.hintText,
        hintStyle:
            TextStyle(color: widget.hintTextColor, fontWeight: FontWeight.w300),
        fillColor: ToriColor.white,
        filled: true,
      ),
    );
  }
}
