import 'package:flutter/material.dart';

class HomeButtonNavigation extends StatelessWidget {
  const HomeButtonNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF4F4F4),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          activeIcon: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15.0)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Icon(
                Icons.home_outlined,
                size: 40.0,
                color: Colors.black,
              ),
            ),
          ),
          icon: const Icon(
            Icons.home_outlined,
            size: 40.0,
            color: Colors.black,
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.black,
              size: 30.0,
            ),
            label: "")
      ],
    );
  }
}
