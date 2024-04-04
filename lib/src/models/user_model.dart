import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  late String _firstName = "placeholder";
  late String _profileUrl = "placeholder";

  UserModel(String firstName, String profileUrl) {
    _firstName = firstName;
    _profileUrl = profileUrl;
  }

  String get firstName => _firstName;
  String get profileUrl => _profileUrl;
}
