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

class CallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    final ClientSocketController clientSocketController = Get.find();
    final ContactScreenController contactScreenController = Get.find();
    MessageScreenController messageScreenController;
    final CallController callController = Get.find();

    return Scaffold(
        backgroundColor: AppTheme.nearlyBlack,
        body: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!Get.isRegistered<ClientSocketController>())
                Center(
                    child: Column(children: [
                  Text(
                    'Loading call',
                    style: TextStyle(color: AppTheme.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]))
              else
                Center(
                  child: Text(
                    callController.status.value == 0 // đợi
                        ? 'Ringing...'
                        : callController.status.value == 1
                        ? ''
                        : callController.status.value == 4
                            ? 'Coming call'
                            : callController.status.value == 2
                                ? 'Ended'
                                : callController.status.value == -2
                                    ? 'Busy'
                                    : callController.status.value == -3
                                        ? 'Callee is unavailable'
                                        : 'Rejected',
                    style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              callController.roomChat.roomType == "IN_CHATROOM"
                  ? Container(
                      height: screenWidth * 0.5,
                      width: screenHeight * 0.25,
                      child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/group_avatar_c.png")))
                  : FutureBuilder(
                      future: contactScreenController.getImgUser(
                          callController.roomChat.userUidContact.toString()),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return new CachedNetworkImage(
                          imageUrl:
                              'https://backend.atwom.com.vn/public/resource/imageView/' +
                                  text.data.toString() +
                                  '.jpg',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            backgroundColor: AppTheme.white,
                            radius: screenWidth * 0.25,
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: AppTheme.white,
                              radius: screenWidth * 0.25,
                              backgroundImage: AssetImage(
                                  "assets/images/user_avatar_c.png")),
                        );
                      },
                    ),
              callController.status.value == 0
                  ? Center(
                      child: Column(children: [
                      Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          roomSocket.emit("sendCancelCall", {
                            "USER_UID": clientSocketController
                                .messenger.currentUser.value.USER_UID,
                            "ROOM_ID": callController.roomId.value,
                            "ROOM_TYPE": callController.roomChat.roomType,
                            "ROOM_UID": callController.roomChat.roomUid,
                          });
                          Navigator.of(context).pop();
                        },
                        elevation: 2.0,
                        fillColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          size: 30.0,
                          color: AppTheme.white,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      )
                    ]))
                  : callController.status.value == -1 ||
                          callController.status.value == -2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              Column(
                                children: [
                                  Text(
                                    'Cancel',
                                    style: TextStyle(color: AppTheme.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 30.0,
                                      color: AppTheme.white,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Call again',
                                    style: TextStyle(color: AppTheme.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      messageScreenController = Get.find();
                                      var roomId =
                                          messageScreenController.makeCall(
                                              callController.roomChat,
                                              callController.isCallAudio.value);
                                      callController.makeNew();
                                      callController.roomId.value = roomId;
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.green,
                                    child: Icon(
                                      Icons.call,
                                      size: 30.0,
                                      color: AppTheme.white,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  )
                                ],
                              )
                            ]) :
              callController.status.value == 4 ?
              Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Cancel',
                              style: TextStyle(color: AppTheme.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                roomSocket.emit("sendRejectCall", {
                                  "ROOM_ID": callController.infoRoomCall['ROOM_ID'],
                                  "ROOM_TYPE": callController.infoRoomCall['ROOM_TYPE'],
                                  "USER_UID":
                                  clientSocketController.messenger.currentUser.value.USER_UID,
                                  "ROOM_UID": callController.infoRoomCall['ROOM_UID'],
                                  "CALL_USER_UID": callController.infoRoomCall['USER_UID']
                                });
                                clientSocketController.visibleIncomingCallDialog.value = false;
                                Navigator.of(context).pop();
                              },
                              elevation: 2.0,
                              fillColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 30.0,
                                color: AppTheme.white,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Accept',
                              style: TextStyle(color: AppTheme.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (callController.infoRoomCall['TYPE_CALL'] != null) {
                                  roomSocket.emit("sendJoinCall", {
                                    "ROOM_ID": callController.infoRoomCall['ROOM_ID'],
                                    "ROOM_TYPE": callController.infoRoomCall['ROOM_TYPE'],
                                    "USER_UID":
                                    clientSocketController.messenger.currentUser.value.USER_UID,
                                    "ROOM_UID": callController.infoRoomCall['ROOM_UID'],
                                    "CALL_USER_UID": callController.infoRoomCall['USER_UID'],
                                    "TYPE_CALL": "AUDIO"
                                  });
                                  callController.infoRoomCall['CALL_USER_UID'] = callController.infoRoomCall['USER_UID'];
                                  clientSocketController.visibleIncomingCallDialog.value = false;
                                  callController.roomId.value = callController.infoRoomCall['ROOM_ID'];
                                  callController.isCallAudio.value = true;
                                  callController.isPickedUp();
                                  clientSocketController.joinMeeting(callController.infoRoomCall, false, true);
                                } else {
                                  roomSocket.emit("sendJoinCall", {
                                    "ROOM_ID": callController.infoRoomCall['ROOM_ID'],
                                    "ROOM_TYPE": callController.infoRoomCall['ROOM_TYPE'],
                                    "USER_UID":
                                    clientSocketController.messenger.currentUser.value.USER_UID,
                                    "ROOM_UID": callController.infoRoomCall['ROOM_UID'],
                                    "CALL_USER_UID": callController.infoRoomCall['USER_UID']
                                  });
                                  callController.infoRoomCall['CALL_USER_UID'] = callController.infoRoomCall['USER_UID'];
                                  clientSocketController.visibleIncomingCallDialog.value = false;
                                  callController.isPickedUp();
                                  clientSocketController.joinMeeting(callController.infoRoomCall, false, false);
                                }
                                callController.roomChat = clientSocketController.messenger.listRoom.value
                                    .firstWhere((element) =>
                                element.roomUid == callController.infoRoomCall['ROOM_UID']);
                                clientSocketController.messenger.callRoom.value.ROOM_ID =
                                callController.infoRoomCall['ROOM_ID'];
                                clientSocketController.messenger.callRoom.value.ROOM_UID =
                                callController.infoRoomCall['ROOM_UID'];
                                clientSocketController.messenger.callRoom.value.CALL_USER_UID =
                                callController.infoRoomCall['CALL_USER_UID'];
                                clientSocketController.messenger.callRoom.value.ROOM_TYPE =
                                callController.infoRoomCall['ROOM_TYPE'];
                                clientSocketController.messenger.callRoom.value.TYPE_CALL =
                                callController.infoRoomCall['TYPE_CALL'] != null ? "AUDIO" : "CALL";
                              },
                              elevation: 2.0,
                              fillColor: Colors.green,
                              child: Icon(
                                Icons.call,
                                size: 30.0,
                                color: AppTheme.white,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            )
                          ],
                        )
                      ])
              )
                      : Container()
            ],
          ),
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
