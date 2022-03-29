import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/model/room.dart';

class RoomMemberScreen extends StatelessWidget {
  RoomChatController roomChatController = Get.find();
  RoomMemberScreen({Key? key, required this.employees}) : super(key: key);
  List employees;

  @override
  Widget build(BuildContext context) {
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
                          press: () => {
                          },
                        ),
                      ),)
            )
          ],
        ));
  }
}
