import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar.dart';
import 'package:hello_world_flutter/common/widgets/chat_app_bar.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';
import 'package:hello_world_flutter/controller/chat_screen_controller.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';

import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:hello_world_flutter/view/contact/add_contact_screen.dart';

class ChatScreen extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    final contactController = Get.put(ContactScreenController());
    final chatController = Get.put(ChatScreenController());
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kPrimaryColor,
            child: ChatAppBar(
              title: UserCircle(),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {},
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
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: chatController.chats.length,
                itemBuilder: (context, index) => CustomAvatar(
                  chat: chatController.chats.value[index],
                  press: () => Get.toNamed(messagescreen,
                      arguments: {"data": chatController.chats.value[index]}),
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
            contactController.listNameChoose.value = "";
            contactController.listContactChoose.value = [];
            contactController.resetState();
          },
        ),
      ),
    );
  }
}
