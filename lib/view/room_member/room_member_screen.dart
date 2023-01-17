import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/widgets/avatar_contact.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';

class RoomMemberScreen extends StatelessWidget {
  RoomMemberScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomChatController roomChatController = Get.find();
    final ClientSocketController clientSocketController = Get.find();

    print(clientSocketController.messenger.selectedRoom?.roomUid);
    roomChatController.getListMemberRoom(
        clientSocketController.messenger.selectedRoom?.roomUid ?? "");
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
            "Room Member",
            style: TextStyle(color: AppTheme.nearlyBlack, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Obx(
              () => ListView.builder(
                itemCount: roomChatController.employees.length,
                itemBuilder: (context, index) => CustomAvatarContact(
                  employee: roomChatController.employees[index],
                  press: () => {},
                ),
              ),
            ))
          ],
        ));
  }
}
