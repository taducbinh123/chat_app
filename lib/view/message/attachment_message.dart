import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/message.dart';

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
            print(chatApiHost +
                "/api/chat/getFile/" +
                message!.FILE_PATH.toString());
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
                color: message!.USER_UID == box.read("userUid")
                    ? Colors.blue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Wrap(
                children: [
                  Visibility(
                      visible: !message!.FILE_EXTN!.contains("image"),
                      child: AutoSizeText(
                        message!.FILE_ORI_NM.toString(),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: message!.USER_UID == box.read("userUid")
                                ? Colors.white
                                : Colors.black87),
                      )),
                  Visibility(
                    visible: message!.FILE_EXTN!.contains("image"),
                    child: Image.network(chatApiHost +
                        "/api/chat/getFile/" +
                        message!.FILE_PATH.toString()),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
