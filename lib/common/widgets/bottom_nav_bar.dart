import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:AMES/features/features.dart';

class SuperFaBottomNavigationBar extends StatelessWidget {
  SuperFaBottomNavigationBar({
    Key? key,
  }) : super(key: key);
  final NavBarController navBarController = Get.put(NavBarController());

  final ClientSocketController clientSocketController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: AppTheme.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  // Container(
                  // height: 18,
                  // width: 18,
                  // child:
                  Stack(children: [
                Icon(
                  Icons.message,
                ),
                if (clientSocketController
                        .messenger.totalRoomUnReadMessage.value >
                    0)
                  Positioned(
                    top: -1,
                    right: -2,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: kErrorColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 2),
                      ),
                      // child: Center(
                      //   child: Opacity(
                      //     opacity: 0.9,
                      //     child: Text(
                      //       clientSocketController
                      //           .messenger.totalRoomUnReadMessage
                      //           .toString(),
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.white),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                    ),
                  )
              ]),
              // ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.phone,
              ),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts,
              ),
              label: 'Contacts',
            ),
          ],
          currentIndex: navBarController.selectedIndex,
          selectedItemColor: AppTheme.nearlyBlack,
          unselectedItemColor: AppTheme.dark_grey.withOpacity(0.6),
          onTap: (index) => navBarController.onItemTapped(index),
          /* currentIndex: Get.find<ProfileController>().selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: Get.find<ProfileController>().onItemTapped, */
        ));
  }
}
