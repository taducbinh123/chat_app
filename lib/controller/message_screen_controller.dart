import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/ulti/sharedPrefUlti.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  var listMessage = Get.arguments['data'];
  var result = [].obs;
  var myController = TextEditingController().obs;

  MessageScreenController() {
    LoadMessage();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    LoadMessage();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  LoadMessage() async {
    result = [].obs;
    for (MessageModel m in await messageProvider.getMessageByRoomId(
        Get.arguments['room'].roomUid, "null") as List) {
      result.value.add(m);
    }
    for (MessageModel m in await messageProvider.getMessageByRoomId(
        Get.arguments['room'].roomUid,
        SharedPrefUtils.readPrefStr("pageState")) as List) {
      result.value.add(m);
    }
    print("result is " + result.value.length.toString());
    result.refresh();
  }

  sendMessage(String msgContent) {
    messageProvider.sendMessage(Get.arguments['room'].roomUid, msgContent);
    myController.value.text = "";
    result = [].obs;
  }
}
