import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torilabs_duoc/src/modules/duoc_requests.dart';

import '../../../theme/theme_constants.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, required this.subjectName});

  final String subjectName;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  Future<Map<String, dynamic>>? _subjectGrades;
  Future<Map<String, dynamic>>? _subjectAttendance;

  Future<Map<String, dynamic>> loadGrades() async {
    List<dynamic> response = await DuocRequest.getGrades();

    for (Map<String, dynamic> subject in response[0]["subjects"]) {
      if (subject["name"] != widget.subjectName) continue;
      return subject;
    }
    return {};
  }

  Future<Map<String, dynamic>> loadAttendance() async {
    List<dynamic> response = await DuocRequest.getAttendance();

    for (Map<String, dynamic> subject in response[0]["attendance"]) {
      if (subject["name"] != widget.subjectName) continue;
      return subject;
    }
    return {"details": [], "percentage": "N/A"};
  }

  List<Widget> getGradeWidgets(Map<String, dynamic> gradesData) {
    List<Widget> cards = [];
    for (var grade in gradesData["partials"]) {
      Widget card = BlueCard(
        text: grade.toString(),
        horizontalPadding: 18,
        verticalPadding: 18,
        fontSize: 24,
      );
      cards.add(card);
    }
    if (cards.isNotEmpty) {
      return cards;
    }

    return [
      const BlueCard(
          text: "N/A",
          horizontalPadding: 18,
          verticalPadding: 18,
          fontSize: 24),
    ];
  }

  @override
  void initState() {
    super.initState();

    _subjectGrades = loadGrades();
    _subjectAttendance = loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subjectName,
          style: const TextStyle(fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: ToriColor.white, size: 40.0),
        backgroundColor: ToriColor.secondary,
      ),
      backgroundColor: ToriColor.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      "Mis Notas",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ToriColor.black,
                          fontSize: 24),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Divider(
                      color: ToriColor.main,
                      thickness: 2.5,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text(
                "Parciales:",
                style: TextStyle(fontSize: 16, color: ToriColor.black),
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<Map<String, dynamic>>(
                  future: _subjectGrades!,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    List<Widget> gradeCards = [
                      const BlueCard(
                        text: "N/A",
                        horizontalPadding: 18,
                        verticalPadding: 18,
                        fontSize: 24,
                      )
                    ];
                    if (snapshot.hasData) {
                      gradeCards = getGradeWidgets(
                        snapshot.data!,
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: gradeCards),
                    );
                  }),
            ),
            const Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Examen:",
                      style: TextStyle(
                        fontSize: 16,
                        color: ToriColor.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Promedio:",
                      style: TextStyle(
                        fontSize: 16,
                        color: ToriColor.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder<Map<String, dynamic>>(
                  future: _subjectGrades!,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    String examText = "N/A";
                    String averageText = "N/A";
                    if (snapshot.hasData) {
                      examText = snapshot.data!["exams"][0].toString();
                      averageText = snapshot.data!["average"].toString();
                    }
                    Widget exam = BlueCard(
                      text: examText,
                      horizontalPadding: 45,
                      verticalPadding: 16,
                      fontSize: 24,
                    );

                    Widget average = BlueCard(
                      text: averageText,
                      horizontalPadding: 45,
                      verticalPadding: 16,
                      fontSize: 24,
                    );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        exam,
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: average,
                          ),
                        )
                      ],
                    );
                  }),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(
                    flex: 16,
                    child: Text(
                      "Mi Asistencia",
                      style: TextStyle(
                          color: ToriColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                  ),
                  const Expanded(
                    flex: 9,
                    child: Divider(
                      color: ToriColor.main,
                      thickness: 2.5,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: FutureBuilder(
                          future: _subjectAttendance!,
                          builder: (context, snapshot) {
                            String text = "";
                            if (snapshot.hasData) {
                              text = "${snapshot.data!["percentage"]}";
                              if (text != "N/A") text += "%";
                            }
                            return BlueCard(
                              text: text,
                              horizontalPadding: 15,
                              verticalPadding: 5,
                              fontSize: 16.0,
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _subjectAttendance!,
                  builder: (context, snapshot) {
                    List<Widget> attendanceCards = [];
                    if (snapshot.hasData) {
                      for (Map<String, dynamic> detail
                          in snapshot.data!["details"]) {
                        attendanceCards.add(
                          AttendanceCard(
                            date: detail["date"].split("T")[0],
                            attended: detail["attendance"].isOdd,
                          ),
                        );
                      }
                    }
                    return SingleChildScrollView(
                        child: Column(children: attendanceCards));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.attended,
    required this.date,
  });

  final bool attended;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: <Widget>[
          AttendanceIcon(attended: attended),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: RichText(
              text: TextSpan(
                text: date,
                style: const TextStyle(color: ToriColor.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: attended ? "\nAsistente" : "\nInasistente",
                    style: const TextStyle(
                      color: ToriColor.gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AttendanceIcon extends StatelessWidget {
  const AttendanceIcon({
    super.key,
    required this.attended,
  });

  final bool attended;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: attended ? ToriColor.success : ToriColor.error,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          attended ? Icons.face : Icons.face_retouching_off_outlined,
          size: 30,
        ),
      ),
    );
  }
}

class BlueCard extends StatelessWidget {
  const BlueCard(
      {super.key,
      required this.text,
      required this.horizontalPadding,
      required this.verticalPadding,
      required this.fontSize});

  final String text;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: ToriColor.black,
      color: ToriColor.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: ToriColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
