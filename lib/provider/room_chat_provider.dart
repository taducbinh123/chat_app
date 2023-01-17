import 'dart:convert';
import 'dart:convert' as convert;
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/model/file_multimedia.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AMES/features/authentication/authentication_service.dart';

import '../model/room.dart';
import '../view/add_room_member/add_room_member_screen.dart';

class RoomChatProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getMemberList(String roomUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

    final response = await http.get(
        Uri.parse(chatApiHost + '/api/chat/getMemberList/' + roomUid),
        headers: {"Authorization": "Bearer " + access_token!});
    List<dynamic> decodeData = new List.empty();

    try {
      decodeData = convert.jsonDecode(response.body);
    } catch (e) {}

    return decodeData.map((e) => Employee.fromJson(e)).toList();
  }

  leftRoom(String roomUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };

    roomSocket.emit("leaveRoom", {"ROOM_UID": roomUid, "USER_UID": userUid});
  }

  inviteRoom(String roomUid, String roomName, var memberList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    // print("room socket " + roomSocket.connected.toString());
    roomSocket.emit("inviteMember", {
      "ROOM_UID": roomUid,
      "userUid": userUid,
      "roomName": roomName,
      "memberList": memberList
    });
  }

  changeRoomName(String roomUid, String roomName, String roomType) async {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.emit("changeRoomName",
        {"ROOM_UID": roomUid, "ROOM_NM": roomName, "ROOM_TYPE": roomType});
    await Future.delayed(const Duration(seconds: 1));
  }

  getData() async {
    clientSocketController.messenger.listRoom.clear();
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
      clientSocketController.messenger.listRoom.value.clear();
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
        print(rm);
        clientSocketController.messenger.listRoom.value.add(rm);
        clientSocketController.messenger.listRoom.refresh();
      });
      clientSocketController.messenger.listRoomFlag.value =
          clientSocketController.messenger.listRoom.value;
      clientSocketController.updateNotification();
    });
  }

  getAttachmentInRoom(String roomUid, var type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    // type 3: photo, # : Other File
    final response = await http.get(
        Uri.parse(chatApiHost +
            '/api/chat/getAttachmentInRoom/' +
            roomUid +
            '/' +
            type.toString()),
        headers: {"Authorization": "Bearer " + access_token!});
    List<dynamic> decodeData = new List.empty();
    if (response.statusCode == 200) {
      // print("---------------------------file-------------------------------");
      // print(response.body);
      decodeData = convert.jsonDecode(response.body);
    } else {
      throw Exception('Failed to load message');
    }
    return decodeData.map((e) => FileModel.fromJson(e)).toList();
  }
}
