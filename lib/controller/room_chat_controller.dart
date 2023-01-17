import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/widgets/multi_select_circle.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/provider/contact_view_provider.dart';
import 'package:AMES/provider/room_chat_provider.dart';
import 'package:AMES/provider/socket_provider.dart';

class RoomChatController extends GetxController {
  final RoomChatProvider roomChatProvider = RoomChatProvider();
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();
  final ClientSocketController clientSocketController = Get.find();

  TextEditingController searchController = TextEditingController();
  List<SelectCircle> listAvatarChoose = [];
  var state = [].obs;
  var employees = [].obs;
  var listFile = [].obs;


  @override
  void onInit() {
    getListMemberRoom(clientSocketController.messenger.selectedRoom?.roomUid ?? "");
    resetState();
    super.onInit();
  }

  getListMemberRoom(String roomUid) async {
    var list = await roomChatProvider.getMemberList(roomUid);
    // await socketProvider.getOnlineMember(list);
    employees.value = list;
    // print("========================"+list.length.toString());

  }

  leaveRoom(var roomUid) async {
    await roomChatProvider.leftRoom(roomUid);
  }

  inviteMember(var roomUid, var roomName) async {
    await roomChatProvider.inviteRoom(roomUid, roomName, listContactChoose);
    await getListMemberRoom(roomUid);
  }

  changeRoomName(var roomUid, var roomName, var roomType) async {
    await roomChatProvider.changeRoomName(roomUid, roomName, roomType);
  }


  var listContactChoose = [].obs;
  changeState(Employee e, double screenWidth, double screenHeight) {
    // change state
    bool result = true;
    var stateChange;
    for (State element in state) {
      if (element.employee.USER_UID == e.USER_UID) {
        bool flag = true;
        for(Employee emp in employees){
          if(e.USER_UID == emp.USER_UID){
            flag = false;
            result = false;
            break;
          }
        }
        if(flag){
          element.state.value = !element.state.value;
          stateChange = element;
          break;
        }
      }
    }

    if (stateChange!=null && stateChange.state.value) {
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

    return result;
  }

  contactNameSearch(String name) async {
    clientSocketController.messenger.contactList.value = clientSocketController.messenger.contactListFlag.value;
    if (name.isEmpty) {
      clientSocketController.messenger.contactList.value = clientSocketController.messenger.contactList.value;
    } else {
      clientSocketController.messenger.contactList.value = clientSocketController.messenger.contactList.value
          .where((element) =>
          element.USER_NM_KOR.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  resetState() {
    state.clear();
    clientSocketController.messenger.contactList.value.forEach((element) {
      state.add(State(employee: element, state: false.obs));
    });
  }

  getAttachmentInRoom(var type) async {
    listFile.value.clear();
    listFile.value = await roomChatProvider.getAttachmentInRoom(clientSocketController.messenger.selectedRoom?.roomUid ?? "", type);
    listFile.refresh();
  }


}

class State {
  final Employee employee;
  RxBool state;

  State({required this.employee, required this.state});
}
