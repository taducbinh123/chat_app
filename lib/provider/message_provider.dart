import 'dart:convert';
import 'dart:convert' as convert;
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/message.dart';
import 'package:http/http.dart' as http;

class MessageProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getMessageByRoomId(String roomUid) async {
    final response = await http.get(Uri.parse(
        chatApiHost + '/api/chat/getmessageByRoomId?roomId=' + roomUid));

    List<dynamic> decodeData = convert.jsonDecode(response.body);

    return decodeData.map((e) => MessageModel.fromJson(e)).toList();
  }
}
