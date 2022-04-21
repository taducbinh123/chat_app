import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/controller/file_controller.dart';
import 'package:hello_world_flutter/controller/message_screen_controller.dart';
import 'package:hello_world_flutter/controller/nav_bar_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/view/Dashboard.dart';
import 'package:hello_world_flutter/view/chat_screen.dart';

import 'message/message.dart';

class MessagesScreen extends GetView<MessageScreenController> {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    final messageController = Get.put(MessageScreenController());
    final fileController = Get.put(FileController());
    final ClientSocketController clientSocketController = Get.find();

    return Scaffold(
      appBar: buildAppBar(screenWidth, screenHeight),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Obx(
                () => ListView.builder(
                    controller: messageController.controller,
                    itemCount:
                        clientSocketController.messenger.chatList.value.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (clientSocketController
                              .messenger.chatList.value.length ==
                          index)
                        return Center(child: CircularProgressIndicator());
                      return Message(
                          message: clientSocketController
                              .messenger.chatList.value[index]);
                    }),
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
                          Obx(
                            () => Expanded(
                              child: TextField(
                                controller:
                                    messageController.myController.value,
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
                          ),
                          IconButton(
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                      allowMultiple: true,
                                      withData: true,
                                      allowCompression: true);
                              if (result == null) return;
                              fileController.listFiles.value = result!.files;
                              fileController.uploadFile();
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
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

    final NavBarController navBarController = Get.find();
    RoomChatController roomChatController = Get.put(RoomChatController());
    final ClientSocketController clientSocketController = Get.find();
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.to(()=>Dashboard());
                navBarController.onItemTapped(0);
                clientSocketController.messenger.selectedRoom = null;
              },
            ),
            UserCircle(
              height: screenWidth * 0.1,
              width: screenHeight * 0.05,
            ),
            SizedBox(width: kDefaultPadding * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientSocketController
                          .messenger.selectedRoom?.roomDefaultName ??
                      "",
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
            roomChatController.getListMemberRoom(room.roomUid);
            Get.toNamed(settingScreen, arguments: {"room": room});
          },
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
