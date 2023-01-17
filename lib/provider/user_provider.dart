import 'dart:convert';

import 'package:AMES/common/constant/path.dart';
import 'package:AMES/model/employee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AMES/features/authentication/authentication_service.dart';

class UserProvider {

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }


  getUserInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.get(Uri.parse(imwareApiHost +
        '/api/userInfo/getUserInfo' ),
        headers: {
          'Authorization': 'Bearer ' + accessToken!,
          'Content-type': 'application/json',
        });
    final Map<String, dynamic> data = jsonDecode(utf8convert(response.body));
    if(response.statusCode == 200) return Employee.fromJson(data);
    else {
      print("Failed to load userInfo");
      print(response.body);
      throw Exception("Failed to load userInfo");
    }
  }

  createChatroom(var roomName, var memberList, var roomType)async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      roomSocket.io.options['extraHeaders'] = {
        "Content-Type": "application/json"
      };
        roomSocket.emit("createChatroom", {"roomName":roomName,"memberList":memberList,"type": roomType});
      await Future.delayed(const Duration(seconds: 1));
  }

}
