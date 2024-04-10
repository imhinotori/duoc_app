import 'package:flutter/cupertino.dart';
import 'package:torilabs_duoc/src/presentation/pages/calendar/calendar_page.dart';

class DayModel extends ChangeNotifier {
  Day _selectedDay = Day.monday;

  get selectedDay => _selectedDay;

  void setDay(Day day) {
    _selectedDay = day;
    notifyListeners();
  }
}
