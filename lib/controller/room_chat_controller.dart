import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/model/room.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';
import 'package:hello_world_flutter/provider/message_provider.dart';
import 'package:hello_world_flutter/provider/room_chat_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomChatController extends GetxController {
  final RoomChatProvider roomChatProvider = RoomChatProvider();

  final ContactViewProvider contactViewProvider = ContactViewProvider();
  TextEditingController searchController = TextEditingController();

  List<SelectCircle> listAvatarChoose = [];
  List<Employee> initData = [];
  var contactList = <Employee>[].obs;

  var state = [].obs;

  var employees = [].obs ;

  getListMemberRoom(String roomUid)async{
    var list = await roomChatProvider.getMemberList(roomUid);
    employees.value = list;
  }

  leaveRoom(var roomUid)async{
    await roomChatProvider.leftRoom(roomUid);
  }
  // var contactTempList = chatsData.obs;
  ContactScreenController() {
    resetState();
    initDataEmployee();
  }

  initDataEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userUid = prefs.getString('userUid');
    print(userUid);
    initData = await contactViewProvider.getEmployee(userUid);
    contactList.value = initData;
    print(contactList.value);
  }

  var listContactChoose = [].obs;
  // var listNameChoose = "".obs;

  changeState(Employee e, double screenWidth, double screenHeight) {
    // change state
    var stateChange;
    for (State element in state) {
      if (element.employee == e) {
        element.state.value = !element.state.value;
        stateChange = element;
        break;
      }
    }
    // format string name
    // listNameChoose.value = "";
    if (stateChange.state.value) {
      listContactChoose.add(e);
      listAvatarChoose.add(new SelectCircle(
          chat: e,
          height: screenWidth * 0.12,
          width: screenHeight * 0.06,
          text: e.USER_NM_KOR));
      // for (var value in listContactChoose) {
      //   print(value.USER_NM_ENG);
      //   listNameChoose.value += value.USER_NM_ENG + ", ";
      // }
      // listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      // print(listNameChoose);
    } else {
      listContactChoose.remove(e);
      listAvatarChoose =
          listAvatarChoose.where((element) => element.chat != e).toList();
      // if(listContactChoose.length !=0) {
      //   for (var value in listContactChoose) {
      //     print(value.name);
      //     listNameChoose.value += value.name + ", ";
      //   }
      //   listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      // }
      // print(listNameChoose);
    }
  }

  contactNameSearch(String name) {
    if (name.isEmpty) {
      contactList.value = initData;
    } else {
      contactList.value = initData
          .where((element) =>
          element.USER_NM_KOR.toLowerCase().contains(name.toLowerCase()))
          .toList();
      print(contactList.value.toString());
    }
  }

  resetState() {
    state.clear();
    initData.forEach((element) {
      state.add(State(employee: element, state: false.obs));
    });
  }
}

class State {
  final Employee employee;
  RxBool state;

  State({required this.employee, required this.state});
}

