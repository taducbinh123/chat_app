import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class CustomAvatarContactAdd extends StatelessWidget {
  const CustomAvatarContactAdd({
    Key? key,
    required this.chat,
    required this.press,
    required this.check,
    required this.index
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;
  final bool check;
  final int index;
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find<ContactScreenController>();
    // TODO: implement build
    return Container(
        child: Obx(()=>Card(
          color:  check ? (contactController.getStateByChat(chat) ? Colors.grey : colorCard) : colorCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                      ),
                      if (chat.isActive)
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
                          Text(
                            chat.name,
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          // SizedBox(height: 8),
                          // Opacity(
                          //   opacity: 0.64,
                          //   child: Text(
                          //     chat.lastMessage,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Opacity(
                  //   opacity: 0.64,
                  //   child: Text(chat.time),
                  // ),
                ],
              ),
            ),
          ),
        ),
        )


    );
  }
}
