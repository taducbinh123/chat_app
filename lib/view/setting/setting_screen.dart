import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
import 'package:hello_world_flutter/view/Dashboard.dart';
import 'package:hello_world_flutter/view/add_room_member/add_room_member_screen.dart';
import 'package:hello_world_flutter/view/room_member/room_member_screen.dart';


List _elements = [
  {'name': 'Add Member', 'group': 'Room Info'},
  {'name': 'Leave Room', 'group': 'Privacy'},
  {'name': 'Room Member', 'group': 'Room Info'},
];

RoomChatController roomChatController = Get.find();
ChatScreenController chatScreenController = Get.find();

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => {
                  Get.back(),
                }),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.center,
            child: UserCircle(
              width: screenWidth * 0.24,
              height: screenHeight * 0.12,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              Get.arguments['room'].roomDefaultName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GroupedListView<dynamic, String>(
              elements: _elements,
              groupBy: (element) => element['group'],
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1['name'].compareTo(item2['name']),
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (c, element) {
                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    child: ListTile(
                      title: Text(element['name']),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => {
                        if (element['name'].toString() == 'Room Member')
                          {
                            print("setting" + Get.arguments['room'].roomUid),
                            Get.to(() => RoomMemberScreen(),arguments: {"room": Get.arguments['room']}),
                          }
                        else if (element['name'].toString() == 'Leave Room')
                          {showAlertDialog(context,Get.arguments['room'].roomUid)}
                        else if(element['name'].toString() == 'Add Member'){
                          Get.to(() => AddRoomMemberScreen(),arguments: {"room": Get.arguments['room']})
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, var roomUid) {
// set up the buttons

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget launchButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        print(roomUid);
        await roomChatController.leaveRoom(roomUid);
        chatScreenController.initDataRoom();
        Get.offAll(() => Dashboard());
        // Get.back();Get.back();Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
          "Would you like to leave the room?"),
      actions: [
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
