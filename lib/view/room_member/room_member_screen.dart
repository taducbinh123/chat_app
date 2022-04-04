import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';


class RoomMemberScreen extends StatelessWidget {
  RoomMemberScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomChatController roomChatController = Get.find();
    print("member " + Get.arguments['room'].roomUid);
    roomChatController.getListMemberRoom(Get.arguments['room'].roomUid);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => {
                    Get.back(),
                  }),
          title: Text(
            "Room Member",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
