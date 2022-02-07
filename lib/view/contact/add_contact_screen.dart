import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact_add.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:hello_world_flutter/view/chat_screen.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AddContactScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find();
    ChatScreenController chatController = Get.find();

    return Scaffold(
      appBar: searchAppBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Obx(() => Visibility(
                visible: contactController.listNameChoose.value != "",
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 8.0, 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => AutoSizeText(
                              contactController.listNameChoose.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            )),
                      ),
                      ElevatedButton(
                          child: Text("Tạo mới"),
                          onPressed: () {
                            chatController.addChat(Chat(
                                name: contactController.listNameChoose.value,
                                lastMessage: "",
                                time: DateTime.now().toString(),
                                isActive: true,
                                image: ""));

                            // chatController.updateChats();
                            Get.back();
                            // Get.toNamed(chatscreen);
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
              () => GroupedListView<Chat, String>(
                elements: contactController.contactList.value,
                groupBy: (element) => element.name[0].toString().toUpperCase(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1.name.toString().compareTo(item2.name.toString()),
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
                  chat: element,
                  press: () => {
                    print("contact with ${element.name}"),
                    contactController.changeState(index, element),
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
                Get.back(),
                contactController.contactList.value = chatsData,
                contactController.listNameChoose.value = "",
                contactController.listContactChoose.value = [],
                contactController.resetState(),
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
                  contactController.contactList.value = chatsData;
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
