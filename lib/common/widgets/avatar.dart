import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:intl/intl.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Room chat;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("images/default_avatar.png"),
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
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          chat.roomDefaultName,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        ),
                        SizedBox(height: 8),
                        Opacity(
                          opacity: 0.64,
                          child: Text(
                            chat.messageModel.MSG_CONT != null ? chat.messageModel.MSG_CONT.toString() : "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.64,
                  child: Text(DateFormat('dd-MM-yyyy – hh:mm')
                      .format(DateTime.parse(
                          chat.messageModel.SEND_DATE.toString() != "null"
                              ? chat.messageModel.SEND_DATE.toString()
                              : DateTime.now().toString()))
                      .toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
