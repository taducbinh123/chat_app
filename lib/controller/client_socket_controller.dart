import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/model/messenger.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientSocketController extends GetxController {
  final Messenger messenger = new Messenger();

  @override
  void onInit() {
    clientSocketIO();
    super.onInit();
  }

  clientSocketIO() {
    IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": box.read('access_token')}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.on('connect', (data) => print("Connected"));
    roomSocket.connect();

    var roomMessage;
    var index;
    roomSocket.onConnect((data) => {
          roomSocket.on(
              "server_send_message",
              (data) => {
                    roomMessage = messenger.listRoom.firstWhere(
                        (element) => element.roomUid == data.ROOM_UID),
                    if (roomMessage != null)
                      {
                        index = messenger.listRoom.indexOf(roomMessage),
                        if (index > 0)
                          {
                            messenger.listRoom.removeAt(index),
                            messenger.listRoom.insert(0, data),
                            messenger.listRoom.refresh(),
                          },
                        if (data.ROOM_UID == messenger.selectedRoom?.roomUid)
                          {
                            messenger.chatList.add(data.LAST_MSG),
                            messenger.chatList.refresh(),
                          }
                      }
                    else
                      {
                        messenger.listRoom.add(data),
                        messenger.listRoom.refresh(),
                      }
                  }),
          roomSocket.on(
              "memberJoinRoom",
              (data) => {
                    messenger.listRoom.insert(0, data),
                    messenger.listRoom.refresh(),
                  }),
        });

    roomSocket.on("exception", (data) => print("event exception"));
    roomSocket.on("disconnect", (data) => print("Disconnect"));
  }
}
