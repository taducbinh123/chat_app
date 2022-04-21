
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact_add.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/view/Dashboard.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

final ClientSocketController clientSocketController = Get.find();
class AddContactScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find();
    ChatScreenController chatController = Get.find();

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
                visible: contactController.listContactChoose.value.length != 0,
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
                                  contactController.listAvatarChoose
                              ),
                            // )
                        ),
                      ),
                      ElevatedButton(
                          child: Text("Tạo mới"),
                          onPressed: () {
                            contactController.listAvatarChoose.clear();
                            chatController.createChatroom(contactController.listContactChoose);
                            // Get.to(() => Dashboard());
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
                  press: () => {
                    print("contact with ${element.USER_NM_ENG}"),
                    if(!contactController.changeState(element, screenWidth, screenHeight)){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          content: const Text('Can'+ "'" +'t chat with myself!'),
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
    ContactScreenController contactController = Get.find();

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
                clientSocketController.getContactList(),
                contactController.listContactChoose.value = [],
                contactController.resetState(),
                contactController.listAvatarChoose.clear(),
                Get.back(),
              }),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (value) => contactController.contactNameSearch(value),
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
                  contactController.contactNameSearch("");
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
