import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import '../common/constant/path.dart';
import '../common/constant/socket.dart';

class FileProvider {
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  ConvertFileToCast(data) {
    List<int> list = data.cast();
    return list;
  }

  var page = "";
  final box = GetStorage();
  var list = [].obs;

  uploadFile(File file, var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    var stream = new http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    var headers = {
      'Authorization': 'Bearer ' + access_token!
    }; // remove headers if not wanted
    var request = http.MultipartRequest(
        'POST', Uri.parse(chatApiHost + '/api/chat/upload')); // your server url
    request.files.add(await http.MultipartFile('file', stream, length,
        filename: basename(file.path))); // file you want to upload
    request.headers.addAll(headers);
    request.fields['ROOM_UID'] = data['ROOM_UID'];
    request.fields['USER_UID'] = data['USER_UID'];
    print(data['ROOM_UID']);
    print(data['USER_UID']);
    print("------------------------------------------------");
    print(request.url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      var body = json.decode(await response.stream.bytesToString());
      print(body);
      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
      // roomSocket.connect();
      // roomSocket.onConnect((_) {
      roomSocket
          .emitWithAck("pingMsgAttachment", {body});
      print(body);
      return true;
    } else {
      print("--------------------------/////----------------------");
      print(response.statusCode);
      return false;
    }
  }
}
// var response = await request.send();
// if (response.statusCode == 200) {
//   print(response.body.toString());
//
//
// sendMessage(String roomUid, String msgContent) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userUid = prefs.getString("userUid");
//   String? access_token = prefs.getString('access_token');
//
//   roomSocket.io.options['extraHeaders'] = {
//     "Content-Type": "application/json"
//   };
//   // roomSocket.connect();
//   // roomSocket.onConnect((_) {
//   roomSocket.emit("sendMessage", {
//     "ROOM_UID": roomUid,
//     "USER_UID": userUid,
//     "MSG_CONT": msgContent,
//     "MSG_TYPE_CODE": "TEXT",
//   });
//   // });
//   print(list.value);
// }
