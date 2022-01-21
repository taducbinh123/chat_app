import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';


class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kContentColorDarkTheme,
            child: TextAppBar(
              title: "Call",
            ),
          ),
        ],
      ),
      floatingActionButton: CommonButton(
          icon: IconButton(
        icon: Icon(
          Icons.dialpad,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () {},
      )),
    );
  }
}
