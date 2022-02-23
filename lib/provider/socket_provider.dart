import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  connect() {
    List<Room> chatsData = [];
    IO.Socket socket = IO.io(chatApiHost, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": "a36c128a-c468-4bbd-a099-5470c4043870"}
    });
    socket.io.options['extraHeaders'] = {"Content-Type": "application/json"};
    IO.Socket roomSocket = IO.io(chatApiHost + "/room", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": "a36c128a-c468-4bbd-a099-5470c4043870"}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    socket.connect();
    socket.onConnect((_) {
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
