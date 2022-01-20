import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar.dart';
import 'package:hello_world_flutter/common/widgets/bottom_nav_bar.dart';
import 'package:hello_world_flutter/controller/nav_bar_controller.dart';

import 'package:hello_world_flutter/model/chat_card.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
            child: Container(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => CustomAvatar(
                chat: chatsData[index],
                press: () => {
                  Get.toNamed(contact),
                  print("hviuhse")
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SuperFaBottomNavigationBar(),
    );
  }
}
