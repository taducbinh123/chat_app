import 'dart:io';

import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/view/message/call_message.dart';
import 'package:AMES/view/message/message.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/file_controller.dart';
import 'package:AMES/controller/message_screen_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletons/skeletons.dart';

class MessagesScreen extends GetView<MessageScreenController> {
  final MessageScreenController messageController =
      Get.put(MessageScreenController());
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    final fileController = Get.put(FileController());
    final ClientSocketController clientSocketController = Get.find();
    final ChatScreenController chatScreenController = Get.find();

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          buildAppBar(screenWidth, screenHeight, chatScreenController, context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Obx(
                () => Skeleton(
                    isLoading: chatScreenController.loadMessageInRoom.value,
                    shimmerGradient: LinearGradient(
                      colors: [
                        Color(0xffc4e1ef),
                        Color(0xffa3d3e8),
                        Color(0xffa3d3e8),
                        Color(0xffc4e1ef),
                      ],
                      stops: [
                        0.0,
                        0.3,
                        1,
                        1,
                      ],
                      begin: Alignment(-1, 0),
                      end: Alignment(1, 0),
                    ),
                    skeleton: _skeletonView2(),
                    child: Obx(
                      () => ListView.builder(
                          controller: messageController.controller,
                          itemCount: clientSocketController
                              .messenger.chatList.value.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            print(clientSocketController
                                .messenger.chatList.value[index]);
                            if (clientSocketController
                                    .messenger.chatList.value.length ==
                                index)
                              return Center(child: CircularProgressIndicator());
                            return Message(
                                message: clientSocketController
                                    .messenger.chatList.value[index]);
                          }),
                    )),
              ),
            ),
          ),
          // CallMessage(),
          // Obx(() => (Visibility(
          //       visible: messageController.check.value,
          //       child: Padding(
          //         padding: const EdgeInsets.only(
          //             left: 50, right: 20, top: 5, bottom: 5),
          //         child: OutlinedButton(
          //           onPressed: () {
          //             messageController.joinMeeting();
          //
          //             // Navigator.push(
          //             //     context,
          //             //     MaterialPageRoute(
          //             //         builder: (_) => MeetingWebView(meetingUrl: "url")));
          //           },
          //           child: SizedBox(
          //             height: 60,
          //             child: Row(
          //               children: [
          //                 const Icon(Icons.video_call),
          //                 const VerticalDivider(),
          //                 Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Flexible(
          //                         child: AutoSizeText(
          //                             "${clientSocketController.messenger.selectedRoom?.roomDefaultName}'s meeting",
          //                             maxLines: 2,
          //                             overflow: TextOverflow.ellipsis,
          //                             style: Theme.of(context)
          //                                 .textTheme
          //                                 .subtitle2)),
          //                     const SizedBox(height: 5),
          //                     const Text('Join video meeting')
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ))),
          Container(
              padding: EdgeInsets.fromLTRB(0, kDefaultPadding / 2, 0, 36),
              decoration: BoxDecoration(
                color: AppTheme.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Obx(
                () => SafeArea(
                    top: false,
                    left: false,
                    bottom: false,
                    right: false,
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: 46,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                right: messageController.isTexting.value
                                    ? screenWidth
                                    : 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  width: screenWidth,
                                  height: 46,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(8, 0, 0, 0),
                                            child: IconButton(
                                              // padding: EdgeInsets.all(4.0),
                                              onPressed: chatScreenController
                                                          .loadMessageInRoom
                                                          .value ||
                                                      chatScreenController
                                                          .inProcess.value
                                                  ? () => () {}
                                                  : () async {
                                                      final ImagePicker
                                                          _picker =
                                                          ImagePicker();
                                                      var result = await _picker
                                                          .pickMultiImage();
                                                      if (result == null)
                                                        return;
                                                      fileController.listImages
                                                          .value = result;
                                                      fileController
                                                          .uploadImage();
                                                    },
                                              icon: Icon(
                                                Icons.photo_library,
                                                color: AppTheme.nearlyBlack,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: IconButton(
                                              // padding: EdgeInsets.all(4.0),
                                              onPressed: chatScreenController
                                                          .loadMessageInRoom
                                                          .value ||
                                                      chatScreenController
                                                          .inProcess.value
                                                  ? () => () {}
                                                  : () async {
                                                      final result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                                  allowMultiple:
                                                                      true,
                                                                  withData:
                                                                      true,
                                                                  allowCompression:
                                                                      true);
                                                      if (result == null)
                                                        return;
                                                      fileController.listFiles
                                                          .value = result.files;
                                                      fileController
                                                          .uploadFile();
                                                    },
                                              icon: Icon(
                                                Icons.attach_file,
                                                color: AppTheme.nearlyBlack,
                                              ),
                                            ),
                                          ),
                                          HoldTimeoutDetector(
                                            holdTimeout:
                                                Duration(milliseconds: 500),
                                            onTimerInitiated: () {},
                                            onTimeout: () {
                                              print("on time out");
                                            },
                                            child: Container(
                                                height: 40,
                                                margin: EdgeInsets.fromLTRB(
                                                    8, 0, 15, 0),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: messageController
                                                                  .isRecording
                                                                  .value
                                                              ? Colors.pink
                                                                  .withOpacity(
                                                                      0.2)
                                                              : AppTheme
                                                                  .nearlyBlack
                                                                  .withOpacity(
                                                                      0.0),
                                                          spreadRadius: 4)
                                                    ],
                                                    color: messageController
                                                            .isRecording.value
                                                        ? Colors.red
                                                        : AppTheme.nearlyBlack,
                                                    shape: BoxShape.circle),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    print('onLongPress');
                                                    if (messageController
                                                            .isRecording
                                                            .value ==
                                                        true) {
                                                      messageController
                                                          .stopRecord();
                                                      showAlertDialog(context);
                                                    } else {
                                                      messageController
                                                          .startRecord();
                                                    }
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.mic,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )),
                                                )),
                                          ),
                                        ],
                                      ),
                                      AnimatedOpacity(
                                        opacity:
                                            messageController.isTexting.value
                                                ? 0
                                                : 1,
                                        duration: Duration(milliseconds: 500),
                                        child: IconButton(
                                          // padding: EdgeInsets.all(4.0),
                                          onPressed: () {
                                            if (messageController
                                                .isRecording.value) {
                                              return;
                                            }
                                            messageController.isTexting.value =
                                                true;
                                          },
                                          icon: Icon(
                                            Icons.chevron_left,
                                            color: AppTheme.nearlyBlack,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                duration: Duration(milliseconds: 200),
                              ),
                              AnimatedPositioned(
                                  left: messageController.isTexting.value
                                      ? 0
                                      : screenWidth,
                                  top: 0,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      width: screenWidth,
                                      height: 46,
                                      child: Row(
                                        children: [
                                          AnimatedOpacity(
                                            opacity: messageController
                                                    .isTexting.value
                                                ? 1
                                                : 0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: IconButton(
                                              // padding: EdgeInsets.all(4.0),
                                              onPressed: () {
                                                if (messageController
                                                    .isRecording.value) {
                                                  return;
                                                }
                                                messageController
                                                    .isTexting.value = false;
                                              },
                                              icon: Icon(
                                                Icons.chevron_right,
                                                color: AppTheme.nearlyBlack,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    kDefaultPadding * 0.75,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Row(
                                                children: [
                                                  Obx(
                                                    () => Expanded(
                                                        child: Focus(
                                                      child: TextField(

                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              200),
                                                        ],
                                                        // maxLength: 200,
                                                        // maxLengthEnforced: true,
                                                        controller:
                                                            messageController
                                                                .myController
                                                                .value,
                                                        enabled: messageController
                                                                    .myController
                                                                    .value ==
                                                                null
                                                            ? false
                                                            : true,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          hintText:
                                                              "Type message",
                                                          hintStyle: TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .dark_grey
                                                                  .withOpacity(
                                                                      0.6)),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                      onFocusChange:
                                                          (hasFocus) {
                                                        if (hasFocus) {
                                                          messageController
                                                              .emojiShowing
                                                              .value = false;
                                                        }
                                                        // chatScreenController.typingConfirm(hasFocus);
                                                        messageController
                                                            .checkTyping(
                                                                hasFocus);
                                                      },
                                                    )),
                                                  ),
                                                  Obx(
                                                    () => IconButton(
                                                      // padding: EdgeInsets.all(4.0),
                                                      onPressed: chatScreenController
                                                                  .loadMessageInRoom
                                                                  .value ||
                                                              chatScreenController
                                                                  .inProcess
                                                                  .value
                                                          ? () => () {}
                                                          : () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      new FocusNode());
                                                              messageController
                                                                  .changeStateEmoji();
                                                            },
                                                      icon: Icon(
                                                        Icons.emoji_emotions,
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Obx(() => !chatScreenController
                                                  .isTyping.value
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              8, 0, 8, 0),
                                                      child: IconButton(
                                                        // padding: EdgeInsets.all(4.0),
                                                        onPressed: chatScreenController
                                                                    .loadMessageInRoom
                                                                    .value ||
                                                                chatScreenController
                                                                    .inProcess
                                                                    .value
                                                            ? () => () {}
                                                            : () async {
                                                                final ImagePicker
                                                                    _picker =
                                                                    ImagePicker();
                                                                var result =
                                                                    await _picker
                                                                        .pickMultiImage();
                                                                if (result ==
                                                                    null)
                                                                  return;
                                                                fileController
                                                                        .listImages
                                                                        .value =
                                                                    result;
                                                                fileController
                                                                    .uploadImage();
                                                              },
                                                        icon: Icon(
                                                          Icons.photo_library,
                                                          color: AppTheme
                                                              .nearlyBlack,
                                                        ),
                                                      ),
                                                    ),
                                                    HoldTimeoutDetector(
                                                      holdTimeout: Duration(
                                                          milliseconds: 500),
                                                      onTimerInitiated: () {},
                                                      onTimeout: () {
                                                        print("on time out");
                                                      },
                                                      child: Container(
                                                          height: 40,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  8, 0, 15, 0),
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: messageController
                                                                            .isRecording
                                                                            .value
                                                                        ? Colors
                                                                            .pink
                                                                            .withOpacity(
                                                                                0.2)
                                                                        : AppTheme
                                                                            .nearlyBlack
                                                                            .withOpacity(
                                                                                0.0),
                                                                    spreadRadius:
                                                                        4)
                                                              ],
                                                              color: messageController
                                                                      .isRecording
                                                                      .value
                                                                  ? Colors.pink
                                                                  : AppTheme
                                                                      .nearlyBlack,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              print(
                                                                  'onLongPress');
                                                              if (messageController
                                                                      .isRecording
                                                                      .value ==
                                                                  true) {
                                                                messageController
                                                                    .stopRecord();
                                                                showAlertDialog(
                                                                    context);
                                                              } else {
                                                                messageController
                                                                    .startRecord();
                                                              }
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Icon(
                                                                  Icons.mic,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                )),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.send,
                                                      color:
                                                          AppTheme.nearlyBlack,
                                                      size: 25,
                                                    ),
                                                    onPressed: chatScreenController
                                                                .loadMessageInRoom
                                                                .value ||
                                                            chatScreenController
                                                                .inProcess.value
                                                        ? () => () {}
                                                        : () {
                                                            messageController
                                                                .sendMessage(
                                                                    messageController
                                                                        .myController
                                                                        .value
                                                                        .text);
                                                          },
                                                  )))
                                        ],
                                      )),
                                  duration: Duration(milliseconds: 300))
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: !messageController.emojiShowing.value,
                          child: SizedBox(
                            height: 240,
                            child: EmojiPicker(
                                onEmojiSelected:
                                    (Category category, Emoji emoji) {
                                  messageController.onEmojiSelected(emoji);
                                },
                                onBackspacePressed:
                                    messageController.onBackspacePressed,
                                config: Config(
                                    columns: 7,
                                    // Issue: https://github.com/flutter/flutter/issues/28894
                                    emojiSizeMax:
                                        28 * (Platform.isIOS ? 1.30 : 1.0),
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    initCategory: Category.RECENT,
                                    bgColor: AppTheme.white,
                                    indicatorColor: AppTheme.nearlyBlack,
                                    iconColor:
                                        AppTheme.dark_grey.withOpacity(0.4),
                                    iconColorSelected: AppTheme.nearlyBlack,
                                    progressIndicatorColor:
                                        AppTheme.nearlyBlack,
                                    backspaceColor: AppTheme.nearlyBlack,
                                    skinToneDialogBgColor: Colors.white,
                                    skinToneIndicatorColor: Colors.white,
                                    enableSkinTones: true,
                                    showRecentsTab: true,
                                    recentsLimit: 28,
                                    noRecents: Text(
                                      'No Recents',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                    ),
                                    tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL)),
                          ),
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Widget _skeletonView() => SkeletonListView(
        item: SkeletonListTile(
          verticalSpacing: 12,
          leadingStyle: SkeletonAvatarStyle(
              width: 60, height: 60, shape: BoxShape.circle),
          titleStyle: SkeletonLineStyle(
              height: 16,
              minLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          subtitleStyle: SkeletonLineStyle(
              height: 12,
              maxLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          hasSubtitle: true,
        ),
      );

  Widget _skeletonView2() => SkeletonListView(
        item: SkeletonListTile(
          verticalSpacing: 0,
          leadingStyle: SkeletonAvatarStyle(
              width: 35, height: 35, shape: BoxShape.circle),
          titleStyle: SkeletonLineStyle(
              padding: EdgeInsets.only(top: 0),
              height: 30,
              minLength: 100,
              maxLength: 150,
              randomLength: true,
              borderRadius: BorderRadius.circular(15)),
          subtitleStyle: SkeletonLineStyle(
              height: 0,
              maxLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          hasSubtitle: true,
        ),
      );

  StatefulWidget buildAppBar(
      screenWidth, screenHeight, chatScreenController, context) {
    // final NavBarController navBarController = Get.find();
    RoomChatController roomChatController = Get.put(RoomChatController());
    final ClientSocketController clientSocketController = Get.find();
    final ContactScreenController contactScreenController = Get.find();
    final CallController callController = Get.find();

    return AppBar(
      elevation: 1,
      backgroundColor: AppTheme.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: AppTheme.nearlyBlack,
        onPressed: () {
          Get.back();
          clientSocketController.messenger.selectedRoom = null;
          clientSocketController.messenger.roomNameSelected.value = "";
        },
      ),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Obx(() => Skeleton(
                shimmerGradient: LinearGradient(
                  colors: [
                    Color(0xffc4e1ef),
                    Color(0xffa3d3e8),
                    Color(0xffa3d3e8),
                    Color(0xffc4e1ef),
                  ],
                  stops: [
                    0.0,
                    0.3,
                    1,
                    1,
                  ],
                  begin: Alignment(-1, 0),
                  end: Alignment(1, 0),
                ),
                isLoading: chatScreenController.inProcess.value,
                skeleton: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        shape: BoxShape.circle, width: 40, height: 40)),
                child: clientSocketController.messenger.selectedRoom == null
                    ? Text("")
                    : InkWell(
                        child: clientSocketController
                                    .messenger.selectedRoom!.roomType ==
                                "IN_CHATROOM"
                            ? Container(
                                height: screenWidth * 0.1,
                                width: screenHeight * 0.05,
                                child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/group_avatar_c.png")))
                            : FutureBuilder(
                                future: contactScreenController.getImgUser(
                                    clientSocketController.messenger
                                            .selectedRoom?.userUidContact
                                            .toString() ??
                                        ""),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> text) {
                                  return new CachedNetworkImage(
                                    imageUrl:
                                        'https://backend.atwom.com.vn/public/resource/imageView/' +
                                            text.data.toString() +
                                            '.jpg',
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                      backgroundColor: AppTheme.white,
                                      radius: 20,
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                            backgroundColor: AppTheme.white,
                                            radius: 20,
                                            backgroundImage: AssetImage(
                                                "assets/images/user_avatar_c.png")),
                                  );
                                },
                              ),
                        onTap: () {
                          Get.toNamed(settingScreen, arguments: {
                            "room":
                                clientSocketController.messenger.selectedRoom
                          });
                        },
                      ))),
            SizedBox(width: kDefaultPadding * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(() => Skeleton(
                            shimmerGradient: LinearGradient(
                              colors: [
                                Color(0xffc4e1ef),
                                Color(0xffa3d3e8),
                                Color(0xffa3d3e8),
                                Color(0xffc4e1ef),
                              ],
                              stops: [
                                0.0,
                                0.3,
                                1,
                                1,
                              ],
                              begin: Alignment(-1, 0),
                              end: Alignment(1, 0),
                            ),
                            isLoading: chatScreenController.inProcess.value,
                            skeleton: SkeletonLine(),
                            child: InkWell(
                              child: Text(
                                clientSocketController
                                            .messenger.selectedRoom?.roomType !=
                                        "IN_CHATROOM"
                                    ? clientSocketController.messenger
                                            .selectedRoom?.contactRoomName ??
                                        ""
                                    : clientSocketController
                                        .messenger.roomNameSelected.value
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 16, color: AppTheme.nearlyBlack),
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Get.toNamed(settingScreen, arguments: {
                                  "room": clientSocketController
                                      .messenger.selectedRoom
                                });
                              },
                            )))))
              ],
            )
          ],
        ),
      ),
      actions: [
        // IconButton(
        //     onPressed: () {
        //       // messageController.check.value = !messageController.check.value;
        //       var roomId = messageController.makeCall(true);
        //       if (clientSocketController.messenger.selectedRoom?.roomType ==
        //           "IN_CONTACT_ROOM") {
        //         Get.toNamed(callscreen, arguments: [
        //           {'ROOM_ID': roomId, 'IS_CALL_AUDIO': true}
        //         ]);
        //       } else {
        //         clientSocketController.joinMeeting(roomId, true, true);
        //       }
        //     },
        //     icon: const Icon(Icons.call, color: AppTheme.nearlyBlack)),
        IconButton(
            onPressed: () {
              // messageController.check.value = !messageController.check.value;
              var roomId = messageController.makeCall(
                  clientSocketController.messenger.selectedRoom, false);
              if (clientSocketController.messenger.selectedRoom?.roomType ==
                  "IN_CONTACT_ROOM") {
                // Get.toNamed(callscreen, arguments: [
                //   {'ROOM_ID': roomId, 'IS_CALL_AUDIO': false}
                // ]);
                callController.roomId.value = roomId;
                callController.isCallAudio.value = false;
                callController.makeNew();
                callController.roomChat =
                    clientSocketController.messenger.selectedRoom;
                Get.toNamed(callscreen);
              } else {
                var data = {
                  'ROOM_ID': roomId,
                  'CALL_USER_UID': clientSocketController
                      .messenger.currentUser.value.USER_UID
                };
                clientSocketController.joinMeeting(data, true, false);
              }
            },
            icon: const Icon(Icons.video_call, color: AppTheme.nearlyBlack)),
        IconButton(
            onPressed: () {
              // messageController.check.value = !messageController.check.value;
              var roomId = messageController.makeCall(
                  clientSocketController.messenger.selectedRoom, true);
              if (clientSocketController.messenger.selectedRoom?.roomType ==
                  "IN_CONTACT_ROOM") {
                // Get.toNamed(callscreen, arguments: [{'ROOM_ID': roomId,'IS_CALL_AUDIO' : true}]);
                callController.roomId.value = roomId;
                callController.isCallAudio.value = true;
                callController.makeNew();
                callController.roomChat =
                    clientSocketController.messenger.selectedRoom;
                Get.toNamed(callscreen);
              } else {
                var data = {
                  'ROOM_ID': roomId,
                  'CALL_USER_UID': clientSocketController
                      .messenger.currentUser.value.USER_UID
                };
                clientSocketController.joinMeeting(data, true, true);
              }
            },
            icon: const Icon(Icons.call, color: AppTheme.nearlyBlack)),

        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
// set up the buttons
    final MessageScreenController messageController = Get.find();
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget launchButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        messageController.sendAudioRecord();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text("Confirm"),
        content: Text("Would you like send record?"),
        actions: [
          cancelButton,
          launchButton,
        ]);

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
