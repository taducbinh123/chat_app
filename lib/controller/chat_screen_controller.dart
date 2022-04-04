import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final SocketProvider _socketProvider = SocketProvider();
  final UserProvider userProvider = UserProvider();

  String userUid = "";

  String access_token = "";
  var state = false.obs;
  var test = "".obs;
  var page = "null";
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
    // print("load room");
    // chatsData = await _socketProvider.connect();
    // chatTempList.value = chatsData;
    // chatTempList.refresh();
    // print(chatsData);
    // print("jiojdv");
    _socketProvider.connect();
    chatTempList.value = await _socketProvider.chatsDatas;
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

  getLastMessage(var chatRoom) {
    _socketProvider.getLastMessage(chatRoom.roomUid, chatRoom.lastMsgUid);
  }

  getMessageByRoomId(var chatRoom) async {
    getLastMessage(chatRoom);
    var listMessage =
        await messageProvider.getMessageByRoomId(chatRoom.roomUid, page);
    print("roomUid    " + chatRoom.roomUid);
    Get.toNamed(messagescreen,
        arguments: {"room": chatRoom, "data": listMessage});
  }

  // addChat(var chat) {
  //   chatTempList.add(chat);
  // }

  onPress(var check) {
    state.value = check;
  }

  bool checkExistRoom(var employee, var userUid) {
    print("list chat");
    print(chatTempList); // list room chat
    bool flag = false;
    chatTempList.forEach((element) {
      if (element.memberUidList.length == 2) {
        if (element.memberUidList.indexWhere((e) => e == userUid) != -1 &&
            element.memberUidList.indexWhere((e) => e == employee.USER_UID) !=
                -1) {
          flag = true;
        }
      }
    });
    return flag;
  }

  createChatroom(List employees) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userUid = prefs.getString('userUid');
    if (employees.length == 1 && checkExistRoom(employees[0], userUid)) {
      return;
    }
    // print(employees);
    // checkExistRoom(employees[0]);

    employees.sort(
        (a, b) => a.USER_NM_KOR.toString().compareTo(b.USER_NM_KOR.toString()));
    // sx theo tên
    employees.sort((a, b) => a.POSITION_ORDER - b.POSITION_ORDER);
    // sx theo vị trí

    var memberList =
        employees.map((e) => e.USER_UID).toList(); // get user_uid list
    print(memberList);
    // get user_uid của người tạo
    memberList.insert(0, userUid);

    var roomName = employees.map((e) => e.USER_NM_KOR).join(', ');

    var userInfo = await userProvider.getUserInfo(userUid);
    print(userInfo);
    if (employees.length > 1) {
      roomName += ", " + userInfo['NAME_KR'];
    }

    await userProvider.createChatroom(roomName, memberList);
    await initDataRoom();
  }
}
