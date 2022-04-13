
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';
import 'package:hello_world_flutter/provider/socket_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreenController extends GetxController {

  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();
  TextEditingController searchController = TextEditingController();

  List<SelectCircle> listAvatarChoose = [];
  List<Employee> initData = [];
  var contactList = <Employee>[].obs;

  var state = [].obs;
  // var contactTempList = chatsData.obs;
  ContactScreenController() {
    // resetState();
    // initDataEmployee();
  }

  @override
  void onInit() {
    resetState();
    initDataEmployee();
    super.onInit();
  }

  initDataEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userUid = prefs.getString('userUid');
    print(userUid);
    initData = await contactViewProvider.getEmployee(userUid);
    resetOnline(initData);
    await socketProvider.getOnlineMember(initData);

    // loại bỏ user ra khỏi danh sách

    initData = initData.where((element) => element.USER_UID != userUid).toList();
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
          text: e.USER_NM_KOR));
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
    initData.forEach((element) {
      state.add(State(employee: element, state: false.obs));
    });
  }

  resetOnline(var data){
    for(var e in data){
      e.ONLINE_YN = "N";
    }
  }
}

class State {
  final Employee employee;
  RxBool state;

  State({required this.employee, required this.state});
}
