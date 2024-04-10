import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/models/preferences_model.dart';
import 'package:torilabs_duoc/src/modules/duoc_requests.dart';
import 'package:torilabs_duoc/src/presentation/pages/login/login_page.dart';

import '../../../../models/user_model.dart';
import '../../../../theme/theme_constants.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: (Drawer(
        backgroundColor: ToriColor.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 80, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child:
                        Consumer<UserModel>(builder: (context, userModel, _) {
                      return Image(
                        image: NetworkImage(userModel.profileUrl),
                        alignment: Alignment.bottomCenter,
                        width: 100,
                        height: 100,
                      );
                    }),
                  ),
                  Consumer<UserModel>(builder: (context, userModel, _) {
                    return Text(
                      userModel.firstName,
                      style: const TextStyle(
                          color: ToriColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                  const CustomDivider(),
                  SwitchDivider(
                    preferencesCallback: (preferences, value) {
                      preferences.setShowAverage(value);
                    },
                    getSwitchCallback: (preferences) => preferences.showAverage,
                    icon: Icons.align_vertical_bottom_outlined,
                    text: "Mostrar promedio en Inicio",
                  ),
                  SwitchDivider(
                    preferencesCallback: (preferences, value) {
                      preferences.setShowAttendance(value);
                    },
                    getSwitchCallback: (preferences) =>
                        preferences.showAttendance,
                    icon: Icons.format_list_bulleted_outlined,
                    text: "Mostrar Asistencia en Inicio",
                  ),
                  const CustomDivider(),
                  SwitchDivider(
                    preferencesCallback: (_, __) {},
                    getSwitchCallback: (_) => true,
                    icon: Icons.fingerprint_outlined,
                    text: "Usar Face ID",
                  ),
                  const CustomDivider(),
                  SwitchDivider(
                    preferencesCallback: (_, __) {},
                    getSwitchCallback: (_) => true,
                    icon: Icons.add_moderator_outlined,
                    text: "Incluir Justificaciones en Asistencia",
                  ),
                  const CustomDivider(),
                  const ProfileButton(
                    icon: Icons.bakery_dining_outlined,
                    text: "Credencial Virtual",
                  ),
                  const ProfileButton(
                    icon: Icons.circle_notifications_outlined,
                    text: "Solicitudes en Linea",
                  ),
                  const ProfileButton(
                    icon: Icons.request_page_outlined,
                    text: "Solicitar Certificado",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.door_front_door_outlined,
                    color: ToriColor.black,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            BuildContext dialogContext = context;
                            return LogoutCard(dialogContext: dialogContext);
                          },
                        );
                      },
                      child: const Text(
                        "Cerrar Sesión",
                        style: TextStyle(color: ToriColor.black),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Made with ❤️ by ",
                        style:
                            TextStyle(color: Color(0x88000000), fontSize: 12),
                      ),
                      SvgPicture.asset(
                        'assets/svg/tori_logo.svg',
                        width: 60,
                        height: 65,
                        colorFilter: const ColorFilter.mode(
                          Color(0x88000000),
                          BlendMode.srcIn,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}

class LogoutCard extends StatelessWidget {
  const LogoutCard({
    super.key,
    required this.dialogContext,
  });

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.18,
      child: Card(
        color: ToriColor.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ToriColor.error,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 6.0, bottom: 10.0, left: 8.0, right: 8.0),
                      child: Icon(Icons.warning_rounded, size: 40),
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: ToriColor.black,
                        fontSize: 16,
                      ),
                      text: "Cerrar Sesión",
                      children: [
                        TextSpan(
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w300),
                            text: "\n¿Estás segur@ que quieres cerrar sesión?")
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        backgroundColor: ToriColor.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        DuocRequest.cleanTokens();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                      },
                      child: const Text(
                        "Cerrar Sesión",
                        style: TextStyle(color: ToriColor.white, fontSize: 14),
                      ),
                    ),
                  ),
                  OutlinedButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        backgroundColor: ToriColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 14, color: ToriColor.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      widthFactor: 0.9,
      child: Opacity(
        opacity: 0.17,
        child: Divider(
          thickness: 0.5,
          color: ToriColor.black,
        ),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              icon,
              color: ToriColor.gray,
            ),
          ),
          Flexible(
            flex: 8,
            child: Text(
              text,
              style: const TextStyle(
                color: ToriColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchDivider extends StatelessWidget {
  const SwitchDivider(
      {super.key,
      required this.icon,
      required this.text,
      required this.preferencesCallback,
      required this.getSwitchCallback});

  final IconData icon;
  final String text;
  final void Function(PreferencesModel, bool) preferencesCallback;
  final bool Function(PreferencesModel) getSwitchCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              icon,
              color: ToriColor.gray,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              text,
              style: const TextStyle(
                color: ToriColor.gray,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SwitchButton(
              preferencesCallback: preferencesCallback,
              getSwitchCallback: getSwitchCallback,
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {
  const SwitchButton(
      {super.key,
      required this.preferencesCallback,
      required this.getSwitchCallback});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();

  final void Function(PreferencesModel, bool) preferencesCallback;
  final bool Function(PreferencesModel) getSwitchCallback;
}

class _SwitchButtonState extends State<SwitchButton> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesModel>(
      builder: (BuildContext context, PreferencesModel preferences, _) {
        return Switch(
          value: widget.getSwitchCallback(preferences),
          activeColor: ToriColor.white,
          activeTrackColor: ToriColor.main,
          inactiveThumbColor: ToriColor.white,
          inactiveTrackColor: ToriColor.secondary,
          onChanged: (bool value) {
            setState(() {
              light = value;
            });
            widget.preferencesCallback(preferences, value);
          },
        );
      },
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, _) {
      return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.3,
                child: Card(
                  color: ToriColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BarcodeWidget(
                          barcode: Barcode.code128(),
                          height: 65,
                          drawText: false,
                          data: user.rut,
                          color: ToriColor.black,
                        ),
                        const Icon(
                          Icons.info,
                          color: ToriColor.black,
                          size: 32,
                        ),
                        RichText(
                          text: const TextSpan(
                              style: TextStyle(
                                  color: ToriColor.black, fontSize: 12),
                              text:
                                  "Este código podría ser solicitado en el ingreso a la sede o la biblioteca."),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: CustomRow(icon: icon, text: text));
    });
  }
}
