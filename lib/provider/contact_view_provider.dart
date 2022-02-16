import 'dart:convert';

import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:http/http.dart' as http;

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
    return parsed.map<Employee>((json) =>Employee.fromJson(json)).toList();
  }

  Future<List<Employee>> getEmployee(String userUid) async {
    final response = await http
        .get(Uri.parse(imwareApiHost +
              '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
              userUid));

    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    //   return Album.fromJson(jsonDecode(response.body));
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to load album');
    // }
    return parseEmployees(response.body);
  }
}
