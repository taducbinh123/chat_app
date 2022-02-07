import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class ChatScreenController extends GetxController {
  var state = false.obs;
  TextEditingController searchController = TextEditingController();
  var chatTempList = chatsData.obs;
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

  addChat(var chat){
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }
}
