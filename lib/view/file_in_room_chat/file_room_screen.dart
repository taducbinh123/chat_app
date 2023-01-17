import 'package:AMES/common/app_theme.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:AMES/view/file_in_room_chat/file.dart';


class FileRoomScreen extends StatelessWidget {
  const FileRoomScreen({Key? key}) : super(key: key);

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
            "Files",
            style: TextStyle(
                color: AppTheme.nearlyBlack, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Obx(() => ListView.builder(
          padding: EdgeInsets.all(10.0),
            itemCount: roomChatController.listFile.value.length,
            itemBuilder: (context, index) {
              return File(
                  file: roomChatController.listFile.value[index]);
            })));
  }
}
