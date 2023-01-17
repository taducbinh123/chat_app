import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/model/message.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
        constraints: BoxConstraints(
            minWidth: queryData.size.width * 0.1,
            maxWidth: queryData.size.width * 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: message.USER_UID == box.read("userUid")
              ? AppTheme.nearlyBlack
              : AppTheme.dark_grey.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            topRight: (message.USER_UID == box.read("userUid") &&
                    DateTime.parse(message.SEND_DATE.toString())
                                .millisecondsSinceEpoch -
                            (message.PRE_MSG_SEND_DATE.toString() == '0'
                                ? 0
                                : DateTime.parse(
                                        message.PRE_MSG_SEND_DATE.toString())
                                    .millisecondsSinceEpoch) <=
                        2 * 60 * 1000
                ? Radius.circular(0)
                : Radius.circular(16)),
            topLeft: (message.USER_UID != box.read("userUid") &&
                    DateTime.parse(message.SEND_DATE.toString())
                                .millisecondsSinceEpoch -
                            (message.PRE_MSG_SEND_DATE.toString() == '0'
                                ? 0
                                : DateTime.parse(
                                        message.PRE_MSG_SEND_DATE.toString())
                                    .millisecondsSinceEpoch) <=
                        2 * 60 * 1000 && message.PRE_USER_UID == message.USER_UID
                ? Radius.circular(0)
                : Radius.circular(16)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              message.MSG_CONT.toString(),
              style: TextStyle(fontSize: 13, color: message.USER_UID == box.read("userUid")
                  ? Colors.white
                  : Colors.black87),
            )
          ],
        ));
  }
}
