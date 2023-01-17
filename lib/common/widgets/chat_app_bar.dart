import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';

import '../../view/contact/add_contact_screen.dart';
import 'custom_app_bar.dart';


class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget> actions;
  final numberNotification;
  // final leading;

  const ChatAppBar({
    Key? key,
    @required this.title,
    required this.actions,
    required this.numberNotification,
    // required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClientSocketController clientSocketController = Get.find();
    final contactController = Get.put(ContactScreenController());

    return CustomAppBar(
      leading: Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.group_add,
              color: AppTheme.nearlyBlack,
            ),
            onPressed: () {
              Get.to(() => AddContactScreen());
              contactController.listContactChoose.value = [];
              contactController.resetState();
            },
          ),
          // if (numberNotification > 0)
          //   Positioned(
          //     left: 26,
          //     top: 25,
          //     child:
          //     Container(
          //       height: 18,
          //       width: 18,
          //       decoration: BoxDecoration(
          //         color: kErrorColor,
          //         shape: BoxShape.circle,
          //         border: Border.all(
          //             color: kErrorColor,
          //             width: 0),
          //       ),
          //       child: Center(
          //         child: Opacity(
          //           opacity: 0.9,
          //           child: Text(
          //             numberNotification.toString() ?? "",
          //             style: TextStyle(
          //                 fontWeight: numberNotification > 0
          //                     ? FontWeight.w500
          //                     : FontWeight.w400,color: kContentColorDarkTheme),
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
      title: (title is String)
          ? Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )
          : title,
      centerTitle: true,
      actions: actions,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
