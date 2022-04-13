import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/view/message/message.dart';

class Messenger {
  Employee? currentUser;
  Room? selectedRoom;
  var listRoom = [].obs;
  var memberList = [].obs; // list member in selected room
  var chatList = [].obs; // list message in selected room
  var contactList = [].obs;

  // Messenger({
  //   this.currentUser,
  //   this.selectedRoom,
  //   this.listRoom,
  //   this.memberList,
  //   this.chatList
  // });

  leftRoom(){
    this.selectedRoom = null;
    this.memberList.value = [];
    this.chatList.value = [];
  }

}

