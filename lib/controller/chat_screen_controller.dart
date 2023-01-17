import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/model/room.dart';
import 'package:AMES/provider/message_provider.dart';
import 'package:AMES/provider/socket_provider.dart';
import 'package:AMES/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../features/authentication/authentication_controller.dart';
import '../features/authentication/authentication_service.dart';

class ChatScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final SocketProvider _socketProvider = SocketProvider();
  final UserProvider userProvider = UserProvider();

  final ClientSocketController clientSocketController = Get.find();
  final AuthenticationController authenticationController = Get.find();

  String userUid = "";

  String access_token = "";
  var state = false.obs;
  var test = "".obs;
  var page = "null";
  var chatsData = [];
  TextEditingController searchController = TextEditingController();
  var chatTempList = [].obs;

  var elements;
  final box = GetStorage();

  var inProcess = false.obs;
  var reLoadListRoom = false.obs;
  var loadMessageInRoom = false.obs;
  var isTyping = false.obs;

  @override
  void onInit() {
    // initDataRoom();
    print(isTyping);
    super.onInit();
  }

  @override
  void onReady() {
    // initDataRoom();
    super.onReady();
  }

  ChatScreenController() {
    // initDataRoom();
  }

  initDataRoom() async {
    reLoadListRoom.value = true;

    chatTempList.clear();
    clientSocketController.messenger.listRoom.value.clear();
    clientSocketController.messenger.listRoomFlag.value.clear();
    await getData();
    await clientSocketController
        .getOnlineMember(clientSocketController.messenger.contactList.value);
    // print(clientSocketController.messenger.listRoom.value);
  }

  Future<void> pullRefresh() async {
    clientSocketController.messenger.listRoom.value.clear();
    reLoadListRoom.value = true;
    await Future.delayed(Duration(seconds: 1));
    initDataRoom();
    // reLoadListRoom.value = false;
    clientSocketController.messenger.listRoom.refresh();
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  getData() async {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.connect();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('userUid');
    // print("------------------//-------------------");
    // print(userUid);
    roomSocket.emitWithAck("getRoomsByUserUid", {"userUid": userUid},
        ack: (data) {
      // print(data);
      var result = data as List;
      result.forEach((element) {
        Room rm = Room.fromJson(element as Map<dynamic, dynamic>);

        if (rm.messageModel?.SEND_DATE != null) {
          DateTime sendDate =
              DateTime.parse(rm.messageModel?.SEND_DATE.toString() ?? "")
                  .toLocal();
          Duration timeAgo = DateTime.now().difference(sendDate);
          var time = DateTime.now().subtract(timeAgo);
          var r = timeago.format(time);
          rm.timeLastMessageDisplay = r;
        }

        if (rm.roomType == "IN_CONTACT_ROOM") {
          var uid =
              rm.memberUidList?.firstWhere((element) => userUid != element);
          rm.userUidContact = uid;
          // print(uid);
        }
        // print(rm);
        clientSocketController.messenger.listRoom.value.add(rm);
        clientSocketController.messenger.listRoom.refresh();
      });
      clientSocketController.messenger.listRoomFlag.value =
          clientSocketController.messenger.listRoom.value;
      clientSocketController.updateNotification();
      reLoadListRoom.value = false;
      // print("------------------------------------------------------------");
      // print(clientSocketController.messenger.totalRoomUnReadMessage.value);
    });
  }

  chatNameSearch(String name) async {
    clientSocketController.messenger.listRoom.value =
        clientSocketController.messenger.listRoomFlag.value;
    if (name.isEmpty) {
      clientSocketController.messenger.listRoom.value =
          clientSocketController.messenger.listRoom.value;
    } else {
      clientSocketController.messenger.listRoom.value = clientSocketController
          .messenger.listRoom.value
          .where((element) => element.roomDefaultName
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    }
  }

  updateLastReadMessage(var chatRoom) {
    _socketProvider.updateLastReadMessage(
        chatRoom.roomUid, chatRoom.lastMsgUid);
  }

  messageConfirm(var action, var numberMesageUnRead) {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };

    var roomUid = clientSocketController.messenger.selectedRoom?.roomUid;

    if (action == "open" && numberMesageUnRead != 0) {
      // roomSocket.emit("messageConfirm",{"roomUid": roomUid, "userUid": userUid});
      changeNumberMessageUnRead(roomUid);
    } else if (action == "typing") {
      var listMessage = clientSocketController.messenger.chatList.value
          .where((element) => element.IS_READ == 0)
          .toList();
      if (listMessage.length > 0) {
        var listUid = "";
        for (int i = 0; i < listMessage.length; i++) {
          listUid += listMessage[i].MSG_UID + ",";
        }
        listUid.substring(0, listUid.length - 2);
        print("list uid message " + listUid);
        // roomSocket.emit("messageConfirm",{"roomUid": roomUid, "userUid": userUid, "msgList": listMessage});
        changeNumberMessageUnRead(roomUid);
      }
    }
  }

  changeNumberMessageUnRead(var roomUid) {
    clientSocketController.messenger.selectedRoom?.unReadMsgCount = 0;
    for (int i = 0;
        i < clientSocketController.messenger.listRoom.value.length;
        i++) {
      if (clientSocketController.messenger.listRoom.value[i].roomUid ==
          roomUid) {
        clientSocketController.messenger.listRoom[i].unReadMsgCount = 0;
        clientSocketController.messenger.listRoom.refresh();
        clientSocketController.messenger.listRoomFlag.value =
            clientSocketController.messenger.listRoom.value;
      }
    }
    clientSocketController.updateNotification();
    // print("------------------------------------------------------------");
    // print(clientSocketController.messenger.totalRoomUnReadMessage.value);
  }

  changeElements() {
    if (clientSocketController.messenger.selectedRoom?.roomType ==
        "IN_CHATROOM") {
      elements = [
        {'name': 'Add Member', 'group': 'Room Info'},
        {'name': 'Room Member', 'group': 'Room Info'},
        {'name': 'Files', 'group': 'Room Info'},
        {'name': 'Gallery', 'group': 'Room Info'},
        {'name': 'Leave Room', 'group': 'Privacy'},
        {'name': 'Change Room Name', 'group': 'Privacy'},
      ];
    } else {
      elements = [
        // {'name': 'Room Member', 'group': 'Room Info'},
        {'name': 'Files', 'group': 'Room Info'},
        {'name': 'Gallery', 'group': 'Room Info'},
      ];
    }
  }

  onPress(var check) {
    state.value = check;
  }

  checkExistRoom(var employee, var userUid, var screen) {
    var result = {"flag": false, "room": ""};
    if (screen == "contact") {
      clientSocketController.messenger.listRoom.forEach((element) => {
            if (element.memberUidList.length == 2)
              {
                if (element.memberUidList.indexWhere((e) => e == userUid) !=
                        -1 &&
                    element.memberUidList
                            .indexWhere((e) => e == employee.USER_UID) !=
                        -1 &&
                    element.roomType == "IN_CONTACT_ROOM")
                  {
                    result["flag"] = true,
                    result["room"] = element,
                  }
              }
          });
    }

    return result;
  }

  createChatroom(List employees, var screen) async {
    inProcess.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userUid = prefs.getString('userUid');
    if (employees.length == 1 && screen == "contact") {
      var result = checkExistRoom(employees[0],
          clientSocketController.messenger.currentUser.value.USER_UID, screen);
      if (result["flag"] == true) {
        inProcess.value = false;
        await getMessageByRoomId(result["room"], 1);
        return;
      }
    }

    employees.sort(
        (a, b) => a.USER_NM_KOR.toString().compareTo(b.USER_NM_KOR.toString()));
    // sx theo tên
    employees.sort((a, b) => a.POSITION_ORDER ?? 0 - b.POSITION_ORDER ?? 0);
    // sx theo vị trí

    var memberList =
        employees.map((e) => e.USER_UID).toList(); // get user_uid list
    // print(memberList);
    // get user_uid của người tạo
    memberList.insert(0, userUid);

    var roomName = employees.map((e) => e.USER_NM_KOR).join(', ');

    var userInfo = clientSocketController.messenger.currentUser.value;
    // print(userInfo);
    if (employees.length > 1) {
      var name = userInfo.USER_NM_KOR;
      roomName += ", " + name;
    }
    var roomType = screen == "contact" ? "IN_CONTACT_ROOM" : "IN_CHATROOM";
    // inProcess.value = true;
    if (screen == "contact") {
      Get.toNamed(messagescreen);
    } else {
      Get.offAndToNamed(messagescreen);
    }

    try {
      // await userProvider.createChatroom(roomName, memberList, roomType);

      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
      // print("room socket " + roomSocket.connected.toString());
      roomSocket.emitWithAck("createChatroom", {
        "roomName": roomName,
        "memberList": memberList,
        "type": roomType
      }, ack: (data) async {
        // print(data);
        if (data != null) {
          if (data['STATUS'] == 'ROOM_EXIST') {
            await initDataRoom();
            await Future.delayed(const Duration(seconds: 2));
            clientSocketController.messenger.selectedRoom =
                clientSocketController.messenger.listRoom.value.firstWhere(
                    (element) => element.roomUid == data['ROOM_UID']);
            clientSocketController.messenger.roomNameSelected.value =
                clientSocketController
                        .messenger.selectedRoom?.roomDefaultName ??
                    "";
            changeElements();
            updateLastReadMessage(
                clientSocketController.messenger.selectedRoom);
            clientSocketController.messenger.chatList.value.clear();
            clientSocketController.messenger.chatList.refresh();
            inProcess.value = false;
          }
          if (data['STATUS'] == 'NEW_ROOM') {
            await initDataRoom();
            await Future.delayed(const Duration(seconds: 2));

            clientSocketController.messenger.selectedRoom =
                clientSocketController.messenger.listRoom.value[0];
            clientSocketController.messenger.roomNameSelected.value =
                clientSocketController
                        .messenger.selectedRoom?.roomDefaultName ??
                    "";
            changeElements();
            updateLastReadMessage(
                clientSocketController.messenger.selectedRoom);
            clientSocketController.messenger.chatList.value.clear();
            clientSocketController.messenger.chatList.refresh();
            inProcess.value = false;
          }
          if (data['STATUS'] == 'Error') {
            Get.back();
            inProcess.value = false;
            return;
          }
        } else {
          Get.back();
          inProcess.value = false;
          return;
        }
      });
    } catch (e) {
      Get.back();
      inProcess.value = false;
      return;
    }

  }

  getMessageByRoomId(var chatRoom, var action) async {
    // clientSocketController.messenger.listRoom.value.clear();
    loadMessageInRoom.value = true;
    // print("-------------load message------------");
    // print(loadMessageInRoom.value);
    clientSocketController.messenger.selectedRoom = chatRoom;
    clientSocketController.messenger.roomNameSelected.value =
        chatRoom.roomDefaultName;
    if (action == 0) {
      messageConfirm("open",
          clientSocketController.messenger.selectedRoom?.unReadMsgCount);
      Get.offAndToNamed(messagescreen);
      // print("----------------OK----------------");
    } else {
      messageConfirm("open",
          clientSocketController.messenger.selectedRoom?.unReadMsgCount);
      Get.toNamed(messagescreen);
      // print("----------------OK----------------");
    }
    changeElements();
    updateLastReadMessage(chatRoom);
    await messageProvider.getMessageByRoomId(chatRoom.roomUid, page);
    loadMessageInRoom.value = false;
    // var listMessage = clientSocketController.messenger.chatList.value;
    // print("roomUid    " + chatRoom.roomUid);
  }

  String displayMessageCall(var role, var status){
    if(role == 0){
      if(status == 2){
        return "Bạn đã gọi 1 cuộc gọi";
      }
      if(status == 3){
        return "Bạn đã gọi 1 cuộc gọi";
      }
      if(status == 4){
        return "Bạn đã gọi 1 cuộc gọi";
      }
    }else{
      if(status == 2){
        return "Bạn đã nhận 1 cuộc gọi";
      }
      if(status == 3){
        return "Bạn đã từ chối 1 cuộc gọi";
      }
      if(status == 4){
        return "Bạn đã lỡ 1 cuộc gọi";
      }
    }
    return "";
  }

  Widget displayIconMessageCall(var role, var status){
    if(role == 0){
      if(status == 2){
        return Icon(Icons.phone_in_talk);
      }
      if(status == 3){
        return Icon(Icons.phone_in_talk);
      }
      if(status == 4){
        return Icon(Icons.phone_in_talk);
      }
    }else{
      if(status == 2){
        return Icon(Icons.phone_callback_sharp);
      }
      if(status == 3){
        return Icon(Icons.cancel);
      }
      if(status == 4){
        return Icon(Icons.call_missed, color: Colors.red);
      }
    }
    return SizedBox();
  }

  checkFileExtnAudio(var fileExtn){
    if(fileExtn!=null){
      return fileExtn.toString().contains("audio");
    }
    return false;
  }

}
