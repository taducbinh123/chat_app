import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';
import 'package:hello_world_flutter/provider/room_chat_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomChatController extends GetxController {
  final RoomChatProvider roomChatProvider = RoomChatProvider();
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();
  TextEditingController searchController = TextEditingController();
  List<SelectCircle> listAvatarChoose = [];
  List<Employee> initData = [];
  var contactList = <Employee>[].obs;
  var state = [].obs;
  var employees = [].obs;

  getListMemberRoom(String roomUid) async {
    var list = await roomChatProvider.getMemberList(roomUid);
    await socketProvider.getOnlineMember(list);
    employees.value = list;
  }

  leaveRoom(var roomUid) async {
    await roomChatProvider.leftRoom(roomUid);
  }

  inviteMember(var roomUid, var roomName) async {
    await roomChatProvider.inviteRoom(roomUid, roomName, listContactChoose);
    await getListMemberRoom(roomUid);
  }

  initDataEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userUid = prefs.getString('userUid');
    print(userUid);
    initData = await contactViewProvider.getEmployee(userUid);
    // loại bỏ những member có trong phòng ra khỏi list contact để thao tác
    for (var element in employees) {
      for (Employee e in initData) {
        if (element.USER_UID == e.USER_UID) {
          initData.remove(e);
          break;
        }
      }
    }

    await socketProvider.getOnlineMember(initData);
    contactList.value = initData;
    resetState();
    // print(contactList.value);
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
        text: e.USER_NM_KOR,
        screen: "add",
      ));
    } else {
      listContactChoose.remove(e);
      listAvatarChoose =
          listAvatarChoose.where((element) => element.chat != e).toList();
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
      // print(contactList.value.toString());
    }
  }

  resetState() {
    state.clear();
    contactList.forEach((element) {
      state.add(State(employee: element, state: false.obs));
    });
  }
}

class State {
  final Employee employee;
  RxBool state;

  State({required this.employee, required this.state});
}
