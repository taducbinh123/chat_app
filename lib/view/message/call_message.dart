import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_theme.dart';
import '../../common/constant/ulti.dart';
import '../../controller/client_socket_controller.dart';
import '../../controller/room_chat_controller.dart';
import '../../model/message.dart';

class CallMessage extends StatelessWidget {
  CallMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;
  final ClientSocketController clientSocketController = Get.find();
  final ChatScreenController chatScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Container(
      // width: MediaQuery.of(context).size.width * 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.4,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        color:
            // widget.message.USER_UID == box.read("userUid")
            //     ? AppTheme.nearlyBlack :
            AppTheme.nearlyBlack,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Container(
          // width: MediaQuery.of(context).size.width * 0.55,
          child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // SizedBox(
          //   width: 6,
          // ),
          Container(
              width: MediaQuery.of(context).size.width * 0.1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: ElevatedButton(
                  onPressed: () async {},
                  child: chatScreenController.displayIconMessageCall(
                      message.ROLE_CALL, message.STATUS_CALL),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    backgroundColor: MaterialStateProperty.all(
                        AppTheme.dark_grey), // <-- Button color
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed))
                        return AppTheme.dark_grey; // <-- Splash color
                    }),
                  ),
                ),
              )),
          SizedBox(
            width: 6,
          ),
          Container(
              // width: MediaQuery.of(context).size.width * 0.4,
              // color: Colors.red,
              child:
                  // FittedBox(
                  //   fit: BoxFit.contain,
                  //   child: Center(
                  //       child:
                  Text(
                      "${chatScreenController.displayMessageCall(message.ROLE_CALL, message.STATUS_CALL)}",
                      style: TextStyle(fontSize: 12, color: Colors.white))
              // ),
              //   ),
              ),
          SizedBox(
            width: 6,
          ),
          // Spacer(),
        ],
      )
          // Spacer(),

          ),
    );
  }
}
