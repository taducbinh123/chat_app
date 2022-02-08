import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/common/widgets/user_circle.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => {
                    Get.back(),
                  }),
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: UserCircle(
                  width: screenWidth * 0.24,
                  height: screenHeight * 0.12,
                ),
              ),
            ],
          ),
        ));
  }
}
