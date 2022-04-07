import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';

import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  ScrollController controller = ScrollController();
  // var listMessage = Get.arguments['data'];
  var result = [].obs;
  var page = box.read("pageState");
  var myController = TextEditingController().obs;

  MessageScreenController() {}

  @override
  void onInit() {
    controller.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onReady() {
    LoadMessage("null");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _onScroll() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print(page);
      LoadMessage(box.read("pageState"));
    }
  }

  LoadMessage(var page) async {
    messageProvider.getMessageByRoomId(Get.arguments['room'].roomUid, page);
    result.value = messageProvider.list.value;
    await Future.delayed(const Duration(seconds: 1));
    result.refresh();
    print("demo " + result.value.toString());
  }

  sendMessage(String msgContent) {
    messageProvider.sendMessage(Get.arguments['room'].roomUid, msgContent);
    MessageModel message = MessageModel(
        MSG_CONT: myController.value.text,
        MSG_TYPE_CODE: "TEXT",
        MSG_UID: "1",
        SEND_DATE: DateTime.now().toString(),
        USER_UID: box.read("userUid"));
    result.value.insert(0, message);
    result.refresh();
    myController.value.text = "";
    // LoadMessage(page);
  }
}
