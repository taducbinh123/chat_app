import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class ContactScreenController extends GetxController {

  TextEditingController searchController = TextEditingController();
  var contactList = chatsData.obs;
  List<bool> state = List.filled(chatsData.length,false).obs;
  // var contactTempList = chatsData.obs;

  contactNameSearch(String name) {
    if (name.isEmpty) {
      contactList.value = chatsData;
    } else {
      contactList.value = chatsData
          .where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }
}