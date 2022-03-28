import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/chat_input_field.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/message_screen_controller.dart';
import 'package:hello_world_flutter/model/room.dart';

import 'message/message.dart';

class MessagesScreen extends GetView<MessageScreenController> {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    final messageController = Get.put(MessageScreenController());
    return Scaffold(
      appBar: buildAppBar(screenWidth, screenHeight),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ListView.builder(
                  itemCount: messageController.result.value.length,
                  itemBuilder: (context, index) =>
                      Message(message: messageController.result.value[index]),
                ),
              ),
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }

  AppBar buildAppBar(screenWidth, screenHeight) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            BackButton(),
            UserCircle(
              height: screenWidth * 0.1,
              width: screenHeight * 0.05,
            ),
            SizedBox(width: kDefaultPadding * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.arguments['room'].roomDefaultName,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   Get.arguments['data'].isActive
                //       ? "Online now"
                //       : "Last active " + Get.arguments['data'].time,
                //   style: TextStyle(fontSize: 12),
                // )
              ],
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Room room = Get.arguments['room'];
            print(room);
            Get.toNamed(settingScreen, arguments: {"room": room});
          },
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
