import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar.dart';
import 'package:hello_world_flutter/common/widgets/chat_app_bar.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/text_field_search.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';
import 'package:hello_world_flutter/view/contact/add_contact_screen.dart';

class ChatScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    final contactController = Get.put(ContactScreenController());
    final chatController = Get.put(ChatScreenController());


    bool check = false;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kPrimaryColor,
            child: ChatAppBar(
              title: UserCircle(
                height: screenHeight * 0.06,
                width: screenWidth * 0.12,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    check = !check;
                    chatController.onPress(check);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Obx(
            () => Visibility(
                visible: chatController.state.value,
                child: TextFieldSearch(
                    textEditingController: chatController.searchController,
                    isPrefixIconVisible: true,
                    onChanged: chatController.chatNameSearch)),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: chatController.chatTempList.length,
                itemBuilder: (context, index) => CustomAvatar(
                  chat: chatController.chatTempList.value[index],
                  press: () => {
                    // Get.toNamed(messagescreen, arguments: {
                    //   "data": chatController.chatTempList.value[index]
                    // }),
                    chatController.getMessageByRoomId(chatController.chatTempList.value[index]),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CommonButton(
        icon: IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Get.to(() => AddContactScreen());
            contactController.listContactChoose.value = [];
            contactController.resetState();
          },
        ),
      ),
    );
  }
}
