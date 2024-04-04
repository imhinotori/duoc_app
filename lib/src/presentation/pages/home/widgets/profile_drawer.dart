import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/models/preferences_model.dart';

import '../../../../models/user_model.dart';

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
        backgroundColor: const Color(0xffebebeb),
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
                          color: Colors.black,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.door_front_door_outlined,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Text(
                      "Cerrar Sesión",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Text(
                    "Made with love by ToriLabs",
                    style: TextStyle(color: Colors.black),
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
          color: Colors.black,
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
              color: const Color(0xff767676),
            ),
          ),
          Flexible(
            flex: 8,
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xff767676),
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
              color: const Color(0xff767676),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xff767676),
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
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFE3AD2E),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xff0b2c44),
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
    return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Container(
                color: Colors.blue,
                child: const Icon(Icons.qr_code_2_outlined),
              ),
            ),
          );
        },
        child: CustomRow(icon: icon, text: text));
  }
}
