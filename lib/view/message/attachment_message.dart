import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:AMES/common/app_theme.dart';

import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/socket.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/model/message.dart';
import 'package:AMES/view/message/preview_image.dart';

class AttachMessage extends StatelessWidget {
  const AttachMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            if (message.FILE_EXTN!.contains("image")) {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return PreviewImage(
                  imageUrl: chatApiHost +
                      "/api/chat/getFile/" +
                      message.FILE_PATH.toString(),
                  tag: message.MSG_UID.toString(),
                );
              }));
            }
          },
          child: Container(
              constraints: BoxConstraints(
                  minWidth: queryData.size.width * 0.1,
                  maxWidth: queryData.size.width * 0.5),
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: message.FILE_EXTN!.contains("image")
                    ? Colors.white
                    : (message.USER_UID == box.read("userUid")
                        ? AppTheme.nearlyBlack
                        : AppTheme.dark_grey.withOpacity(0.1)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: (message.USER_UID == box.read("userUid") &&
                          DateTime.parse(message.SEND_DATE.toString())
                                      .millisecondsSinceEpoch -
                                  (message.PRE_MSG_SEND_DATE.toString() == '0'
                                      ? 0
                                      : DateTime.parse(message.PRE_MSG_SEND_DATE
                                              .toString())
                                          .millisecondsSinceEpoch) <=
                              2 * 60 * 1000
                      ? Radius.circular(0)
                      : Radius.circular(16)),
                  topLeft: (message.USER_UID != box.read("userUid") &&
                          DateTime.parse(message.SEND_DATE.toString())
                                      .millisecondsSinceEpoch -
                                  (message.PRE_MSG_SEND_DATE.toString() == '0'
                                      ? 0
                                      : DateTime.parse(message.PRE_MSG_SEND_DATE
                                              .toString())
                                          .millisecondsSinceEpoch) <=
                              2 * 60 * 1000 && message.PRE_USER_UID == message.USER_UID
                      ? Radius.circular(0)
                      : Radius.circular(16)),
                ),
              ),
              child: Wrap(
                children: [
                  Visibility(
                    visible: !message.FILE_EXTN!.contains("image"),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              color: AppTheme.white,
                              height: 80,
                            ),
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file,
                                  color: AppTheme.nearlyBlack,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  message.FILE_ORI_NM.toString(),
                                  style: TextStyle(
                                      height: 1.0,
                                      // color: message!.USER_UID ==
                                      //         box.read("userUid")
                                      //     ? AppTheme.white
                                      //     : AppTheme.nearlyBlack
                                      color: AppTheme.nearlyBlack),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(
                            height: 40,
                            child: IconButton(
                                icon: Icon(
                                  Icons.file_download,
                                  color: message.USER_UID == box.read("userUid")
                                      ? AppTheme.white
                                      : AppTheme.nearlyBlack,
                                ),
                                onPressed: () => {
                                      downloadFile(
                                          chatApiHost +
                                              "/api/chat/getFile/" +
                                              message.FILE_PATH.toString(),
                                          message.FILE_ORI_NM.toString())
                                    }))
                      ],
                    ),
                  ),
                  Visibility(
                      visible: message.FILE_EXTN!.contains("image"),
                      child: Hero(
                        tag: message.MSG_UID.toString(),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: chatApiHost +
                                "/api/chat/getFile/" +
                                message.FILE_PATH.toString(),
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      )),
                ],
              )),
        )
      ],
    );
  }
}
