import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/ulti/sharedPrefUlti.dart';
import 'package:hello_world_flutter/model/ChatMessage.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/view/message/attachment_message.dart';
import 'package:hello_world_flutter/view/message/center_text_message.dart';
import 'package:intl/intl.dart';

import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModel message) {
      switch (message.MSG_TYPE_CODE) {
        case "TEXT":
          return TextMessage(message: message);
        case "CREATE_ROOM":
          return CenterTextMessage(message: message);
        case "FILE":
          return AttachMessage(message: message);
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
        mainAxisAlignment: message.USER_UID == box.read("userUid")
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // !message.isSender - phải check xem có phải do client gửi tin nhắn ko
          Visibility(
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage("images/default_avatar.png"),
            ),
            visible: message.USER_UID != box.read("userUid"),
          ),
          Visibility(
            child: SizedBox(width: kDefaultPadding / 2),
            visible: message.USER_UID != box.read("userUid"),
          ),
          Container(
            child: Column(
              crossAxisAlignment: message.USER_UID == box.read("userUid")
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  child: AutoSizeText(
                    DateFormat('hh:mm aa')
                        .format(DateTime.parse(message.SEND_DATE.toString()))
                        .toString(),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
                messageContaint(message),
              ],
            ),
          ),
        ],
        // if (message.MSG_TYPE_CODE == "TEXT")
        //   MessageStatusDot(status: MessageStatus.viewed)
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
