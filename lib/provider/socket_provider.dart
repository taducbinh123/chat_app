import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  connect() async {
    List<Room> chatsData = [];
    List<Room> chatsData1 = [];
    IO.Socket socket = IO.io(chatApiHost, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.io.options['extraHeaders'] = {"Content-Type": "application/json"};
    IO.Socket roomSocket = IO.io(chatApiHost + "/room", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    await socket.connect();
    socket.onConnect((_) {
      if (socket.connected) {
        print('socket connected');
      }
    });
    socket.on('connect', (_) => print(socket.connected));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    await roomSocket.connect();
    roomSocket.onConnect((data) {
      print('connect');
      roomSocket.emit('createGroup', {"test": 'test'});
      roomSocket
          .emitWithAck("getRoomsByUserUid", {"userUid": "20170928174704927015"},
              ack: (data) async {
        // print('ack $data');
        if (data != null) {
          var result = data as List;
          for (int i = 0; i < result.length; i++) {
            Room rm = await Room.fromJson(result[i] as Map<dynamic, dynamic>);
            chatsData.add(rm);
          }
          chatsData1 = await chatsData;
        } else {
          print("Null");
        }
      });
    });
    socket.on('create', (data) => {});
    socket.on('exception', (data) => print("event exception" + data));
    socket.on('disconnect', (data) => print("Disconnected" + data));
    print("tesst" + chatsData.toString());
    return chatsData;
  }
}
