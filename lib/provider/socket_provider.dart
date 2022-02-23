import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  connect() {
    List<Room> chatsData = [];
    IO.Socket socket = IO.io(chatApiHost, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": "94d83f56-e247-48a5-adfb-eb45a2fce677"}
    });
    socket.io.options['extraHeaders'] = {"Content-Type": "application/json"};
    IO.Socket roomSocket = IO.io(chatApiHost + "/room", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": "94d83f56-e247-48a5-adfb-eb45a2fce677"}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    socket.connect();
    socket.onConnect((_) {
      print(socket.auth.toString());
      if (socket.connected) {
        print('socket connected');
      }
    });
    roomSocket.connect();
    roomSocket.onConnect((_) {
      print("room socket " + roomSocket.connected.toString());
      roomSocket.emit('createGroup', {"test": 'test'});
      roomSocket
          .emitWithAck("getRoomsByUserUid", {"userUid": "20170928174704927015"},
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
