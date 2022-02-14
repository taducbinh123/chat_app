import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  var state = false.obs;

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
    // const URI_SERVER="wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self";
    // IO.Socket socket = IO.io(
    //     URI_SERVER,
    //     IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
    //         .setExtraHeaders({'foo': 'bar'}) // optional
    //         .build());
    //
    // socket.onConnect((_) {
    //   print('connect1');
    // });
    // // Replace 'onConnect' with any of the above events.
    // socket.onConnect((_) {
    //   print('connect');
    // });
    // socket.on('connect_error', (data) {
    //   print(data);
    // });
    // socket.onDisconnect((_) => print('disconnect'));

    IO.Socket socket = IO.io("http://192.168.0.43:8800", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    IO.Socket roomSocket =
        IO.io("http://192.168.0.43:8800" + "/room", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((_) {
      if (socket.connected) {
        print('socket connected');
      }
    });
    socket.on('connect', (_) => print(socket.connected));
    print("isConnected to " + socket.connected.toString());
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    roomSocket.connect();
    socket.onConnect((data) {
      print('connect');

    });
    roomSocket.emit('createGroup', { test: 'test' });
    socket.on('create', (data) => {print(data)});
    socket.on('exception', (data) => print("event exception" + data));
    socket.on('disconnect', (data) => print("Disconnected" + data));

  }

  addChat(var chat) {
    chatTempList.add(chat);
  }

  onPress(var check) {
    state.value = check;
  }
}
