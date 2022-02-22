import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/ChatMessage.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/view/message/center_text_message.dart';
import 'package:intl/intl.dart';

import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModel message) {
      switch (message.MSG_TYPE_CODE) {
        case "TEXT":
          return TextMessage(message: message);
        case "CREATE_ROOM":
          return CenterTextMessage(message: message);
        // case ChatMessageType.audio:
        //   return AudioMessage(message: message);
        // case ChatMessageType.video:
        //   return VideoMessage();
        default:
          return SizedBox();
      }
    }

    // test
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: message!.MSG_TYPE_CODE != "TEXT"
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message!.MSG_TYPE_CODE == "TEXT") ...[
            // !message.isSender - phải check xem có phải do client gửi tin nhắn ko
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
            SizedBox(width: kDefaultPadding / 2),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('hh:mm - dd-MM-yyyy')
                        .format(DateTime.parse(message.SEND_DATE))
                        .toString(),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 5),
                  messageContaint(message),
                ],
              ),
            ),
          ],
          if (message!.MSG_TYPE_CODE == "TEXT")
            MessageStatusDot(status: MessageStatus.viewed)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
