import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final SocketProvider _socketProvider = SocketProvider();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
    access_token = prefs.getString('access_token') ?? '';
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

  getMessageByRoomId(var chatRoom) async {
    // print(chatRoom);
    print(chatRoom.roomUid);
    var listMessage =
        await messageProvider.getMessageByRoomId(chatRoom.roomUid, page);
    print(listMessage);
    Get.toNamed(messagescreen,
        arguments: {"room": chatRoom, "data": listMessage});
  }

  addChat(var chat) {
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }
}
