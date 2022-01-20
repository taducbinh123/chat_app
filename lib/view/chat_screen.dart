import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';

import 'package:hello_world_flutter/model/chat_card.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kContentColorDarkTheme,
            child: TextAppBar(
              title: "Chats",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => CustomAvatar(
                chat: chatsData[index],
                press: () => Get.toNamed(contact),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
