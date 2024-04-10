import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  late String _firstName;
  late String _profileUrl;
  late String _rut;

  String get firstName => _firstName;
  String get profileUrl => _profileUrl;
  String get rut => _rut;

  void setData(String firstName, String profileUrl, String rut) {
    _firstName = firstName;
    _profileUrl = profileUrl;
    _rut = rut;
  }
}
