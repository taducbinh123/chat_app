import 'dart:convert';

import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserProvider {

  getUserInfo(String? userUid) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.get(Uri.parse(imwareApiHost +
        '/api/userInfo/getUserInfo' ),
        headers: {
          'Authorization': 'Bearer ' + accessToken!,
          'Content-type': 'application/json',
        });
    final Map<String, dynamic> data = jsonDecode(response.body);
    if(response.statusCode == 200) return data;
    else throw Exception("Failed to load userInfo");
  }

  createChatroom(var roomName, var memberList)async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? access_token = prefs.getString('access_token');
      print(access_token);
      IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        "auth": {"token": access_token}

      });
      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
      roomSocket.connect();
      roomSocket.on("server_send_message", (data) => "abc");
      roomSocket.onConnect((_) {
        print(prefs.getString('access_token'));
        print("room socket " + roomSocket.connected.toString());
        roomSocket.emit("createChatroom", [roomName,memberList,{"type": 'IN_CHATROOM'}]);
    });
  }

}