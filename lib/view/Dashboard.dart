import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/bottom_nav_bar.dart';
import 'package:hello_world_flutter/controller/nav_bar_controller.dart';
import 'package:hello_world_flutter/view/Call/call_screen.dart';

import 'Contact/contact_screen.dart';
import 'chat_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavBarController navBarController = Get.put(NavBarController());
    return Obx(() => Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: navBarController.selectedIndex,
              children: [ChatScreen(),CallScreen(),ContactScreen()],
            ),
          ),
          bottomNavigationBar: SuperFaBottomNavigationBar(),
        ));
  }
}
