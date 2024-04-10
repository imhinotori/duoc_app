import 'package:flutter/material.dart';
import 'package:torilabs_duoc/src/theme/theme_constants.dart';

class NextClassCard extends StatelessWidget {
  const NextClassCard({
    super.key,
    required this.classroom,
    required this.time,
    required this.subjectName,
  });

  final String classroom;
  final String time;
  final String subjectName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5.0,
        )
      ]),
      child: Card(
        color: ToriColor.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ToriColor.main,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 0.5),
                        child: Text(classroom),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2C44),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 0.5),
                      child: Text(time),
                    ),
                  ),
                ],
              ),
              const Text(
                "Tu siguiente clase:",
                style: TextStyle(
                    color: ToriColor.gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                subjectName,
                style: const TextStyle(
                  color: ToriColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
