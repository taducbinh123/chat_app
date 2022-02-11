import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  var state = false.obs;
  var EVENTS = [
    'connect',
    'connect_error',
    'connect_timeout',
    'connecting',
    'disconnect',
    'error',
    'reconnect',
    'reconnect_attempt',
    'reconnect_failed',
    'reconnect_error',
    'reconnecting',
    'ping',
    'pong'
  ];
  var test = "".obs;

  TextEditingController searchController = TextEditingController();
  var chatTempList = chatsData.obs;
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

  @override
  void onInit() {
    connect();
    super.onInit();
  }

  void connect() {

    IO.Socket socket = IO.io("http://localhost:8800/socket.io/",<String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    }
    );
    IO.Socket roomSocket = IO.io("http://localhost:8800"+"/room",<String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    roomSocket.connect();
    socket.onConnect((data) {
      print('connect');

    });
    roomSocket.emit('createGroup', { test: 'test' });
    socket.on('create', (data) => {print(data)});
    socket.on('exception', (data) => print("event exception" + data));
    socket.on('disconnect', (data) => print("Disconnected" + data));
    print("isConnected to "+socket.connected.toString());
  }

  addChat(var chat) {
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }
}
