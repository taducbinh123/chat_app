import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/socket.dart';
import 'package:AMES/features/authentication/authentication.dart';
import 'package:AMES/view/message/call_message.dart';
import 'package:AMES/view/message/text_message.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/model/ChatMessage.dart';
import 'package:AMES/model/message.dart';
import 'package:AMES/view/message/attachment_message.dart';
import 'package:AMES/view/message/center_text_message.dart';
import 'package:holding_gesture/holding_gesture.dart';


import 'audio_message.dart';

class Message extends StatelessWidget {
  Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final message;
  final ClientSocketController clientSocketController = Get.find();
  final ContactScreenController contactScreenController = Get.find();
  final AuthenticationController authenticationController = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModel message) {
      switch (message.MSG_TYPE_CODE) {
        case "TEXT":
          return TextMessage(message: message);
        case "CREATE_ROOM":
          return CenterTextMessage(message: message);
        case "FILE":
          if (message.FILE_EXTN!.contains("audio")) {
            return AudioMessage(message: message);
          } else {
            return AttachMessage(message: message);
          }
        case "LINK":
          return AttachMessage(message: message);
        case "AUDIO":
          return AudioMessage(message: message);
        case "CALL":
          return CallMessage(message: message);
        default:
          return SizedBox();
      }
    }

    // test
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding / 5),
      child: Row(
        mainAxisAlignment: message.USER_UID == box.read("userUid") ||
                message.MSG_TYPE_CODE == 'CALL'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // !message.isSender - phải check xem có phải do client gửi tin nhắn ko
          Visibility(
            child: FutureBuilder(
              future: contactScreenController.getImgUser(clientSocketController
                      .messenger.selectedRoom?.userUidContact
                      .toString() ??
                  ""),
              builder: (BuildContext context, AsyncSnapshot<String> text) {
                return new CachedNetworkImage(
                  imageUrl:
                      'https://backend.atwom.com.vn/public/resource/imageView/' +
                          text.data.toString() +
                          '.jpg',
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: clientSocketController
                                .messenger.selectedRoom?.roomType ==
                            'IN_CHATROOM'
                        ? AssetImage("assets/images/group_avatar_c.png")
                        : imageProvider,
                    backgroundColor: AppTheme.white,
                    radius: 16,
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: AppTheme.white,
                      radius: 16,
                      backgroundImage: clientSocketController
                                  .messenger.selectedRoom?.roomType ==
                              'IN_CHATROOM'
                          ? AssetImage("assets/images/group_avatar_c.png")
                          : AssetImage("assets/images/user_avatar_c.png")),
                );
              },
            ),
            visible: clientSocketController.messenger.selectedRoom?.roomType ==
                    "IN_CHATROOM"
                ? message.USER_UID != box.read("userUid") &&
                    message.MSG_TYPE_CODE != 'CALL' &&
                    (message.PRE_USER_UID != message.USER_UID)
                : message.USER_UID != box.read("userUid") &&
                    (DateTime.parse(message.SEND_DATE.toString())
                                .millisecondsSinceEpoch -
                            (message.PRE_MSG_SEND_DATE.toString() == '0'
                                ? 0
                                : DateTime.parse(
                                        message.PRE_MSG_SEND_DATE.toString())
                                    .millisecondsSinceEpoch) >
                        2 * 60 * 1000 || message.PRE_USER_UID != message.USER_UID) &&
                    message.MSG_TYPE_CODE != 'CALL',
          ),
          Visibility(
            child: SizedBox(width: 32),
            visible: clientSocketController.messenger.selectedRoom?.roomType ==
                    "IN_CHATROOM"
                ? message.USER_UID == box.read("userUid") ||
                    (message.PRE_USER_UID == message.USER_UID) ||
                    message.MSG_TYPE_CODE == 'CALL'
                : message.USER_UID == box.read("userUid") ||
                    (DateTime.parse(message.SEND_DATE.toString())
                                    .millisecondsSinceEpoch -
                                (message.PRE_MSG_SEND_DATE.toString() == '0'
                                    ? 0
                                    : DateTime.parse(message.PRE_MSG_SEND_DATE
                                            .toString())
                                        .millisecondsSinceEpoch) <=
                            2 * 60 * 1000 &&
                        message.PRE_USER_UID == message.USER_UID) ||
                    message.MSG_TYPE_CODE == 'CALL',
          ),
          Visibility(
            child: SizedBox(width: kDefaultPadding / 2),
            visible: message.USER_UID != box.read("userUid") &&
                message.MSG_TYPE_CODE != 'CALL',
          ),
          Container(
            child: Column(
              crossAxisAlignment: message.USER_UID == box.read("userUid") ||
                      message.MSG_TYPE_CODE == 'CALL'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    message.PRE_USER_UID != message.USER_UID &&
                            message.USER_UID != box.read("userUid") &&
                            clientSocketController
                                    .messenger.selectedRoom?.roomType ==
                                "IN_CHATROOM" &&
                            message.MSG_TYPE_CODE != 'CALL'
                        ? Obx(() => Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 5),
                                  child: AutoSizeText(
                                    clientSocketController
                                        .getEmployeeByUserUid(message.USER_UID)
                                        .USER_NM_KOR.toString() ?? clientSocketController
                                        .getEmployeeByUserUid(message.USER_UID)
                                        .USER_NM_ENG.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ))
                        : Container(),
                    (DateTime.parse(message.SEND_DATE.toString())
                                    .millisecondsSinceEpoch -
                                (message.PRE_MSG_SEND_DATE.toString() == '0'
                                    ? 0
                                    : DateTime.parse(message.PRE_MSG_SEND_DATE
                                            .toString())
                                        .millisecondsSinceEpoch) >
                            2 * 60 * 1000)
                        ? Obx(() => Container(
                              padding: EdgeInsets.only(top: 20, bottom: 5),
                              child: AutoSizeText(
                                authenticationController
                                    .displayTime(message.SEND_DATE.toString()),
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ))
                        : Container(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    message!.USER_UID == box.read("userUid") ||
                            message.MSG_TYPE_CODE == 'CALL'
                        ? Container(
                            padding: EdgeInsets.fromLTRB(0, 15, 5, 0),
                            child: message!.STATUS == 1
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: AppTheme.dark_grey.withOpacity(0.2),
                                  )
                                : Icon(
                                    Icons.file_upload,
                                    size: 16,
                                    color: AppTheme.dark_grey.withOpacity(0.2),
                                  )
                            // AutoSizeText(
                            //   "Sending...",
                            //   style: TextStyle(
                            //       fontSize: 10,
                            //       fontStyle: FontStyle.italic,
                            //       color: AppTheme.dark_grey.withOpacity(0.4)
                            //   ),
                            // ),

                            )
                        : Container(),
                    HoldTimeoutDetector(
                      holdTimeout: Duration(milliseconds: 500),
                      onTimerInitiated: () {},
                      onTimeout: () {
                        if (message.MSG_TYPE_CODE == "TEXT") {
                          Clipboard.setData(new ClipboardData(
                                  text: message.MSG_CONT.toString()))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar('Message copied to clipboard'));
                          });
                        }
                        if (message.MSG_TYPE_CODE == "FILE" &&
                            message.FILE_EXTN!.contains("image")) {
                          showAlertDialog(context, message);
                        }
                      },
                      child: messageContaint(message),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
        // if (message.MSG_TYPE_CODE == "TEXT")
        //   MessageStatusDot(status: MessageStatus.viewed)
      ),
    );
  }

  SnackBar snackBar(String content) {
    return SnackBar(
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Code to execute.
        },
      ),
      content: Text(content),
      duration: const Duration(milliseconds: 1500),
      // width: 280.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  showAlertDialog(BuildContext context, MessageModel message) {
// set up the buttons

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget launchButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        downloadFile(
            chatApiHost + "/api/chat/getFile/" + message.FILE_PATH.toString(),
            message.FILE_ORI_NM.toString());
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Download"),
      content: Text("Would you like download image?"),
      actions: [
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
