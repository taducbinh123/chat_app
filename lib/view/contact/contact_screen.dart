import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';

import 'package:hello_world_flutter/common/widgets/text_appbar.dart';

import 'add_contact_screen.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kContentColorDarkTheme,
            child: TextAppBar(
              title: "Contact",
            ),
          ),
        ],
      ),
      floatingActionButton: CommonButton(
          icon: IconButton(
        icon: Icon(
          Icons.group_add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () {
          Get.to(() => AddContactScreen());
        },
      )),
    );
  }
}
