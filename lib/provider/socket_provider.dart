import 'dart:convert';

import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  connect() async {
    List<Room> chatsData = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('userUid');

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
    roomSocket.onConnect((_) {
      print(prefs.getString('access_token'));
      print("room socket " + roomSocket.connected.toString());
      roomSocket.emitWithAck("getRoomsByUserUid", {"userUid": userUid},
          ack: (data) {
        print(data);
        var result = data as List;
        for (int i = 0; i < result.length; i++) {
          Room rm = Room.fromJson(result[i] as Map<dynamic, dynamic>);
          chatsData.add(rm);
        }
      });
    });
    return chatsData;
  }
}
