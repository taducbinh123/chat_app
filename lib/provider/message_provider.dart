import 'dart:convert';
import 'dart:convert' as convert;
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getMessageByRoomId(String roomUid, String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

    final response = await http.get(
        Uri.parse(chatApiHost +
            '/api/chat/getmessageByRoomId?roomId=' +
            roomUid +
            "&page=" +
            page),
        headers: {"Authorization": "Bearer " + access_token!});
    print(chatApiHost +
        '/api/chat/getmessageByRoomId?roomId=' +
        roomUid +
        "&page=" +
        page);
    List<dynamic> decodeData;

    if (response.statusCode == 200) {
      print(response.body.toString());
      Map<String, dynamic> map = json.decode(response.body);
      decodeData = map["rows"];
      print(map["pageState"]);
      prefs.setString("pageState", map["pageState"].toString());
    } else {
      print(response.body.toString());
      throw Exception('Failed to load message');
    }

    return decodeData.map((e) => MessageModel.fromJson(e)).toList();
  }
}
