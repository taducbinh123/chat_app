import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/features/authentication/authentication.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/model/room.dart';

class CustomAvatar extends StatelessWidget {
  CustomAvatar({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Room chat;
  final VoidCallback press;

  final ClientSocketController clientSocketController = Get.find();
  final ContactScreenController contactScreenController = Get.find();
  final ChatScreenController chatScreenController = Get.find();
  final AuthenticationController authenticationController = Get.find();

  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    // TODO: implement build
    return InkWell(
      onTap: press,
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
                          .getImgUser(chat.userUidContact.toString()),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return new CachedNetworkImage(
                          imageUrl:
                              'https://backend.atwom.com.vn/public/resource/imageView/' +
                                  text.data.toString() +
                                  '.jpg',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: chat.roomType == 'IN_CHATROOM'
                                ? AssetImage("assets/images/group_avatar_c.png")
                                : imageProvider,
                            backgroundColor: AppTheme.white,
                            radius: 30,
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: AppTheme.white,
                              radius: 30,
                              backgroundImage: chat.roomType == 'IN_CHATROOM'
                                  ? AssetImage(
                                      "assets/images/group_avatar_c.png")
                                  : AssetImage(
                                      "assets/images/user_avatar_c.png")),
                        );
                      },
                    ),

                    if (chat.isOnline == true)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: kDotColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 3),
                          ),
                        ),
                      )
                  ],
                ),
                //

                // ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                            chat.roomType == 'IN_CHATROOM'
                                ? chat.roomDefaultName
                                : chat.contactRoomName.toString(),
                            style: TextStyle(
                                fontWeight: chat.unReadMsgCount > 0
                                    ? FontWeight.w900
                                    : FontWeight.w500),
                            overflow: TextOverflow.clip,
                            maxLines: 2),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Opacity(
                                  opacity: chat.unReadMsgCount > 0 ? 1 : 0.64,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.4),
                                    child: IntrinsicWidth(
                                      child: Text(
                                        (chat.messageModel?.MSG_CONT == null
                                                ? ""
                                                : chat.messageModel
                                                            ?.MSG_TYPE_CODE ==
                                                        "CALL"
                                                    ? "${chatScreenController.displayMessageCall(chat.messageModel?.ROLE_CALL, chat.messageModel?.STATUS_CALL)}"
                                                    : chat
                                                        .messageModel?.MSG_TYPE_CODE == "FILE" ? chatScreenController.checkFileExtnAudio(chat.messageModel?.FILE_TYPE)? "Tin nhắn thoại": chat.messageModel?.MSG_CONT : chat.messageModel?.MSG_CONT)
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: chat.unReadMsgCount > 0
                                                ? FontWeight.w800
                                                : FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 5),
                              if (chat.messageModel?.MSG_CONT != null)
                                Opacity(
                                  opacity: 0.4,
                                  child:
                                  Obx(() =>Text(
                                    (chat.messageModel?.SEND_DATE != null
                                        ? authenticationController
                                        .displayTime2(chat
                                        .messageModel?.SEND_DATE)
                                    // ? chat.timeLastMessageDisplay
                                    // .toString()
                                        : DateTime.now().toString())
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: chat.unReadMsgCount > 0
                                            ? FontWeight.w800
                                            : FontWeight.w400),
                                    overflow: TextOverflow.clip,
                                  )),
                                ),
                              // if(chatScreenController.displayMessageCall(chat.messageModel?.ROLE_CALL, chat.messageModel?.STATUS_CALL) != '')
                              //   Opacity(
                              //     opacity: 0.4,
                              //     child: Text(
                              //       (chat.messageModel?.SEND_DATE != null
                              //           ? chat.timeLastMessageDisplay
                              //           .toString()
                              //           : DateTime.now().toString())
                              //           .toString(),
                              //       style: TextStyle(
                              //           fontSize: 12,
                              //           fontStyle: FontStyle.italic,
                              //           fontWeight: chat.unReadMsgCount > 0
                              //               ? FontWeight.w800
                              //               : FontWeight.w400),
                              //       overflow: TextOverflow.clip,
                              //     ),
                              //   )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (chat.unReadMsgCount > 0)
                      // Positioned(
                      //   right: 0,
                      //   bottom: 0,
                      //   child:
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.dark_grey,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 0),
                        ),
                        child: Center(
                          child: Opacity(
                            opacity: 0.9,
                            child: Text(
                              chat.unReadMsgCount.toString(),
                              style: TextStyle(
                                  fontWeight: chat.unReadMsgCount > 0
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: AppTheme.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    // )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
