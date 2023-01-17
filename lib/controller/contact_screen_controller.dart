import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:AMES/common/widgets/multi_select_circle.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/provider/contact_view_provider.dart';
import 'package:AMES/provider/socket_provider.dart';

class ContactScreenController extends GetxController {
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();
  final ClientSocketController clientSocketController = Get.find();

  TextEditingController searchController = TextEditingController();

  List<SelectCircle> listAvatarChoose = [];

  var state = [].obs;
  var reLoadContact = false.obs;

  ContactScreenController() {
    // resetState();
    // initDataEmployee();
  }

  @override
  void onInit() {
    resetState();
    // print("oke");
    clientSocketController.getContactList();
    super.onInit();
  }

  var listContactChoose = [].obs;

  Future<void> pullRefresh() async {
    clientSocketController.messenger.contactList.value.clear();
    reLoadContact.value = true;
    await Future.delayed(Duration(seconds: 1));
    clientSocketController.loadContactList();
    reLoadContact.value = false;
    clientSocketController.messenger.contactList.refresh();
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  changeState(Employee e, double screenWidth, double screenHeight) {
    // change state
    bool result = true;
    var stateChange;
    if (e.USER_UID ==
        clientSocketController.messenger.currentUser.value.USER_UID)
      return false;
    for (State element in state) {
      if (element.employee.USER_UID == e.USER_UID &&
          e.USER_UID !=
              clientSocketController.messenger.currentUser.value.USER_UID) {
        element.state.value = !element.state.value;
        stateChange = element;
        break;
      }
    }

    if (stateChange != null && stateChange.state.value) {
      listContactChoose.add(e);
      listAvatarChoose.add(new SelectCircle(
          chat: e,
          height: screenWidth * 0.12,
          width: screenHeight * 0.06,
          text: e.USER_NM_KOR));
    } else {
      listContactChoose.remove(e);
      listAvatarChoose =
          listAvatarChoose.where((element) => element.chat != e).toList();
    }
    return result;
  }

  contactNameSearch(String name) async {
    clientSocketController.messenger.contactList.value =
        clientSocketController.messenger.contactListFlag.value;
    if (name.isEmpty) {
      clientSocketController.messenger.contactList.value =
          clientSocketController.messenger.contactList.value;
    } else {
      clientSocketController.messenger.contactList.value =
          clientSocketController.messenger.contactList.value
              .where((element) => element.USER_NM_KOR
                  .toLowerCase()
                  .contains(name.toLowerCase()))
              .toList();
    }
  }

  resetState() {
    state.clear();
    clientSocketController.messenger.contactList.value.forEach((element) {
      state.add(State(employee: element, state: false.obs));
    });
  }

  resetOnline(var data) {
    for (var e in data) {
      e.ONLINE_YN = "N";
    }
  }

  Future<String> getImgUser(var userUid) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = clientSocketController.messenger.contactList.value.firstWhereOrNull((element) => element.USER_UID == userUid);
    // print('https://backend.atwom.com.vn/public/resource/imageView/' + user.USER_IMG + '.jpg');
    if(user != null){
      return user.USER_IMG;
    }else{
      print('Error: Failed to load album');
      // throw Exception('Failed to load album');
      return '';
    }
  }
}

class State {
  final Employee employee;
  RxBool state;

  State({required this.employee, required this.state});
}
