import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class ContactScreenController extends GetxController {

  TextEditingController searchController = TextEditingController();
  var contactList = chatsData.obs;

  var state = [].obs;
  // var contactTempList = chatsData.obs;
  ContactScreenController(){
    resetState();
  }

  var listContactChoose = [].obs;
  var listNameChoose = "".obs;

  changeState(int index,Chat e){
    // change state
    var stateChange;
    for (State element in state) {
      if(element.chat == e){
        element.state.value = !element.state.value;
        stateChange = element;
        break;
      }
    }
    // state[index] = !state[index];
    // format string name
    listNameChoose.value = "";
    if(stateChange.state.value){
      listContactChoose.add(e);
      for (var value in listContactChoose) {
        print(value.name);
        listNameChoose.value += value.name + ", ";
      }
      listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      print(listNameChoose);
    }else{
      listContactChoose.remove(e);
      if(listContactChoose.length !=0) {
        for (var value in listContactChoose) {
          print(value.name);
          listNameChoose.value += value.name + ", ";
        }
        listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      }
      print(listNameChoose);
    }
  }

  contactNameSearch(String name) {
    // state = List.filled(chatsData.length,false).obs;
    if (name.isEmpty) {
      contactList.value = chatsData;
    } else {
      // contactList.value = chatsData.where((element) =>
      //     element.name.toLowerCase().contains(name.toLowerCase())).toList();
      chatsData.forEach((element) {
        if(element.name.toLowerCase().contains(name.toLowerCase())){
          contactList.value.add(element);
        }
      });
    }
  }

  resetState(){
    state.clear();
    chatsData.forEach((element) {
      state.add(State(chat: element,state: false.obs));
    });
  }

}

class State{
  final Chat chat;
  RxBool state;

  State({required this.chat,required this.state});
}
