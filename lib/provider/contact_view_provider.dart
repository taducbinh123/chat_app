import 'dart:convert';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ContactViewProvider {
  // Future<Response<List<Employee>>> getEmployee(String userUid) {
  //   print(imwareApiHost +
  //       '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
  //       userUid);
  //   return get<List<Employee>>(imwareApiHost +
  //       '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
  //       userUid);
  // }

  List<Employee> parseEmployees(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getEmployee(String userUid) async {
    final response = await http.get(Uri.parse(imwareApiHost +
        '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
        userUid));

    List<dynamic> decodeData = convert.jsonDecode(utf8convert(response.body));

    return decodeData.map((e) => Employee.fromJson(e)).toList();
  }
}
