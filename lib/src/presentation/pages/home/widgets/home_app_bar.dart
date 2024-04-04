import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/models/user_model.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x00000000),
      actions: <Widget>[
        Consumer<UserModel>(builder: (context, userModel, _) {
          return Text(
            "¡Hola ${userModel.firstName}!",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 16),
          );
        }),
        Builder(builder: (context) {
          return IconButton(
              iconSize: 15,
              alignment: Alignment.centerRight,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ));
        }),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              return Image(
                image: NetworkImage(userModel.profileUrl),
                alignment: Alignment.bottomCenter,
                width: 50,
                height: 50,
              );
            }),
          ),
        ),
      ],
    );
  }
}
