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

  // var listContact = [].obs;
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
    await socketProvider.getOnlineMember(messenger.contactList.value);

    messenger.contactListFlag.value = messenger.contactList.value;
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
                      messenger.listRoomFlag.value = messenger.listRoom.value,
                    },
                  if (rm.roomUid == messenger.selectedRoom?.roomUid)
                    {
                      messenger.chatList.insert(0, rm.messageModel),
                      messenger.chatList.refresh(),
                      // print("ok ---------------------"),
                      // print(data),
                      // print(messenger.chatList),
                    }
                }
              else
                {
                  messenger.listRoom.value.add(rm),
                  messenger.listRoom.refresh(),
                  messenger.listRoomFlag.value = messenger.listRoom.value,
                }
            });
    roomSocket.on(
        "memberJoinRoom",
        (data) => {
              print("memberJoinRoom----------------------"),
              rm = Room.fromJson(data as Map<dynamic, dynamic>),
              messenger.listRoom.value.insert(0, rm),
              messenger.listRoom.refresh(),
              messenger.listRoomFlag.value = messenger.listRoom.value,
            });
    // });

    roomSocket.on(
        "typing_check",
        (data) => {
              if (data != null &&
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
    var list;
    var empContact;
    roomSocket.on(
        "onlineMember",
        (data) => {
              if (data != null)
                {
                  print(data),
                  for (var i in data)
                    {
                      if(i != messenger.currentUser?.USER_UID){
                        list = messenger.listRoom.value.where((element) => element.memberUidList.contains(i)).toList(),
                        if( list!=null && list.length>0){
                          for(var item in list){
                            messenger.listRoom.value.firstWhere((element) => element.roomUid == item.roomUid).isOnline = true,
                          }
                        }
                      },
                      empContact = messenger.contactList.value.firstWhereOrNull((element) => element.USER_UID == i),
                      if(empContact != null){
                        empContact.ONLINE_YN = 'Y',
                      }
                    },
                },
              messenger.contactList.refresh(),
              messenger.contactListFlag.value = messenger.contactList.value,
            });

    roomSocket.on(
        "offlineMember",
        (data) => {
              if (data != null)
                {
                  print(data),
                  messenger.contactList.value.firstWhere((element) => element.USER_UID == data).ONLINE_YN = 'N',
                },
              messenger.contactList.refresh(),
              messenger.contactListFlag.value = messenger.contactList.value,
            });

    roomSocket.on("exception", (data) => print("event exception"));
    roomSocket.on("disconnect", (data) => print("Disconnect"));
  }
}
