import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:AMES/model/employee.dart';

class SelectCircle extends StatelessWidget {
  SelectCircle(
      {Key? key,
      required this.height,
      required this.width,
      required this.text,
      required this.chat,
      this.screen})
      : super(key: key);
  var height;
  var width;
  var text;
  Employee chat;
  var screen;
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find();
    final roomChatController = Get.put(RoomChatController());
    var textName = text.toString().split(" ");
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.2, height*1.1, 0.0, 0.0),
          child:
          Center (
            // alignment: Alignment.bottomCenter,
            child: Text(
              textName[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: lightBlueColor,
                fontSize: width * 0.2,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          height: height,
          width: width,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(50),
          //   color: separatorColor,
          // ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: FutureBuilder(
                    future: contactController.getImgUser(chat.USER_UID),
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
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     textName[0],
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: lightBlueColor,
              //       fontSize: width * 0.2,
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Container(
                    height: height * 0.25,
                    width: width * 0.5,
                    child: Icon(
                      Icons.cancel,
                      color: Colors.black,
                      size: width * 0.35,
                    ),
                  ),
                  onTap: () {
                    //print("tapped");
                    if(screen == 'add'){
                      roomChatController.changeState(chat, 0, 0);
                    }else{
                      contactController.changeState(chat, 0, 0);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

