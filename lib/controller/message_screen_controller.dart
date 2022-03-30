import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  var listMessage = Get.arguments['data'];
  var result = [].obs;

  MessageScreenController() {

    LoadMessage();
  }

  LoadMessage() async {
    // print(listMessage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? page = await prefs.getString("pageState");
    result.value+=listMessage;
    result.value+= await messageProvider.getMessageByRoomId(Get.arguments['room'].roomUid, page.toString()) as List;
  }
}
