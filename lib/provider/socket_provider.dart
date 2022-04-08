import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends GetxController {
  var chatsDatas = [].obs;

  connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    String? userUid = prefs.getString('userUid');
    chatsDatas = List<Room>.empty().obs;
    IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token":access_token}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.connect();
    // getData(roomSocket);
    // await Future.delayed(const Duration(seconds: 1));

    roomSocket.emitWithAck(
        "getRoomsByUserUid", {"userUid": userUid},  ack: (data) {
      var result = data as List;
      for (int i = 0; i < result.length; i++) {
        Room rm = Room.fromJson(result[i] as Map<dynamic, dynamic>);
        chatsDatas.add(rm);
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    print(chatsDatas);

    roomSocket.onDisconnect((_) => print('disconnect'));
    return chatsDatas;
  }

  getLastMessage(var roomUid, var lastReadMsgId) async {
    IO.Socket roomSocket = IO.io(chatApiHost + "/chat");
    roomSocket.emit("updateLastReadMsg",
        {"roomUid": roomUid, "lastReadMsgId": lastReadMsgId});
    roomSocket.on("updateLastReadMsg", (data) => print("done"));
  }

  getOnlineMember(var listMember) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

    IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": access_token}
    });
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.connect();
    roomSocket.emit("getUserOnline");
    roomSocket.on(
        "onlineMember",
        (data) => {
              for (var i in data)
                {
                  for (var e in listMember)
                    {
                      if (e.USER_UID == i)
                        {
                          // print(e.USER_NM_KOR),
                          e.ONLINE_YN = 'Y',
                        }
                    }
                }
            });
  }

  getOfflineMember() {}


}
