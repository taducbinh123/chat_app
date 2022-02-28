import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:intl/intl.dart';

class CenterTextMessage extends StatelessWidget {
  const CenterTextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      message!.MSG_CONT.toString() +
          " " +
          DateFormat('dd-MM-yyyy – hh:mm')
              .format(DateTime.parse(message!.SEND_DATE.toString()))
              .toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      maxFontSize: 12,
    );

    // Text(
    //   message!.MSG_CONT,
    //   style: TextStyle(
    //     color: message!.USER_UID != ""
    //         ? Colors.black
    //         : Theme.of(context).textTheme.bodyText1!.color,
    //   ),
    // ),
  }
}
