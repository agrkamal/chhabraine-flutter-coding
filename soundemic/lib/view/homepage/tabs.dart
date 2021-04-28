import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soundemic/constant/colors.dart';
import 'package:soundemic/controller/homepage_controller.dart';
import 'package:soundemic/controller/profile_controller.dart';
import 'package:soundemic/view/homepage/homepage.dart';
import 'package:soundemic/view/profile/user_profile.dart';

class TabScreen extends StatelessWidget {
  final HomepageController homepageController = Get.put(HomepageController());
  final ProfileController profileController = Get.put(ProfileController());

  final List<Map<String, Object>> _pages = [
    {
      'page': HomePage(),
    },
    {
      'page': UserProfile(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[homepageController.selectedPageIndex.value]['page'],
        // backgroundColor: kbackground2,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homepageController.selectedPageIndex.value,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: kbackground2,
          backgroundColor: kbackground1,
          onTap: (value) {
            homepageController.selectedPageIndex.value = value;
            print('$value');
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
              backgroundColor: kbackground1,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'Profile',
              backgroundColor: kbackground1,
            ),
          ],
        ),
        floatingActionButton: homepageController.selectedPageIndex.value == 1
            ? FloatingActionButton(
                child: const Icon(Icons.playlist_add),
                onPressed: () {
                  profileController.uploadSong();
                },
                backgroundColor: kbackground1,
                mini: true,
                tooltip: 'Add Song',
              )
            : null,
      ),
    );
  }
}
