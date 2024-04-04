import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesModel extends ChangeNotifier {
  late bool _showAverage;
  late bool _showAttendance;

  late SharedPreferences _sharedPreferences;

  PreferencesModel(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
    _showAverage = _sharedPreferences.getBool("showAverage") ?? true;
    _showAttendance = _sharedPreferences.getBool("showAttendance") ?? true;
  }

  bool get showAverage => _showAverage;
  bool get showAttendance => _showAttendance;

  void setShowAverage(bool value) async {
    _showAverage = value;
    _sharedPreferences.setBool("showAverage", value);
    notifyListeners();
  }

  void setShowAttendance(bool value) async {
    _showAttendance = value;
    _sharedPreferences.setBool("showAttendance", value);
    notifyListeners();
  }
}
