import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/model/room.dart';

class RoomMemberScreen extends StatelessWidget {
  RoomMemberScreen({Key? key, required this.room}) : super(key: key);
  Room room;

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
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: room.listChats.length,
            //     itemBuilder: (context, index) => CustomAvatarContact(
            //       chat: room.listChats[index],
            //       press: () => {
            //
            //       },
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
