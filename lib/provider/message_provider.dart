import 'dart:convert';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  var page = "";

  getMessageByRoomId(String roomUid, String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

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
    List<dynamic> decodeData;

    if (response.statusCode == 200) {
      print(response.body.toString());
      Map<String, dynamic> map = json.decode(response.body);
      decodeData = map["rows"];
      prefs.setString("pageState", map["pageState"].toString());
    } else {
      print(response.body.toString());
      throw Exception('Failed to load message');
    }

    return decodeData.map((e) => MessageModel.fromJson(e)).toList();
  }

  sendMessage(String roomUid, String msgContent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");
    String? access_token = prefs.getString('access_token');

    IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": access_token}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.connect();
    roomSocket.onConnect((_) {
      print("room socket " + roomSocket.connected.toString());
      roomSocket.emit("sendMessage", {
        "ROOM_UID": roomUid,
        "USER_UID": userUid,
        "MSG_CONT": msgContent,
        "MSG_TYPE_CODE": "TEXT",
      });
      getMessageByRoomId(roomUid, "null");
    });
  }
}
