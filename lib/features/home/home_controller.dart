import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:AMES/common/constant/path.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:get/get.dart';
import 'package:AMES/features/authentication/authentication.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();
  late ClientSocketController clientSocketController;
  var isStop = true;

  @override
  void onInit() {
    // TODO: implement onInit
    // if (_authenticationController is Authenticated) {
    clientSocketController = Get.find();
    // }
    isStop = true;
    super.onInit();
  }

  var username = "";

  void signOut() {
    final LoginController loginController = Get.put(LoginController());
    username = "";
    loginController.loginStateStream.value = LoginState();
    _authenticationController.signOut();
  }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

  Future<String> fetchEmp(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://backend.atwom.com.vn/api/sys/sys0102/find?USER_ID=' +
          userId),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization':
            'Bearer ' + preferences.getString('access_token').toString(),
      },
    );

    if (response.statusCode == 200) {
      var jsonlist = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonlist != null) {
        return jsonlist[0]['imgPath'].toString();
      }
      return jsonlist[0]['imgPath'].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // print(response.body);
      throw Exception('Failed to load album');
    }
  }

  Future<String> fetchUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://backend.atwom.com.vn/api/sys/sys0102/find?USER_ID=' +
          preferences.getString("username").toString()),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization':
            'Bearer ' + preferences.getString('access_token').toString(),
      },
    );

    if (response.statusCode == 200) {
      var jsonlist = jsonDecode(utf8.decode(response.bodyBytes));
      // print(response.body);
      // print(jsonlist);
      if (jsonlist != null) {
        return jsonlist[0]['imgPath'].toString();
      }
      return jsonlist[0]['imgPath'].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // print(response.body);
      throw Exception('Failed to load album');
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username")!;
    // return username;
  }

  uploadFile(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');
    var stream = new http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    var headers = {
      'Authorization': 'Bearer ' + access_token!
    }; // remove headers if not wanted
    var request = http.MultipartRequest(
        'POST', Uri.parse(imwareApiHost + '/api/sys/sys0105/uploadAvatar/'));
    var mimeType = lookupMimeType(file.path);
    var parts = mimeType!.split('/');
    var prefix = parts[0].trim(); // prefix: "date"
    var dat = parts.sublist(1).join('/').trim();
    // print(prefix+dat);
    request.files.add(await http.MultipartFile('file', stream, length,
        contentType: new MediaType(prefix, dat),
        filename: basename(file.path))); // file you want to upload
    request.headers.addAll(headers);
    request.fields['userId'] =
        clientSocketController.messenger.currentUser.value.USER_ID;
    request.fields['position'] = "1";
    request.fields['atchFleSeq'] =
        clientSocketController.messenger.currentUser.value.USER_IMG ??
            ""; // imgPath
    // print("------------------------------------------------");
    // print(request.url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // print("--------------------200----------------------");
      // print(response);
      var body = json.decode(await response.stream.bytesToString());
      // print(body);
      fetchUser();
      return true;
    } else {
      // print("--------------------------/////----------------------");
      print(response.statusCode);
      return false;
    }
  }
}
