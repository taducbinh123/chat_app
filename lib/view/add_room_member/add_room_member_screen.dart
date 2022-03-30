
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact_add.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AddRoomMemberScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    RoomChatController roomChatController = Get.find();

    roomChatController.getListMemberRoom(Get.arguments['room'].roomUid);
    roomChatController.initDataEmployee();
    // ChatScreenController chatController = Get.find();
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
                          children:
                          roomChatController.listAvatarChoose
                      ),
                      // )
                    ),
                  ),
                  ElevatedButton(
                      child: Text("Add"),
                      onPressed: () {
                        roomChatController.listAvatarChoose.clear();
                        roomChatController.inviteMember(Get.arguments['room'].roomUid, Get.arguments['room'].roomDefaultName);
                        // chatController.createChatroom(contactController.listContactChoose);
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
                elements: roomChatController.contactList.value,
                groupBy: (element) => element.USER_NM_KOR[0].toString().toUpperCase(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1.USER_NM_KOR.toString().compareTo(item2.USER_NM_KOR.toString()),
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
                        print("contact with ${element.USER_NM_ENG}"),
                        roomChatController.changeState(element, screenWidth, screenHeight),
                        // print(contactController.getStateByChat(element)),
                        // Get.to(() => MessagesScreen()),
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
    return NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          gradientColorStart,
          gradientColorEnd,
        ],
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {
            Get.back(),
            // roomChatController.contactList.value = roomChatController.initData,
            roomChatController.listContactChoose.value = [],
            roomChatController.resetState(),
            roomChatController.listAvatarChoose.clear(),
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
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => searchController.clear());
                  roomChatController.contactList.value = roomChatController.initData;
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
