import 'dart:convert';
import 'dart:io';
import 'package:AMES/common/constant/path.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:AMES/features/authentication/authentication_service.dart';

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
        'POST', Uri.parse(chatApiHost + '/api/chat/upload'));
    var mimeType = lookupMimeType(file.path);
    var parts = mimeType!.split('/');
    var prefix = parts[0].trim(); // prefix: "date"
    var dat = parts.sublist(1).join('/').trim();
    // print(prefix+dat);
    request.files.add(await http.MultipartFile('file', stream, length,
        contentType: new MediaType(prefix, dat),
        filename: basename(file.path))); // file you want to upload
    request.headers.addAll(headers);
    request.fields['ROOM_UID'] = data['ROOM_UID'];
    request.fields['USER_UID'] = data['USER_UID'];
    // print("------------------------------------------------");
    // print(request.url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      var body = json.decode(await response.stream.bytesToString());
      body['UID_TIMESTAMP'] = DateTime.now().millisecondsSinceEpoch.toString();
      // print(body);
      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
      roomSocket.emitWithAck("pingMsgAttachment", {body});
      // print(body);
      return true;
    } else {
      // print("--------------------------/////----------------------");
      var body = json.decode(await response.stream.bytesToString());
      body['UID_TIMESTAMP'] = DateTime.now().millisecondsSinceEpoch.toString();
      // print(body);
      // print(response.statusCode);

      return false;
    }
  }
}
