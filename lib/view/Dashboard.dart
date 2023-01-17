import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/view/call/history_call_screen.dart';
import 'package:AMES/view/call/pending_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/widgets/bottom_nav_bar.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:AMES/features/features.dart';
import 'package:AMES/view/contact/contact_view.dart';
import 'Call/call_screen.dart';
import 'chat_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationController controller = Get.find();
    final NavBarController navBarController = Get.put(NavBarController());

    return Obx(() => Scaffold(
      // backgroundColor: AppTheme.dark_grey,
      body: SafeArea(
        child: IndexedStack(
          index: navBarController.selectedIndex,
          children: [
            HomePage(),
            ChatScreen(),
            HistoryCallScreen(),
            ContactView(),
            // PendingCallScreen(),
          ],
        ),
      ),
      bottomNavigationBar: SuperFaBottomNavigationBar(),
    ));
  }
}
