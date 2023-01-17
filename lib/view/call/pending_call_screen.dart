import 'dart:ffi';

import 'package:AMES/common/app_theme.dart';
import 'package:AMES/features/authentication/authentication_service.dart';
import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/controller/message_screen_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    return Scaffold(
        backgroundColor: AppTheme.nearlyBlack,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: Column(children: [
              Text(
                'Loading call...',
                style: TextStyle(color: AppTheme.white, fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ]))
          ],
        )
        // floatingActionButton: CommonButton(
        //     icon: IconButton(
        //   icon: Icon(
        //     Icons.dialpad,
        //     color: Colors.white,
        //     size: 25,
        //   ),
        //   onPressed: () {},
        // )),
        );
  }
}
