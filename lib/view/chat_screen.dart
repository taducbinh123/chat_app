import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar.dart';
import 'package:hello_world_flutter/common/widgets/chat_app_bar.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';

import 'package:hello_world_flutter/model/chat_card.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => CustomAvatar(
                chat: chatsData[index],
                press: () => Get.toNamed(messagescreen,
                    arguments: {"data": chatsData[index]}),
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
         onPressed:() {

         },
        ),
      ),
    );
  }
}
