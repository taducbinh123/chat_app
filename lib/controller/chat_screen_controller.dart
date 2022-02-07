import 'package:get/get.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class ChatScreenController extends GetxController {
  var chats = chatsData.obs;

  updateChats(){
    chats.value = chatsData;
  }
}