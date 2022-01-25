import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/controller/nav_bar_controller.dart';

class SuperFaBottomNavigationBar extends StatelessWidget {
  SuperFaBottomNavigationBar({
    Key? key,
  }) : super(key: key);
  final NavBarController navBarController = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              title: Text('Chats'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.phone,
              ),
              title: Text('Calls'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts,
              ),
              title: Text('Contacts'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text('Home'),
            ),
          ],
          currentIndex: navBarController.selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kPrimaryColor,
          onTap: (index) => navBarController.onItemTapped(index),
          /* currentIndex: Get.find<ProfileController>().selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: Get.find<ProfileController>().onItemTapped, */
        ));
  }
}
