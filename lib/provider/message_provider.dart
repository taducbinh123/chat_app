import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/socket.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class MessageProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  var page = "";
  final box = GetStorage();
  var list = [].obs;

  getMessageByRoomId(String roomUid, String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String temp = "";
    List<dynamic> decodeData;
    final response = await http.get(
        Uri.parse(chatApiHost +
            '/api/chat/getmessageByRoomId?roomId=' +
            roomUid +
            "&page=" +
            page),
        headers: {"Authorization": "Bearer " + access_token!});
    print(chatApiHost +
        '/api/chat/getmessageByRoomId?roomId=' +
        roomUid +
        "&page=" +
        page);
    temp = chatApiHost +
        '/api/chat/getmessageByRoomId?roomId=' +
        roomUid +
        "&page=" +
        page;

    if (response.statusCode == 200) {
      // print(response.body.toString());
      Map<String, dynamic> map = json.decode(response.body);
      decodeData = map["rows"];
      // for (int i = decodeData.length - 1; i >= 0; i--) {
      for (int i = 0; i < decodeData.length; i++) {
        list.value.add(MessageModel.fromJson(decodeData[i]));
      }
      box.write("pageState", map["pageState"].toString());
    } else {
      print(response.body.toString());
      throw Exception('Failed to load message');
    }
    print(list.value);
  }

  sendMessage(String roomUid, String msgContent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");
    String? access_token = prefs.getString('access_token');

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    // roomSocket.connect();
    // roomSocket.onConnect((_) {
      roomSocket.emit("sendMessage", {
        "ROOM_UID": roomUid,
        "USER_UID": userUid,
        "MSG_CONT": msgContent,
        "MSG_TYPE_CODE": "TEXT",
      });
    // });
    print(list.value);
  }
}
