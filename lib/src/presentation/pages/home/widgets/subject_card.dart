import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torilabs_duoc/src/presentation/pages/subject/subject_page.dart';

import '../../../../models/preferences_model.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    this.horizontalPadding,
    this.verticalPadding,
    required this.subjectName,
    required this.average,
    this.attendance,
  });

  final String subjectName;
  final double average;
  final String? attendance;

  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 5.0,
        vertical: verticalPadding ?? 5.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectPage(
                subjectName: subjectName,
              ),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3AD2E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.question_mark_rounded,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          subjectName,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        Consumer<PreferencesModel>(
                          builder: (context, options, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (options.showAverage)
                                  Text(
                                    "Promedio $average",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200),
                                  ),
                                if (options.showAverage &&
                                    options.showAttendance)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                if (options.showAttendance)
                                  Text(
                                    "Asistencia ${attendance ?? 'N/A'}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200),
                                  )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFFE3AD2E),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
