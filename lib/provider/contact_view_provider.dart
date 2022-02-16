import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/model/employee.dart';

class ContactViewProvider extends GetConnect {
  Future<Response<List<Employee>>> getEmployee(String userUid) {
    print(imwareApiHost +
        '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
        userUid);
    return get<List<Employee>>(imwareApiHost +
        '/chatuser/chatuser_0101/getListFrd.ajax?USER_UID=' +
        userUid);
  }
}
