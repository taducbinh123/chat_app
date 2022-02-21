import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {

  final MessageProvider messageProvider = MessageProvider();

  var state = false.obs;
  var test = "".obs;
  var chatsData = [].obs;
  TextEditingController searchController = TextEditingController();
  var chatTempList = [].obs;

  @override
  void onInit() {
    connect();
    super.onInit();
  }

  connect() async {
    IO.Socket socket = IO.io(chatApiHost, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.io.options['extraHeaders'] = {"Content-Type": "application/json"};
    IO.Socket roomSocket =
        IO.io(chatApiHost + "/room", <String, dynamic>{
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
            chatsData.add(rm);
          }
          chatTempList = chatsData;
        } else {
          print("Null");
        }
      });
    });
    socket.on('create', (data) => {});
    socket.on('exception', (data) => print("event exception" + data));
    socket.on('disconnect', (data) => print("Disconnected" + data));
  }

  chatNameSearch(String name) {
    if (name.isEmpty) {
      chatTempList.value = chatsData;
    } else {
      chatTempList.value = chatsData
          .where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  getMessageByRoomId(var chatRoom) async {
    // print(chatRoom);
    print(chatRoom.roomUid);
    var listMessage = await messageProvider.getMessageByRoomId(chatRoom.roomUid);
    print(listMessage);
    Get.toNamed(messagescreen, arguments: {
      "room": chatRoom,
      "data": listMessage
    });
  }

  addChat(var chat) {
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }
}
