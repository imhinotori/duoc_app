import 'package:flutter/material.dart';
import 'package:torilabs_duoc/src/presentation/pages/calendar/calendar_page.dart';
import 'package:torilabs_duoc/src/presentation/pages/home/home_page.dart';

import '../../../../theme/theme_constants.dart';

class HomeButtonNavigation extends StatefulWidget {
  const HomeButtonNavigation({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  State<HomeButtonNavigation> createState() => _HomeButtonNavigationState();
}

class _HomeButtonNavigationState extends State<HomeButtonNavigation> {
  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
  ];

  void onTabTapped(int index) {
    if (widget.currentIndex != index) {
      if (index == 0) {
        Navigator.pop(context);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => _pages[index]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: onTabTapped,
      backgroundColor: ToriColor.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          activeIcon: Container(
            decoration: BoxDecoration(
                color: ToriColor.gray,
                borderRadius: BorderRadius.circular(15.0)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Icon(
                Icons.home_outlined,
                size: 40.0,
                color: ToriColor.black,
              ),
            ),
          ),
          icon: const Icon(
            Icons.home_outlined,
            size: 40.0,
            color: ToriColor.black,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
            activeIcon: Container(
              decoration: BoxDecoration(
                  color: ToriColor.gray,
                  borderRadius: BorderRadius.circular(15.0)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 43, vertical: 4),
                child: Icon(
                  Icons.calendar_today,
                  size: 30.0,
                  color: ToriColor.black,
                ),
              ),
            ),
            icon: const Icon(
              Icons.calendar_today,
              color: ToriColor.black,
              size: 30.0,
            ),
            label: "")
      ],
    );
  }
}
