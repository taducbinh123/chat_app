import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:hello_world_flutter/model/employee.dart';

class CustomAvatarContact extends StatelessWidget {
  const CustomAvatarContact({
    Key? key,
    required this.employee,
    required this.press
  }) : super(key: key);

  final Employee employee;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child:  InkWell(
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
                    if (employee.ONLINE_YN == 'Y')
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
                          employee.USER_NM_ENG,
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


    );
  }
}
