import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';

import '../../features/home/home_controller.dart';

class UserCircle extends StatelessWidget {
  UserCircle(
      {Key? key,
      required this.height,
      required this.width,
      required this.check})
      : super(key: key);
  var height;
  var width;
  bool check; // display avatar user
  final ClientSocketController clientSocketController = Get.find();
  final HomeController _controller = Get.find();
  final ContactScreenController contactScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          // color: separatorColor,
          ),
      child: Stack(
        children: <Widget>[
          if (!check)
            Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future:
                      clientSocketController.messenger.selectedRoom?.roomType ==
                              "IN_CONTACT_ROOM"
                          ? contactScreenController.getImgUser(
                              clientSocketController
                                      .messenger.selectedRoom?.userUidContact
                                      .toString() ??
                                  "")
                          : contactScreenController.getImgUser(""),
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return new CachedNetworkImage(
                      imageUrl:
                          'https://backend.atwom.com.vn/public/resource/imageView/' +
                              text.data.toString() +
                              '.jpg',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 50,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image(
                          image: clientSocketController
                                      .messenger.selectedRoom?.roomType ==
                                  'IN_CHATROOM'
                              ? AssetImage("assets/images/group_avatar_c.png")
                              : AssetImage("assets/images/user_avatar_c.png")),
                    );
                  }),
            ),
          if (check)
            Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future: _controller.fetchUser(),
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return new CachedNetworkImage(
                      imageUrl:
                          'https://backend.atwom.com.vn/public/resource/imageView/' +
                              text.data.toString() +
                              '.jpg',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 50,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image(
                          image: AssetImage("assets/images/user_avatar_c.png")),
                    );
                  }),
            ),
          if (check)
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: height * 0.25,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.white, width: 2),
                    color: kDotColor,
                  ),
                ))
        ],
      ),
    );
  }
}
