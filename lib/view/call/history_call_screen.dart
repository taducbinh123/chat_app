import 'package:AMES/common/constant/ulti.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import '../../common/constant/path.dart';
import '../../controller/call_controller.dart';
import '../../controller/chat_screen_controller.dart';
import '../../controller/contact_screen_controller.dart';
import '../../controller/history_call_controller.dart';
import 'package:intl/intl.dart';

import '../../controller/message_screen_controller.dart';

class HistoryCallScreen extends StatelessWidget {
  HistoryCallScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hisController = Get.put(HistoryCallController());
    final ContactScreenController contactScreenController = Get.find();
    final ClientSocketController clientSocketController = Get.find();
    final chatController = Get.put(ChatScreenController());
    // final MessageScreenController messageController = Get.find();
    final CallController callController = Get.find();

    return Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          // leading: IconButton(
          //     icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack),
          //     onPressed: () => {
          //           Get.back(),
          //         }),
          title: Text(
            "Call History",
            style: TextStyle(
                color: AppTheme.nearlyBlack, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Obx(
              () => ListView.builder(
                  itemCount:
                      clientSocketController.messenger.callHistory.length,
                  itemBuilder: (context, index) {
                    var room;
                    for (int i = 0;
                        i < clientSocketController.messenger.listRoom.length;
                        i++) {
                      if (clientSocketController
                              .messenger.listRoom[i].roomUid ==
                          clientSocketController
                              .messenger.callHistory[index].ROOM_UID) {
                        room = clientSocketController.messenger.listRoom.value[i];
                      }
                    }
                    // print(clientSocketController.messenger.listRoom);
                    // print(clientSocketController.messenger.callHistory.length);

                    DateTime parseDate =
                        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(
                            clientSocketController
                                .messenger.callHistory[index].CREATED_DATE);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                    var outputDate = outputFormat.format(inputDate);
                    // print(
                    //     (clientSocketController.messenger.listRoom[1].roomUid));
                    // print((clientSocketController
                    //     .messenger.callHistory[1].ROOM_UID));
                    return InkWell(
                      onTap: (){
                        Get.defaultDialog(
                          title: "Select Action",
                          confirm: IconButton(
                              onPressed: () {
                                var roomId = clientSocketController.makeCall(room, false);
                                if (room.roomType ==
                                    "IN_CONTACT_ROOM") {
                                  // Get.toNamed(callscreen, arguments: [
                                  //   {'ROOM_ID': roomId, 'IS_CALL_AUDIO': false}
                                  // ]);
                                  Get.back();
                                  callController.roomId.value = roomId;
                                  callController.isCallAudio.value = false;
                                  callController.makeNew();
                                  callController.roomChat = room;
                                  Get.toNamed(callscreen);
                                } else {
                                  var data = { 'ROOM_ID': roomId, 'CALL_USER_UID': clientSocketController.messenger.currentUser.value.USER_UID};
                                  clientSocketController.joinMeeting(data, true, false);
                                }
                              },
                              icon: Icon(Icons.video_call, color: AppTheme.nearlyBlack)),
                          cancel: IconButton(
                              onPressed: () {
                                var roomId = clientSocketController.makeCall(room, true);
                                if(room.roomType == "IN_CONTACT_ROOM"){
                                  // Get.toNamed(callscreen, arguments: [{'ROOM_ID': roomId,'IS_CALL_AUDIO' : true}]);
                                  Get.back();
                                  callController.roomId.value = roomId;
                                  callController.isCallAudio.value = true;
                                  callController.makeNew();
                                  callController.roomChat = room;
                                  Get.toNamed(callscreen);
                                }else{
                                  var data = { 'ROOM_ID': roomId, 'CALL_USER_UID': clientSocketController.messenger.currentUser.value.USER_UID};
                                  clientSocketController.joinMeeting(data,true, true);
                                }
                              },
                              icon: Icon(Icons.call, color: AppTheme.nearlyBlack)),
                          middleText: "Call again ?",
                          backgroundColor: Colors.white,
                          titleStyle: TextStyle(color: Colors.red),
                          middleTextStyle: TextStyle(color: Colors.black),
                        );
                      },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              kDefaultPadding * 0.2, 0, kDefaultPadding * 0.2, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      // CircleAvatar(
                                      //   backgroundColor: AppTheme.white,
                                      //   radius: 24,
                                      //   backgroundImage: chat.roomType == 'IN_CHATROOM'
                                      //       ? AssetImage("assets/images/group_avatar_c.png")
                                      //       :
                                      FutureBuilder(
                                        future: contactScreenController
                                            .getImgUser((room?.userUidContact
                                            .toString())),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> text) {
                                          return new CachedNetworkImage(
                                            imageUrl:
                                            'https://backend.atwom.com.vn/public/resource/imageView/' +
                                                text.data.toString() +
                                                '.jpg',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                CircleAvatar(
                                                  backgroundImage: room?.roomType ==
                                                      'IN_CHATROOM'
                                                      ? AssetImage(
                                                      "assets/images/group_avatar_c.png")
                                                      : imageProvider,
                                                  backgroundColor: AppTheme.white,
                                                  radius: 30,
                                                ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget: (context, url, error) =>
                                                CircleAvatar(
                                                    backgroundColor:
                                                    AppTheme.white,
                                                    radius: 30,
                                                    backgroundImage: room
                                                        ?.roomType ==
                                                        'IN_CHATROOM'
                                                        ? AssetImage(
                                                        "assets/images/group_avatar_c.png")
                                                        : AssetImage(
                                                        "assets/images/user_avatar_c.png")),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  //

                                  // ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            room?.contactRoomName.toString() == "null"
                                                ? Text(room?.roomDefaultName.toString() ??
                                                "Default Value", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                                                : Text(room?.contactRoomName.toString() ??
                                                "Default Value", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                            Text(outputDate.toString()),


                                          ],
                                        ),
                                      )),
                                  StatusIcon(
                                      clientSocketController
                                          .messenger.callHistory[index].STATUS,
                                      clientSocketController
                                          .messenger.callHistory[index].ROLE),
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  }),
            ))
          ],
        ));
  }
}

Widget StatusIcon(var status, var role) {
  if (status == 2 && role == 1) {
    //caller left
    return Icon(Icons.call_received, color: AppTheme.nearlyBlack);
  }
  if (status == 2 && role == 0) {
    //callee left
    return Icon(Icons.call_made, color: AppTheme.nearlyBlack);
  }
  if (status == 3) {
    return Icon(Icons.call_received, color: Colors.red);
  }
  if (status == 4) {
    return Icon(Icons.call_missed, color: Colors.red);
  } else
    return Icon(Icons.call);
}
