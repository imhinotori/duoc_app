import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/models/day_model.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/home_app_bar.dart';
import 'package:torilabs_duoc/src/presentation/pages/loading/loading_page.dart';
import 'package:torilabs_duoc/src/theme/theme_constants.dart';

import '../../../modules/duoc_requests.dart';
import '../home/widgets/home_navigation.dart';

enum Day { monday, tuesday, wednesday, thursday, friday }

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Future<Map<String, dynamic>>? _scheduleData;
  Day selectedDay = Day.monday;

  Future<Map<String, dynamic>> loadSchedule() async {
    List<dynamic> jsonResponse = await DuocRequest.getSchedule();
    return jsonResponse[0]["schedule"];
  }

  int getMinutesDifference(String startHour, String endHour) {
    DateTime startDate = DateFormat("HH:mm").parse(startHour);
    DateTime endDate = DateFormat("HH:mm").parse(endHour);
    int diff = endDate.difference(startDate).inMinutes;
    return diff;
  }

  List<dynamic> getDayData(List<dynamic> scheduleData) {
    List<dynamic> dayData = [];

    String lastEndTime = "08:00";
    for (Map<String, dynamic> subject in scheduleData) {
      int duration = getMinutesDifference(
        subject["start_time"],
        subject["end_time"],
      );

      int sinceLastClass = getMinutesDifference(
        lastEndTime,
        subject["start_time"],
      );

      lastEndTime = subject["end_time"];

      dayData.add(
        {
          "name": subject["subject_name"],
          "start": subject["start_time"],
          "end": subject["end_time"],
          "classroom": subject["classroom"].replaceAll("AV-", "").split(" ")[0],
          "duration": duration,
          "sinceLastClass": sinceLastClass,
        },
      );
    }
    return dayData;
  }

  Map<String, dynamic> loadCalendarData(Map<String, dynamic> scheduleData) {
    Map<String, dynamic> data = {};

    data[Day.monday.name] = getDayData(scheduleData["monday"]);
    data[Day.tuesday.name] = getDayData(scheduleData["tuesday"]);
    data[Day.wednesday.name] = getDayData(scheduleData["wednesday"]);
    data[Day.thursday.name] = getDayData(scheduleData["thursday"]);
    data[Day.friday.name] = getDayData(scheduleData["friday"]);
    return data;
  }

  List<Widget> getDayWidgets(List<dynamic> dayCalendarData) {
    List<Widget> dayWidgets = [];

    for (Map<String, dynamic> classData in dayCalendarData) {
      dayWidgets.add(ClassCard(
        classroom: classData["classroom"],
        durationMinutes: classData["duration"],
        minutesSinceLastClass: classData["sinceLastClass"],
        subjectName: classData["name"],
        start: classData["start"],
        end: classData["end"],
      ));
    }

    return dayWidgets;
  }

  Map<String, List<Widget>> loadCalendarWidgets(
      Map<String, dynamic> calendarData) {
    Map<String, List<Widget>> widgets = {};
    widgets["Day.monday"] = getDayWidgets(
      calendarData[Day.monday.name],
    );
    widgets["Day.tuesday"] = getDayWidgets(
      calendarData[Day.tuesday.name],
    );
    widgets["Day.wednesday"] = getDayWidgets(
      calendarData[Day.wednesday.name],
    );
    widgets["Day.thursday"] = getDayWidgets(
      calendarData[Day.thursday.name],
    );
    widgets["Day.friday"] = getDayWidgets(
      calendarData[Day.friday.name],
    );
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _scheduleData = loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _scheduleData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingPage();
        } else {
          Map<String, dynamic> calendarData = loadCalendarData(snapshot.data!);
          Map<String, List<Widget>> calendarWidgets =
              loadCalendarWidgets(calendarData);
          return ChangeNotifierProvider(
            create: (context) => DayModel(),
            child: Scaffold(
              appBar: const HomeAppBar(inverted: true),
              backgroundColor: ToriColor.secondary,
              bottomNavigationBar: const HomeButtonNavigation(
                currentIndex: 1,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(30, 20),
                        topRight: Radius.elliptical(30, 20),
                      ),
                      child: Container(
                        color: ToriColor.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DayButton(
                                  day: Day.monday,
                                  dateName: "Lunes",
                                ),
                                DayButton(
                                  day: Day.tuesday,
                                  dateName: "Martes",
                                ),
                                DayButton(
                                  day: Day.wednesday,
                                  dateName: "Miércoles",
                                ),
                                DayButton(
                                  day: Day.thursday,
                                  dateName: "Jueves",
                                ),
                                DayButton(
                                  day: Day.friday,
                                  dateName: "Viernes",
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 12,
                            child: SingleChildScrollView(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Column(
                                    children: [
                                      TimeText(time: "08:00"),
                                      TimeText(time: "09:00"),
                                      TimeText(time: "10:00"),
                                      TimeText(time: "11:00"),
                                      TimeText(time: "12:00"),
                                      TimeText(time: "13:00"),
                                      TimeText(time: "14:00"),
                                      TimeText(time: "15:00"),
                                      TimeText(time: "16:00"),
                                      TimeText(time: "17:00"),
                                      TimeText(time: "18:00"),
                                      TimeText(time: "19:00"),
                                      TimeText(time: "20:00"),
                                    ],
                                  ),
                                  Expanded(
                                    child: Consumer<DayModel>(
                                        builder: (context, dayModel, _) {
                                      List<Widget> cards = calendarWidgets[
                                              dayModel.selectedDay
                                                  .toString()] ??
                                          [];
                                      return Column(
                                        children: cards,
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.durationMinutes,
    required this.minutesSinceLastClass,
    required this.subjectName,
    required this.classroom,
    required this.start,
    required this.end,
  });

  final String subjectName;
  final String classroom;
  final int durationMinutes;
  final int minutesSinceLastClass;
  final String start;
  final String end;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: minutesSinceLastClass * 2),
      child: Container(
        height: durationMinutes * 2,
        color: const Color(0x8836C5A2),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: RichText(
                  text: TextSpan(
                    text: subjectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ToriColor.black,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: "\nSala: $classroom",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    start,
                    style: const TextStyle(color: ToriColor.black),
                  ),
                  Text(
                    end,
                    style: const TextStyle(color: ToriColor.black),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeText extends StatelessWidget {
  const TimeText({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      child: Text(
        time,
        style: const TextStyle(
            color: ToriColor.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            height: 0),
      ),
    );
  }
}

class DayButton extends StatelessWidget {
  const DayButton({
    super.key,
    required this.dateName,
    required this.day,
  });

  final String dateName;
  final Day day;

  @override
  Widget build(BuildContext context) {
    return Consumer<DayModel>(builder: (context, dayModel, _) {
      bool isSelected = day == dayModel.selectedDay;

      return ElevatedButton(
        onPressed: () {
          dayModel.setDay(day);
        },
        style: TextButton.styleFrom(
          minimumSize: const Size(65, 0),
          shadowColor: isSelected ? ToriColor.gray : ToriColor.black,
          backgroundColor: isSelected ? ToriColor.main : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style:
                TextStyle(color: isSelected ? ToriColor.white : ToriColor.gray),
            text: dateName,
            children: [
              TextSpan(
                text: "\n${dateName.substring(0, 2)}",
                style: TextStyle(
                    color: isSelected ? ToriColor.white : ToriColor.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 2),
              ),
            ],
          ),
        ),
      );
    });
  }
}
