import 'dart:convert';
import 'dart:convert' as convert;
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/socket.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoomChatProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getMemberList(String roomUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

    final response = await http.get(
        Uri.parse(chatApiHost +
            '/api/chat/getMemberList/' +roomUid ),
        headers: {"Authorization": "Bearer " + access_token!});
    print(response.body);
    List<dynamic> decodeData = new List.empty();

    try{
      decodeData = convert.jsonDecode(response.body);
    }catch(e){

    }

    return decodeData.map((e) => Employee.fromJson(e)).toList();
  }

  leftRoom(String roomUid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");
    String? access_token = prefs.getString('access_token');

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    // roomSocket.connect();
    // roomSocket.onConnect((_) {
      print("room socket " + roomSocket.connected.toString());
      roomSocket.emit("leaveRoom", {"ROOM_UID":roomUid, "USER_UID":userUid});
    // });
    await Future.delayed(const Duration(seconds: 1));
  }

  inviteRoom(String roomUid,String roomName, var memberList) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("userUid");
    String? access_token = prefs.getString('access_token');

    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    // roomSocket.connect();
    // roomSocket.onConnect((_) {
      print("room socket " + roomSocket.connected.toString());
      roomSocket.emit("inviteMember", {"ROOM_UID":roomUid, "userUid":userUid, "roomName": roomName, "memberList":memberList});
    // });
  }
}
