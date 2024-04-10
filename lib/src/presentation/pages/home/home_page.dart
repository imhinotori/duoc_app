import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/modules/duoc_requests.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/home_app_bar.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/home_navigation.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/next_class_card.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/profile_drawer.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/widgets/subject_card.dart';
import 'package:torilabs_duoc/src/presentation/pages/loading/loading_page.dart';

import '../../../models/user_model.dart';
import '../../../theme/theme_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>>? _schedule;
  Future<Map<String, dynamic>>? _attendance;
  Future<Map<String, dynamic>>? _grades;
  Future<Map<String, dynamic>>? _student;

  Future<Map<String, dynamic>> loadSchedule() async {
    List<dynamic> jsonResponse = await DuocRequest.getSchedule();
    return jsonResponse[0];
  }

  Future<Map<String, dynamic>> loadAttendance() async {
    List<dynamic> jsonResponse = await DuocRequest.getAttendance();
    return jsonResponse[0];
  }

  Future<Map<String, dynamic>> loadGrades() async {
    List<dynamic> jsonResponse = await DuocRequest.getGrades();
    return jsonResponse[0];
  }

  Future<Map<String, dynamic>> loadStudent() async {
    Map<String, dynamic> studentData = await DuocRequest.getStudent();
    return studentData;
  }

  @override
  void initState() {
    super.initState();
    _schedule = loadSchedule();
    _attendance = loadAttendance();
    _grades = loadGrades();
    _student = loadStudent();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_schedule!, _attendance!, _grades!, _student!]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingPage();
        } else {
          Map<String, dynamic> schedule = snapshot.data?[0];
          Map<String, dynamic> attendance = snapshot.data?[1];
          Map<String, dynamic> grades = snapshot.data?[2];
          Map<String, dynamic> student = snapshot.data?[3];
          List<Widget> subjects = [];

          for (int i = 0; i < grades["subjects"].length; i++) {
            String? attendancePercentage;
            for (Map<String, dynamic> subject in attendance["attendance"]) {
              if (subject["code"] == grades["subjects"][i]["code"]) {
                attendancePercentage = "${subject["percentage"]}%";
              }
            }
            SubjectCard subjectCard = SubjectCard(
              subjectName: grades["subjects"][i]["name"],
              average: grades["subjects"][i]["average"].toDouble(),
              attendance: attendancePercentage,
            );
            subjects.add(subjectCard);
          }

          // GMT-3
          DateTime now = DateTime.now().subtract(const Duration(hours: 4));
          String day = DateFormat('EEEE').format(now);
          String hour = DateFormat('HH:mm').format(now);

          List<dynamic> todayData = schedule["schedule"][day.toLowerCase()];

          String classroom = "";
          String time = "";
          String subject = "";

          for (Map<String, dynamic> classSchedule in todayData) {
            if (hour.compareTo(classSchedule["end_time"]) > 0) {
              continue;
            } else {
              subject = classSchedule["subject_name"];

              List<String> currentTime = hour.split(":");
              List<String> classTime = classSchedule["start_time"].split(":");

              int timeDelta;
              String suffix;

              if (currentTime[0] == classTime[0]) {
                timeDelta = int.parse(classTime[1]) - int.parse(currentTime[1]);
                suffix = (timeDelta == 1) ? "Minuto" : "Minutos";
              } else {
                timeDelta = int.parse(classTime[0]) - int.parse(currentTime[0]);
                suffix = (timeDelta > 1) ? "Horas" : "Hora";
              }

              time = (timeDelta >= 0) ? "$timeDelta $suffix" : "Ahora";

              classroom = classSchedule["classroom"]
                  .replaceAll("AV-", "")
                  .split(" ")[0];
              break;
            }
          }

          String firstName = student["full_name"].split(' ')[0];

          NextClassCard nextClassCard = NextClassCard(
            classroom: classroom,
            time: time,
            subjectName: subject,
          );

          return Consumer<UserModel>(builder: (context, model, _) {
            model.setData(firstName, student["avatar"], student["rut"]);
            return Scaffold(
              backgroundColor: ToriColor.white,
              bottomNavigationBar: const HomeButtonNavigation(
                currentIndex: 0,
              ),
              appBar: const HomeAppBar(
                inverted: false,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(30, 20),
                          topRight: Radius.elliptical(30, 20),
                        ),
                        child: Container(
                          color: const Color(0xFF0B2C44),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          nextClassCard,
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ramos",
                              style: TextStyle(
                                color: ToriColor.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: subjects,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              endDrawer: const ProfileDrawer(),
            );
          });
        }
      },
    );
  }
}
