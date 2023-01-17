import 'package:AMES/features/authentication/authentication_controller.dart';
import 'package:AMES/features/authentication/authentication_service.dart';
import 'package:AMES/features/authentication/login/login_state.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();

  var loginStateStream = LoginState().obs;
  var rememberValue = true.obs;
  LoginState get state => loginStateStream.value;

  @override
  onReady() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('access_token');
    print("---------------//------------");
    print(accessToken);
    super.onReady();
  }

  void login(String username, String password, bool convertPassword) async {
    loginStateStream.value = LoginLoading();

    try {
      await _authenticationController.signIn(username, password, convertPassword);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("rememberValue");
      await prefs.setString("rememberValue", rememberValue.value.toString());
      print(rememberValue.value);

      loginStateStream.value = LoginState();
    } on AuthenticationException catch (e) {
      loginStateStream.value = LoginFailure(error: e.message);
    }
  }

   final _auth = LocalAuthentication();

   Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

   Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Face to Authenticate',

        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,


        ),
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}
