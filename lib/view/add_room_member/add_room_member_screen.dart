import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/common/widgets/avatar_contact_add.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';

final ClientSocketController clientSocketController = Get.find();

class AddRoomMemberScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    RoomChatController roomChatController = Get.find();
    final ClientSocketController clientSocketController = Get.find();

    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    return Scaffold(
      appBar: searchAppBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Obx(() => Visibility(
                visible: roomChatController.listContactChoose.value.length != 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 8.0, 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            // Obx(() =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: roomChatController.listAvatarChoose),
                          // )
                        ),
                      ),
                      ElevatedButton(
                          child: Icon(
                            Icons.check,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.nearlyBlack,
                            shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            roomChatController.listAvatarChoose.clear();
                            roomChatController.inviteMember(
                                clientSocketController
                                    .messenger.selectedRoom?.roomUid,
                                clientSocketController
                                    .messenger.selectedRoom?.roomDefaultName);
                            Get.back();
                          }),
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Obx(
              () => GroupedListView<dynamic, String>(
                elements: clientSocketController.messenger.contactList.value,
                groupBy: (element) =>
                    element.USER_NM_KOR[0].toString().toUpperCase(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) => item1.USER_NM_KOR
                    .toString()
                    .compareTo(item2.USER_NM_KOR.toString()),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // showPreview: true,
                indexedItemBuilder: (context, element, index) =>
                    CustomAvatarContactAdd(
                  employee: element,
                  screen: "add",
                  press: () => {
                    // print("contact with ${element.USER_NM_ENG}"),
                    if (!roomChatController.changeState(
                        element, screenWidth, screenHeight))
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                            content: const Text('Member was in the room!'),
                            duration: const Duration(milliseconds: 1500),
                            // width: 280.0, // Width of the SnackBar.
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  8.0, // Inner padding for SnackBar content.
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        )
                      }
                  },
                  check: true,
                  index: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  searchAppBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    RoomChatController roomChatController = Get.find();
    return AppBar(
      // gradient: LinearGradient(
      //   colors: [
      //     gradientColorStart,
      //     gradientColorEnd,
      //   ],
      // ),
      backgroundColor: AppTheme.white,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack),
          onPressed: () => {
                clientSocketController.getContactList(),
                roomChatController.listContactChoose.value = [],
                roomChatController.resetState(),
                roomChatController.listAvatarChoose.clear(),
                Get.back(),
              }),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (value) => roomChatController.contactNameSearch(value),
            cursorColor: blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.nearlyBlack,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: AppTheme.nearlyBlack),
                onPressed: () {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => searchController.clear());
                  roomChatController.contactNameSearch("");
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: AppTheme.dark_grey.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
