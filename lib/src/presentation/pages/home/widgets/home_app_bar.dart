import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/models/user_model.dart';

import '../../../../theme/theme_constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.inverted})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  final bool inverted;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0.0,
      backgroundColor: const Color(0x00000000),
      actions: <Widget>[
        Consumer<UserModel>(builder: (context, userModel, _) {
          return Text(
            "¡Hola ${userModel.firstName}!",
            style: TextStyle(
                color: inverted ? ToriColor.white : ToriColor.black,
                fontWeight: FontWeight.w300,
                fontSize: 16),
          );
        }),
        Opacity(
          opacity: inverted ? 0 : 1,
          child: Builder(
            builder: (context) {
              return IconButton(
                iconSize: 15,
                alignment: Alignment.centerRight,
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  color: ToriColor.black,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Consumer<UserModel>(
              builder: (context, userModel, _) {
                return Image(
                  image: NetworkImage(userModel.profileUrl),
                  alignment: Alignment.bottomCenter,
                  width: 50,
                  height: 50,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
