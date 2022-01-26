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
    var stateChange;
    for (var element in state) {
      if(element.chat == e){
        element.state = !element.state;
        stateChange = element;
        break;
      }
    }
    // state[index] = !state[index];
    listNameChoose.value = "";
    if(stateChange.state){
      listContactChoose.add(e);
      for (var value in listContactChoose) {
        print(value.name);
        listNameChoose.value += value.name + ", ";
      }
      listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      print(listNameChoose);
    }else{
      listContactChoose.remove(e);
      for (var value in listContactChoose) {
        print(value.name);
        listNameChoose.value += value.name + ", ";
      }
      listNameChoose.value = listNameChoose.substring(0, listNameChoose.value.length -2);
      print(listNameChoose);
    }
  }

  contactNameSearch(String name) {
    // state = List.filled(chatsData.length,false).obs;
    if (name.isEmpty) {
      contactList.value = chatsData;
    } else {
      contactList.value = chatsData
          .where((element) =>
          element.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  resetState(){
    chatsData.forEach((element) {
      state.add(State(chat: element,state: false));
    });
  }

  bool getStateByChat(Chat e){
    for (State element in state) {
      if(element.chat == e){
        print("dcsj")
        return element.state;
      }
    }
    return false;
  }
}

class State{
  final Chat chat;
  bool state;

  State({required this.chat,required this.state});
}
