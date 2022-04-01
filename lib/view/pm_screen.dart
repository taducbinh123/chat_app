import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/message_screen_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 32,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Icon(Icons.mic, color: kPrimaryColor),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.face,
                          //       color: Theme.of(context)
                          //           .textTheme
                          //           .bodyText1!
                          //           .color!
                          //           .withOpacity(0.64),
                          //     )),
                          SizedBox(width: kDefaultPadding / 4),
                          Expanded(
                            child: TextField(
                              controller: messageController.myController.value,
                              enabled:
                                  messageController.myController.value == null
                                      ? false
                                      : true,
                              decoration: InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.attach_file,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                          SizedBox(width: kDefaultPadding / 4),
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 25,
                    ),
                    onPressed: () => {
                      messageController.sendMessage(
                          messageController.myController.value.text),
                      messageController.LoadMessage()
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(screenWidth, screenHeight) {
    RoomChatController roomChatController = Get.put(RoomChatController());
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
            var listMessage = Get.arguments['data'];
            roomChatController.getListMemberRoom(room.roomUid);
            Get.toNamed(settingScreen,
                arguments: {"room": room, "data": listMessage});
          },
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
