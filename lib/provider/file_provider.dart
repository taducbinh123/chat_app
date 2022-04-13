import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constant/socket.dart';

class FileProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  var page = "";
  final box = GetStorage();
  var list = [].obs;

  uploadFile(var file, var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String temp = "";
    List<dynamic> decodeData;
    var requestBody = {
      'file': file,
      'ROOM_UID': data.ROOM_UID,
      'USER_UID': data.USER_UID,
    };
    final response = await http.post(
        Uri.parse(chatApiHost + '/api/chat/upload'),
        headers: {"Authorization": "Bearer " + access_token!},
        body: requestBody);
    if (response.statusCode == 200) {
      print(response.body.toString());
      Map<String, dynamic> map = json.decode(response.body);

      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
      // roomSocket.connect();
      // roomSocket.onConnect((_) {
      roomSocket.emit("pingMsgAttachment", {response.body});
    } else {
      print(response.body.toString());
      throw Exception('Failed to load message');
    }
    print(response.body.toString());
  }

  // sendMessage(String roomUid, String msgContent) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userUid = prefs.getString("userUid");
  //   String? access_token = prefs.getString('access_token');
  //
  //   roomSocket.io.options['extraHeaders'] = {
  //     "Content-Type": "application/json"
  //   };
  //   // roomSocket.connect();
  //   // roomSocket.onConnect((_) {
  //   roomSocket.emit("sendMessage", {
  //     "ROOM_UID": roomUid,
  //     "USER_UID": userUid,
  //     "MSG_CONT": msgContent,
  //     "MSG_TYPE_CODE": "TEXT",
  //   });
  //   // });
  //   print(list.value);
  // }
}
