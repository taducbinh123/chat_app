import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:AMES/common/app_theme.dart';

import 'package:AMES/common/widgets/user_circle.dart';
import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:AMES/view/add_room_member/add_room_member_screen.dart';
import 'package:AMES/view/file_in_room_chat/file_multimedia_room_screen.dart';
import 'package:AMES/view/file_in_room_chat/file_room_screen.dart';
import 'package:AMES/view/room_member/room_member_screen.dart';

class SettingScreen extends StatelessWidget {
  final roomChatController = Get.put(RoomChatController());
  ChatScreenController chatScreenController = Get.find();
  final ClientSocketController clientSocketController = Get.find();

  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    return Scaffold(
        backgroundColor: AppTheme.background2,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.background2,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack),
              onPressed: () => {
                    Get.back(),
                  }),
          title: Text(
            "",
            style: TextStyle(
                color: AppTheme.nearlyBlack, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Scrollbar(
          // child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: UserCircle(
                  width: screenWidth * 0.24,
                  height: screenHeight * 0.12,
                  check: false,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: AutoSizeText(
                  clientSocketController.messenger.selectedRoom?.roomType !=
                          "IN_CHATROOM"
                      ? clientSocketController
                              .messenger.selectedRoom?.contactRoomName ??
                          ""
                      : clientSocketController.messenger.roomNameSelected.value
                          .toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white),
                    child: GroupedListView<dynamic, String>(
                      stickyHeaderBackgroundColor: AppTheme.nearlyWhiteBg,
                      // separator:  Divider(
                      //   color: AppTheme.dark_grey,
                      // ),
                      elements: chatScreenController.elements,
                      groupBy: (element) => element['group'],
                      groupComparator: (value1, value2) =>
                          value2.compareTo(value1),
                      itemComparator: (item1, item2) =>
                          item1['name'].compareTo(item2['name']),
                      order: GroupedListOrder.ASC,
                      useStickyGroupSeparators: false,
                      groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: Text(
                            value,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      itemBuilder: (c, element) {
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color:
                                      AppTheme.nearlyBlack.withOpacity(0.05)),
                              // top: BorderSide(width: 1, color: AppTheme.nearlyBlack.withOpacity(0.1))
                            )),
                            child: ListTile(
                              title: Text(element['name']),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () => {
                                if (element['name'].toString() == 'Room Member')
                                  {
                                    Get.to(() => RoomMemberScreen()),
                                  }
                                else if (element['name'].toString() ==
                                    'Leave Room')
                                  {
                                    showAlertDialog(
                                        context,
                                        clientSocketController
                                            .messenger.selectedRoom?.roomUid)
                                  }
                                else if (element['name'].toString() ==
                                    'Add Member')
                                  {Get.to(() => AddRoomMemberScreen())}
                                else if (element['name'].toString() ==
                                    'Change Room Name')
                                  {
                                    showDialogChangeRoomName(
                                        context,
                                        clientSocketController
                                            .messenger.selectedRoom?.roomUid,
                                        clientSocketController
                                            .messenger.selectedRoom?.roomType)
                                  },
                                if (element['name'].toString() == 'Files')
                                  {
                                    roomChatController.getAttachmentInRoom(2),
                                    Get.to(() => FileRoomScreen()),
                                  },
                                if (element['name'].toString() == 'Gallery')
                                  {
                                    roomChatController.getAttachmentInRoom(3),
                                    Get.to(() => FileMultimediaRoomScreen()),
                                  }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          // ),
        ));
  }

  showAlertDialog(BuildContext context, var roomUid) {
// set up the buttons
    final NavBarController navBarController = Get.find();

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
        await Future.delayed(Duration(milliseconds: 100), () {});
        chatScreenController.initDataRoom();
        Get.back();
        Get.back();
        Get.back();
        navBarController.onItemTapped(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Would you like to leave the room?"),
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

  showDialogChangeRoomName(BuildContext context, var roomUid, var roomType) {
    final _roomNameController = TextEditingController();
    _roomNameController.clear();
    final _formKey = GlobalKey<FormState>();
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

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
        if (_formKey.currentState!.validate()) {
          await roomChatController.changeRoomName(
              roomUid, _roomNameController.text, roomType);
          // chatScreenController.initDataRoom();
          Navigator.of(context).pop();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enter New Room Name"),
      content: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.1,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                width: screenWidth * 0.6,
                height: screenHeight * 0.1,
                child: TextFormField(
                  controller: _roomNameController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Room Name is required.';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
      ),
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
