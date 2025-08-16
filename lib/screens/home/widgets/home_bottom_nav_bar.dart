import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.selectedItemColor,
    required this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
      child: BottomNavigationBar(
        onTap: onTap,
        fixedColor: Colors.red,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              color: currentIndex == 0 ? selectedItemColor : unselectedItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.chartLine,
              color: currentIndex == 1 ? selectedItemColor : unselectedItemColor,
            ),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
