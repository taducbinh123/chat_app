
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/widgets/multi_select_circle.dart';
import 'package:hello_world_flutter/model/employee.dart';
import 'package:hello_world_flutter/provider/contact_view_provider.dart';

class ContactScreenController extends GetxController {

  final ContactViewProvider contactViewProvider = ContactViewProvider();
  TextEditingController searchController = TextEditingController();

  List<SelectCircle> listAvatarChoose = [];
  List<Employee> initData = [];
  var contactList = <Employee>[].obs;

  var state = [].obs;
  // var contactTempList = chatsData.obs;
  ContactScreenController() {
    resetState();
    initDataEmployee('20170928174704927015');
  }

  initDataEmployee(String userUid) async {
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
          text: e.USER_NM_ENG));
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
