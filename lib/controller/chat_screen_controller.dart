import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final SocketProvider _socketProvider = SocketProvider();
  final UserProvider userProvider = UserProvider();

  final ClientSocketController clientSocketController = Get.find();

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
    initDataRoom();
    super.onInit();
  }

  @override
  void onReady() {
    // initDataRoom();
    super.onReady();
  }

  ChatScreenController() {
    // initDataRoom();
  }

  initDataRoom() async {
    await _socketProvider.connect();
    clientSocketController.messenger.listRoom.value.clear();
    await Future.delayed(const Duration(seconds: 1));
    clientSocketController.messenger.listRoom.value =
        _socketProvider.chatsDatas;
    clientSocketController.messenger.listRoom.refresh();
    clientSocketController.messenger.listRoomFlag.value =
        clientSocketController.messenger.listRoom.value;
    print("abc" + _socketProvider.chatsDatas.value.toString());
  }

  chatNameSearch(String name) async {
    clientSocketController.messenger.listRoom.value =
        clientSocketController.messenger.listRoomFlag.value;
    if (name.isEmpty) {
      clientSocketController.messenger.listRoom.value =
          clientSocketController.messenger.listRoom.value;
    } else {
      clientSocketController.messenger.listRoom.value = clientSocketController
          .messenger.listRoom.value
          .where((element) => element.roomDefaultName
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    }
  }

  getLastMessage(var chatRoom) {
    _socketProvider.getLastMessage(chatRoom.roomUid, chatRoom.lastMsgUid);
  }

  getMessageByRoomId(var chatRoom,var action) async {
    clientSocketController.messenger.selectedRoom = chatRoom;
    getLastMessage(chatRoom);
    await messageProvider.getMessageByRoomId(chatRoom.roomUid, page);
    clientSocketController.messenger.chatList.value = messageProvider.list.value;
    var listMessage = clientSocketController.messenger.chatList.value;
    print("roomUid    " + chatRoom.roomUid);
    if(action == "exits"){
      Get.offAndToNamed(messagescreen,
          arguments: {"room": chatRoom, "data": listMessage});
    }else{
      Get.toNamed(messagescreen,
          arguments: {"room": chatRoom, "data": listMessage});
    }
  }

  // addChat(var chat) {
  //   chatTempList.add(chat);
  // }

  onPress(var check) {
    state.value = check;
  }

  checkExistRoom(var employee, var userUid) {
    var result = {"flag": false, "room": ""};

    clientSocketController.messenger.listRoom.forEach((element) => {
          if (element.memberUidList.length == 2)
            {
              if (element.memberUidList.indexWhere((e) => e == userUid) != -1 &&
                  element.memberUidList
                          .indexWhere((e) => e == employee.USER_UID) !=
                      -1)
                {
                  result["flag"] = true,
                  result["room"] = element,
                }
            }
        });
    return result;
  }

  createChatroom(List employees) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userUid = prefs.getString('userUid');
    var result = checkExistRoom(employees[0], userUid);
    if (employees.length == 1 && result["flag"] == true) {
      await getMessageByRoomId(result["room"],"exits");
      return;
    }
    // print(employees);
    // checkExistRoom(employees[0]);

    employees.sort(
        (a, b) => a.USER_NM_KOR.toString().compareTo(b.USER_NM_KOR.toString()));
    // sx theo tên
    employees.sort((a, b) => a.POSITION_ORDER ?? 0 - b.POSITION_ORDER ?? 0);
    // sx theo vị trí

    var memberList =
        employees.map((e) => e.USER_UID).toList(); // get user_uid list
    print(memberList);
    // get user_uid của người tạo
    memberList.insert(0, userUid);

    var roomName = employees.map((e) => e.USER_NM_KOR).join(', ');

    var userInfo = clientSocketController.messenger.currentUser;
    print(userInfo);
    if (employees.length > 1) {
      var name = userInfo?.USER_NM_KOR ?? "";
      roomName += ", " + name;
    }

    await userProvider.createChatroom(roomName, memberList);
    // await Future.delayed(const Duration(seconds: 1));
    await initDataRoom();
    await getMessageByRoomId(clientSocketController.messenger.listRoom.value[0],"");
  }
}
