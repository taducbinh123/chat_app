
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/socket.dart';
import 'package:hello_world_flutter/model/messenger.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientSocketController extends GetxController {
  final Messenger messenger = new Messenger();
  final UserProvider userProvider = UserProvider();
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();

  var isTyping = false.obs;

  @override
  Future<void> onInit() async {
    await Future.delayed(Duration(seconds: 1));
    await initUser();
    await getContactList();
    clientSocketIO();
    super.onInit();
  }

  // ClientSocketController(){
  //   initUser();
  //   clientSocketIO();
  // }

  initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userUid = prefs.getString('userUid');
    print(userUid);
    var userInfo = await userProvider.getUserInfo(userUid);

    messenger.currentUser = userInfo;
  }

  getContactList() async {
    messenger.contactList.value =
        await contactViewProvider.getEmployee(messenger.currentUser?.USER_UID);
    socketProvider.getOnlineMember(messenger.contactList.value);
  }

  clientSocketIO() {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    // roomSocket.on('connect', (data) => print("Connected"));
    roomSocket.connect();

    var roomMessage;
    var index;
    Room rm;
    // roomSocket.onConnect((data) => {
    roomSocket.on(
        "server_send_message",
        (data) => {
              rm = Room.fromJson(data as Map<dynamic, dynamic>),
              roomMessage = messenger.listRoom.value
                  .firstWhere((element) => element.roomUid == rm.roomUid),
              if (roomMessage != null)
                {
                  index = messenger.listRoom.value.indexOf(roomMessage),
                  if (index > 0)
                    {
                      messenger.listRoom.value.removeAt(index),
                      messenger.listRoom.value.insert(0, rm),
                      messenger.listRoom.refresh(),
                    },
                  if (rm.roomUid == messenger.selectedRoom?.roomUid)
                    {
                      messenger.chatList.insert(0, rm.messageModel),
                      messenger.chatList.refresh(),
                      print("ok ---------------------"),
                      print(data),
                      print(messenger.chatList),
                    }
                }
              else
                {
                  messenger.listRoom.value.add(rm),
                  messenger.listRoom.refresh(),
                }
            });
    roomSocket.on(
        "memberJoinRoom",
        (data) => {
              print("memberJoinRoom----------------------"),
              rm = Room.fromJson(data as Map<dynamic, dynamic>),
              messenger.listRoom.value.insert(0, rm),
              messenger.listRoom.refresh(),
            });
    // });

    roomSocket.on(
        "typing_check",
        (data) => {
              if (data &&
                  data["isTyping"] &&
                  messenger.selectedRoom?.roomUid == data["ROOM_UID"])
                {
                  isTyping.value = true,
                }
              else
                {
                  isTyping.value = false,
                }
            });

    roomSocket.on(
        "onlineMember",
        (data) => {
              for (var i in data)
                {
                  for (var e in messenger.contactList.value)
                    {
                      if (e.USER_UID == i)
                        {
                          // print(e.USER_NM_KOR),
                          e.ONLINE_YN = 'Y',
                        }
                    }
                },
              messenger.contactList.refresh(),
            });

    roomSocket.on(
        "offlineMember",
            (data) => {
          for (var i in data)
            {
              for (var e in messenger.contactList.value)
                {
                  if (e.USER_UID == i)
                    {
                      // print(e.USER_NM_KOR),
                      e.ONLINE_YN = 'N',
                    }
                }
            },
          messenger.contactList.refresh(),
        });


    roomSocket.on("exception", (data) => print("event exception"));
    roomSocket.on("disconnect", (data) => print("Disconnect"));
  }
}
