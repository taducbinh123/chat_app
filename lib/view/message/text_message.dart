import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/ChatMessage.dart';
import 'package:hello_world_flutter/model/message.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
      constraints:
          BoxConstraints(minWidth: queryData.size.width * 0.1, maxWidth: queryData.size.width * 0.5),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message!.USER_UID != "" ? 1 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AutoSizeText(
        message!.MSG_CONT,
        style: TextStyle(
          color: message!.USER_UID != ""
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
