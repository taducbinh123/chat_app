import 'dart:convert';

import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  List<Room> chatsData = [];

  connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");
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

    roomSocket.emitWithAck("getRoomsByUserUid", {"userUid": userUid},
        ack: (data) {
      print(data);
      var result = data as List;
      for (int i = 0; i < result.length; i++) {
        Room rm = Room.fromJson(result[i] as Map<dynamic, dynamic>);
        chatsData.add(rm);
      }
    });
    return chatsData;
  }

  getLastMessage(var roomUid, var lastReadMsgId) async {
    IO.Socket roomSocket = IO.io(chatApiHost + "/chat");
    roomSocket.emit("updateLastReadMsg",
        {"roomUid": roomUid, "lastReadMsgId": lastReadMsgId});
    roomSocket.on("updateLastReadMsg", (data) => print("done"));
  }
}
