import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/socket.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/view/message/preview_image.dart';

class AttachMessage extends StatelessWidget {
  const AttachMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            if (message!.FILE_EXTN!.contains("image")) {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return PreviewImage(
                  imageUrl: chatApiHost +
                      "/api/chat/getFile/" +
                      message!.FILE_PATH.toString(),
                  tag: message!.MSG_UID.toString(),
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
                color: message!.FILE_EXTN!.contains("image")
                    ? Colors.white
                    : (message!.USER_UID == box.read("userUid")
                        ? Colors.blue
                        : Colors.grey[300]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Wrap(
                children: [
                  Visibility(
                    visible: !message!.FILE_EXTN!.contains("image"),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              color: Colors.grey,
                              height: 80,
                            ),
                            Column(
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  message!.FILE_ORI_NM.toString(),
                                  style: TextStyle(
                                      height: 1.0,
                                      color: message!.USER_UID ==
                                              box.read("userUid")
                                          ? Colors.white
                                          : Colors.black87),
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
                                  color:
                                      message!.USER_UID == box.read("userUid")
                                          ? Colors.white
                                          : Color(0xff3f3f3f),
                                ),
                                onPressed: () => {
                                      downloadFile(
                                          chatApiHost +
                                              "/api/chat/getFile/" +
                                              message!.FILE_PATH.toString(),
                                          message!.FILE_ORI_NM.toString())
                                    }))
                      ],
                    ),
                  ),
                  Visibility(
                      visible: message!.FILE_EXTN!.contains("image"),
                      child: Hero(
                        tag: message!.MSG_UID.toString(),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: chatApiHost +
                                "/api/chat/getFile/" +
                                message!.FILE_PATH.toString(),
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
