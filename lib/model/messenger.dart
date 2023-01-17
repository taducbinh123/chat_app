import 'package:AMES/model/call_room.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/model/room.dart';
import 'package:AMES/view/message/message.dart';

class Messenger {
  var currentUser = Employee(USER_NM_KOR: "", USER_ID: "", USER_UID: "", DEPT_NM: "", DEPT_CD: "").obs;
  Room? selectedRoom;
  var roomNameSelected = "".obs;
  var listRoom = [].obs;
  var memberList = [].obs; // list member in selected room
  var chatList = [].obs; // list message in selected room
  var contactList = [].obs;
  var callHistory =[].obs;
  var totalRoomUnReadMessage = 0.obs;
  var callRoom = CallRoom().obs;

  var listRoomFlag = [].obs;
  var contactListFlag = [].obs;
  // Messenger({
  //   this.currentUser,
  //   this.selectedRoom,
  //   this.listRoom,
  //   this.memberList,
  //   this.chatList
  // });

  leftRoom() {
    this.selectedRoom = null;
    this.roomNameSelected.value = "";
    this.memberList.value = [];
    this.chatList.value = [];
  }
}
