import 'package:get/get.dart';
import 'package:hello_world_flutter/features/authentication/authentication.dart';

class HomeController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();

  void signOut(){
    _authenticationController.signOut();
  }
}