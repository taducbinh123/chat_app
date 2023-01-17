import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:AMES/model/employee.dart';

import '../../features/home/home_controller.dart';

class CustomAvatarContactAdd extends StatelessWidget {
  const CustomAvatarContactAdd({
    Key? key,
    required this.employee,
    required this.press,
    required this.check,
    required this.index,
    this.screen
  }) : super(key: key);

  final Employee employee;
  final VoidCallback press;
  final bool check;
  final int index;
  final String? screen;
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find<ContactScreenController>();
    final roomChatController = Get.put(RoomChatController());
    final HomeController _controller = Get.find();
    // TODO: implement build
    return Container(
        child: Obx(()=>Card(
          color:  check ? screen == 'add' ?
          ((roomChatController.state.firstWhere((element) => element.employee.USER_UID == employee.USER_UID).state.value ? AppTheme.background2 : colorCard) ) :
          ((contactController.state.firstWhere((element) => element.employee.USER_UID == employee.USER_UID).state.value ? AppTheme.background2 : colorCard)) :
          colorCard ,
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
                      FutureBuilder(
                          future: _controller.fetchEmp(employee.USER_ID),
                          builder:
                              (BuildContext context, AsyncSnapshot<String> text) {
                            return CachedNetworkImage(
                              imageUrl:
                              'https://backend.atwom.com.vn/public/resource/imageView/' +
                                  text.data.toString() +
                                  '.jpg',
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 24,
                                  ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                  AssetImage("assets/images/user_avatar_c.png")),
                            );

                            // new ;
                          }),
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
                            employee.USER_NM_KOR,
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Text(
                            employee.DEPT_NM,
                            style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
