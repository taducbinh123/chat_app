import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:hello_world_flutter/model/room.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ChatScreenRepos extends GetxService {
  List<Room> getRoom();
}

class ChatScreenService extends ChatScreenRepos {
  @override
  List<Room> getRoom() {
    List<Room> rooms = [];
    IO.Socket socket = IO.io("http://10.0.2.2:8800", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.io.options['extraHeaders'] = {"Content-Type": "application/json"};
    IO.Socket roomSocket =
        IO.io("http://10.0.2.2:8800" + "/room", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
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
    socket.on('connect', (_) => print(socket.connected));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    roomSocket.connect();
    roomSocket.onConnect((data) {
      print('connect');
      roomSocket.emit('createGroup', {"test": 'test'});
      roomSocket
          .emitWithAck("getRoomsByUserUid", {"userUid": "20170928174704927015"},
              ack: (data) {
        // print('ack $data');
        if (data != null) {
          var result = data as List;
          print(data[0]);
          for (int i = 0; i < result.length; i++) {
            Room rm = Room.fromJson(result[i] as Map<dynamic, dynamic>);
            rooms.add(rm);
          }
        } else {
          print("Null");
        }
      });
    });
    socket.on('create', (data) => {});
    socket.on('exception', (data) => print("event exception" + data));
    socket.on('disconnect', (data) => print("Disconnected" + data));
    return rooms;
  }
}
