import 'package:get/get.dart';
import 'package:hello_world_flutter/features/authentication/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();


  var username = "";

  void signOut(){
    username = "";
    _authenticationController.signOut();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username")!;
    // return username;
  }
}