import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final SocketProvider _socketProvider = SocketProvider();
  final UserProvider userProvider = UserProvider();


  String userUid = "";

  String access_token = "";
  var state = false.obs;
  var test = "".obs;
  var page = "";
  var chatsData = [];
  TextEditingController searchController = TextEditingController();
  var chatTempList = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  ChatScreenController() {
    initDataRoom();
  }

  initDataRoom() async {
    chatsData = await _socketProvider.connect();
    chatTempList.value = chatsData;
    print(chatTempList.value);
  }

  chatNameSearch(String name) {
    if (name.isEmpty) {
      chatTempList.value = chatsData;
    } else {
      chatTempList.value = chatsData
          .where((element) =>
              element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  getLastMessage(var chatRoom) async {
    _socketProvider.getLastMessage(chatRoom.roomUid, chatRoom.lastMsgUid);
  }

  getMessageByRoomId(var chatRoom) async {
    await getLastMessage(chatRoom);
    var listMessage =
        await messageProvider.getMessageByRoomId(chatRoom.roomUid, page);

    Get.toNamed(messagescreen,
        arguments: {"room": chatRoom, "data": listMessage});
  }

  addChat(var chat) {
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }

  bool checkExistRoom(var employee) {
    return true;
  }

  addRoomChat(List employees) async {
    if (employees.length == 1 && checkExistRoom(employees[0])) {

    }

    employees.sort((a, b) => a.USER_NM_KOR.toString().compareTo(b.USER_NM_KOR.toString()));
    employees.sort((a, b) => a.POSITION_ORDER - b.POSITION_ORDER);

    var memberList = employees.map((e) => e.USER_UID).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userUid = prefs.getString('userUid');
    memberList.insert(0, userUid);

    var roomName = employees.map((e) => e.USER_NM_KOR).join(', ');

    var userInfo = await userProvider.getUserInfo(userUid);

    if(employees.length > 1){
      roomName += ", " +  userInfo.NAME_KR;
    }

    await userProvider.createChatroom(roomName, memberList);

  }
}
