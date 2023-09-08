import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:hajj_app/helpers/styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      // backgroundColor: ColorSys.darkBlue,
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: ColorSys.darkBlue,
      margin: const EdgeInsets.only(bottom: 20, top: 20, right: 20, left: 20),
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Iconsax.home),
          title: const Text("Home"),
          selectedColor: ColorSys.darkBlue,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Iconsax.routing),
          title: const Text("Find Me"),
          selectedColor: ColorSys.darkBlue,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Iconsax.arrow),
          title: const Text("Search"),
          selectedColor: ColorSys.darkBlue,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Iconsax.setting_2),
          title: const Text("Settings"),
          selectedColor: ColorSys.darkBlue,
        ),
      ],
    );
  }
}
