import 'package:AMES/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:AMES/view/file_in_room_chat/attach_file.dart';

import '../../common/constant/path.dart';
import '../../common/constant/socket.dart';
import '../../controller/nav_bar_controller.dart';
import '../../model/message.dart';


class FileMultimediaRoomScreen extends StatelessWidget {
  const FileMultimediaRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomChatController roomChatController = Get.find();
    return Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack),
              onPressed: () => {
                    Get.back(),
                  }),
          title: Text(
            "Gallery",
            style: TextStyle(
                color: AppTheme.nearlyBlack, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        // body: Wrap(
        //   children: [
        //     SizedBox(
        //       height: 20,
        //     ),
        body: Obx(
          () => GridView.builder(
            itemCount: roomChatController.listFile.value.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 5/6
              // crossAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return AttachFileMultimedia(
                  fileMultimedia: roomChatController.listFile.value[index]);
            },
          ),
          //   )
          // ],
        ));
  }
}
