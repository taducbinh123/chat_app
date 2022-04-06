import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';

import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  ScrollController controller = ScrollController();
  var listMessage = Get.arguments['data'];
  var result = [].obs;
  var page= box.read("pageState");
  var myController = TextEditingController().obs;

  MessageScreenController() {

  }

  @override
  void onInit() {
    LoadMessage("null");
    controller.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  _onScroll() {
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      print(page);
      LoadMessage(box.read("pageState"));
    }
  }

  LoadMessage(var page) async {
    result = [].obs;
    for (MessageModel m in await messageProvider.getMessageByRoomId(
        Get.arguments['room'].roomUid, page) as List) {
      result.value.add(m);
    }
  }

  sendMessage(String msgContent) {
    messageProvider.sendMessage(Get.arguments['room'].roomUid, msgContent);
    myController.value.text = "";
  }
}
