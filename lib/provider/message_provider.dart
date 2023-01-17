import 'dart:convert';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AMES/features/authentication/authentication_service.dart';

import '../model/history_item.dart';

class MessageProvider {
  final ClientSocketController clientSocketController = Get.find();
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  var page = "";
  final box = GetStorage();

  getMessageByRoomId(String roomUid, String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? userUid = prefs.getString('userUid');
    String temp = "";
    List<dynamic> decodeData;
    List<dynamic> callHistory;
    final response = await http.get(
        Uri.parse(chatApiHost +
            '/api/chat/getmessageByRoomId?roomId=' +
            roomUid +
            "&page=" +
            page +
            "&userUid=" +
            userUid!),
        headers: {"Authorization": "Bearer " + access_token!});

    temp = chatApiHost +
        '/api/chat/getmessageByRoomId?roomId=' +
        roomUid +
        "&page=" +
        page +
        "&userUid=" +
        userUid;

    if (response.statusCode == 200) {
      // print("---------------------------//-------------------------------");
      // print(response.body);
      Map<String, dynamic> map = json.decode(response.body);

      decodeData = map["rows"];
      // callHistory = map['callHistory'];
      // print(callHistory);
      if (page == "null")
        clientSocketController.messenger.chatList.value.clear();
      for (int i = 0; i < decodeData.length; i++) {
        MessageModel messageModel = MessageModel.fromJson(decodeData[i]);
        if (i == decodeData.length - 1) {
          messageModel.PRE_MSG_SEND_DATE =
              (new DateTime.fromMicrosecondsSinceEpoch(0)).toString();
        } else {
          messageModel.PRE_USER_UID = MessageModel.fromJson(decodeData[i + 1]).MSG_TYPE_CODE.toString() == "CALL" ? "" : MessageModel.fromJson(decodeData[i + 1]).USER_UID.toString();
          messageModel.PRE_MSG_SEND_DATE =
              MessageModel.fromJson(decodeData[i + 1]).SEND_DATE.toString();
        }
        clientSocketController.messenger.chatList.value.add(messageModel);
      }

      clientSocketController.messenger.chatList.refresh();
      box.write("pageState", map["pageState"].toString());
    } else {
      // print(response.body.toString());
      throw Exception('Failed to load message');
    }
  }

  getUserCallHistory() async {
    clientSocketController.messenger.callHistory.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? userUid = prefs.getString('userUid');
    List<dynamic> decodeData;

    final response = await http.get(
        Uri.parse(
            chatApiHost + '/api/chat/getUserCallHistory?userUid=' + userUid!),
        headers: {"Authorization": "Bearer " + access_token!});

    if (response.statusCode == 200) {
      // print("---------------------------//-------------------------------");
      // print(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      decodeData = map["rows"];
      clientSocketController.messenger.chatList.value.clear();
      for (int i = 0; i < decodeData.length; i++) {
        HistoryItem historyModel = HistoryItem.fromJson(decodeData[i]);

        clientSocketController.messenger.callHistory.value.add(historyModel);
      }
      clientSocketController.messenger.callHistory.refresh();
    } else {
      throw Exception('Failed to load message');
    }
  }

  sendMessage(String roomUid, String msgContent, String uidTimeStamp, String roomName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.emit("sendMessage", {
      "ROOM_NAME": roomName,
      "ROOM_UID": roomUid,
      "USER_UID": userUid,
      "MSG_CONT": msgContent,
      "UID_TIMESTAMP": uidTimeStamp,
      "MSG_TYPE_CODE": "TEXT",
    });
  }
}
