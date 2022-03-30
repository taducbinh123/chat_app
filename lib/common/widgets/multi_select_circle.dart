import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/controller/room_chat_controller.dart';

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
  var chat;
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: separatorColor,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  textName[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: lightBlueColor,
                    fontSize: width * 0.2,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Container(
                    height: height * 0.25,
                    width: width * 0.5,
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: width * 0.35,
                    ),
                  ),
                  onTap: () {
                    print("tapped");
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

