import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/features/features.dart';
import 'package:AMES/model/models.dart';
import 'package:AMES/provider/user_provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../common/constant/path.dart';
import '../../controller/message_screen_controller.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService authenticationService;
  // var _connectionStatus = (ConnectivityResult.none).obs;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final UserProvider userProvider = UserProvider();
  final authenticationStateStream = AuthenticationState().obs;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  AuthenticationState get state => authenticationStateStream.value;
  AuthenticationController(this.authenticationService);
  var currentDate = DateTime.now().obs;
  // var flag = false.obs;
  @override
  void onInit() {
    getAuthenticatedUser();
    // initConnectivity();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Timer.periodic(new Duration(seconds: 60), (timer) {
      currentDate.value = DateTime.now();
    });
    super.onInit();
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> signIn(
      String username, String password, bool convertPassword) async {
    final user = await authenticationService.signInWithUsernameAndPassword(
        username, password, convertPassword);
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userInfo = await userProvider.getUserInfo();
    final String? accessToken = prefs.getString('access_token');

    roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": accessToken},
      "userUid": userInfo.USER_UID
    });

    roomSocket.connect();
    await prefs.remove("userUid");
    await prefs.setString("userUid", userInfo.USER_UID);
    await prefs.remove("username");
    await prefs.setString("username", userInfo.USER_ID);
    await prefs.setString("username", userInfo.USER_ID);
    final box = GetStorage();
    box.write("userUid", userInfo.USER_UID);

    authenticationStateStream.value = Authenticated(user: user);
    // Get.put(CallController());
    // Get.put(ClientSocketController());
    await Future.delayed(Duration(seconds: 1));
    Get.put(MessageScreenController());
    ClientSocketController clientSocketController = Get.find();
    ChatScreenController chatScreenController = Get.find();
    clientSocketController.messenger.currentUser.value = userInfo;
    clientSocketController.messenger.currentUser.refresh();
    // || clientSocketController.messenger.currentUser.value.USER_UID != null
    if (clientSocketController.messenger.currentUser.value.USER_UID == "") {
      Get.defaultDialog(
        title: "Notification",
        // confirm: Text("OK"),
        middleText: "Unable to load data",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.red),
        middleTextStyle: TextStyle(color: Colors.black),
      );
    } else {
      chatScreenController.initDataRoom();
      roomSocket.emit("changeUserState", {
        "userUid": clientSocketController.messenger.currentUser.value.USER_UID,
        "IS_ONLINE": "true"
      });
    }
  }

  String displayTime(String? date) {
    if (date == null) {
      return '';
    }
    var sendTime =
        DateTime.parse(date.toString()).toLocal().millisecondsSinceEpoch;
    var currentTime = currentDate.value.millisecondsSinceEpoch;
    var diff = currentTime - sendTime;
    if (diff < 60 * 1000) {
      return 'Just now';
      // } else if(diff < 60*1000){
      //   return 'Few seconds';
      // } else if (diff < 2*60*1000) {
      //   return '1 min';
    } else if (diff < 60 * 60 * 1000) {
      return (diff ~/ (60 * 1000)).toString() + ' min';
    } else if (diff < 24 * 60 * 60 * 1000) {
      return DateFormat('hh:mm aa')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    } else if (diff < 7 * 24 * 60 * 60 * 1000) {
      return DateFormat('EEEE, hh:mm aa')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    } else {
      return DateFormat('dd/MM/yyyy, hh:mm aa')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    }
  }

  String displayTime2(String? date) {
    if (date == null) {
      return '';
    }
    var sendTime =
        DateTime.parse(date.toString()).toLocal().millisecondsSinceEpoch;
    var currentTime = currentDate.value.millisecondsSinceEpoch;
    var diff = currentTime - sendTime;
    if (diff < 60 * 1000) {
      return 'Just now';
      // } else if(diff < 60*1000){
      //   return 'Few seconds';
      // } else if (diff < 2*60*1000) {
      //   return '1 min';
    } else if (diff < 60 * 60 * 1000) {
      return (diff ~/ (60 * 1000)).toString() + ' min';
    } else if (diff < 24 * 60 * 60 * 1000) {
      return DateFormat('hh:mm aa')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    } else if (diff < 7 * 24 * 60 * 60 * 1000) {
      return DateFormat('EEEE')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    } else {
      return DateFormat('dd/MM/yyyy')
          .format(DateTime.parse(date.toString()).toLocal())
          .toString();
    }
  }

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return;
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   _connectionStatus.value = result;
  //   if (_connectionStatus.value == ConnectivityResult.none) {
  //     Get.defaultDialog(
  //       title: "Warning",
  //       middleText: "Check your connections",
  //       confirm: ElevatedButton(
  //           onPressed: () {
  //             Get.back();
  //           },
  //           child: Text(
  //             "OK",
  //             style: TextStyle(color: Colors.black),
  //           )),
  //       backgroundColor: Colors.white,
  //       titleStyle: TextStyle(color: Colors.black),
  //       middleTextStyle: TextStyle(color: Colors.black),
  //     );
  //   }
  //
  //   print(_connectionStatus.value);
  // }
  // void saveToken(String token) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(Constants.DeviceToken, token);
  // }

  void signOut() async {
    await authenticationService.signOut();
    await IsFirstRun.reset();
    // flag.value = true;
    _firebaseMessaging.deleteToken();
    authenticationStateStream.value = UnAuthenticated();
    Get.delete<NavBarController>();
    Get.delete<ChatScreenController>();
    Get.delete<MessageScreenController>();
    Get.delete<HomeController>();
    Get.delete<ContactScreenController>();
    Get.delete<CallController>();
    Get.delete<ClientSocketController>();
    authenticationStateStream.refresh();

    // Get.offAll(LoginPage());
  }

  void getAuthenticatedUser() async {
    authenticationStateStream.value = AuthenticationLoading();

    // final user = await _authenticationService.getCurrentUser();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('access_token');
    final String? rememberValue = prefs.getString('rememberValue');
    final String? tokenFirebase = prefs.getString('tokenFirebase');
    final String? userUid = prefs.getString('userUid');
    roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": accessToken},
      "userUid": userUid
    });

    roomSocket.connect();
    var token = await _firebaseMessaging.getToken();
    print("Token*********************");
    print(token);
    await prefs.remove("tokenFirebase");
    await prefs.setString("tokenFirebase", token!);
    roomSocket.emit("saveDeviceToken", {
      "userUid": userUid,
      "TOKEN": token
    });
    await Future.delayed(Duration(milliseconds: 500));
    final String? username = prefs.getString('username');
    // final String? password = prefs.getString('password');

    if (accessToken == null) {
      await Future.delayed(Duration(milliseconds: 2000));
      authenticationStateStream.value = UnAuthenticated();
    } else {
      if (rememberValue == 'true' &&
          tokenFirebase != null &&
          username != null) {
        var tokenRefresh =
        await authenticationService.autoLogin(username, token);
        if (tokenRefresh) {
          // final String? userUid = prefs.getString('userUid');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userInfo = await userProvider.getUserInfo();
          roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": false,
            "auth": {"token": accessToken},
            "userUid": userInfo.USER_UID
          });
          roomSocket.connect();
          await prefs.remove("userUid");
          await prefs.setString("userUid", userInfo.USER_UID);
          await prefs.remove("username");
          await prefs.setString("username", userInfo.USER_ID);
          final box = GetStorage();
          box.write("userUid", userInfo.USER_UID);

          authenticationStateStream.value =
              Authenticated(user: new User(name: username, email: ""));
          // Get.put(CallController());
          // Get.put(ClientSocketController());
          await Future.delayed(Duration(seconds: 1));
          Get.put(MessageScreenController());
          final ClientSocketController clientSocketController = Get.find();
          clientSocketController.messenger.currentUser.value = userInfo;
          clientSocketController.messenger.currentUser.refresh();
          // || clientSocketController.messenger.currentUser.value.USER_UID != null
          if (clientSocketController.messenger.currentUser.value.USER_UID ==
              "") {
            Get.defaultDialog(
              title: "Notification",
              // confirm: Text("OK"),
              middleText: "Unable to load data",
              backgroundColor: Colors.white,
              titleStyle: TextStyle(color: Colors.red),
              middleTextStyle: TextStyle(color: Colors.black),
            );
          } else {
            ChatScreenController chatScreenController = Get.find();
            chatScreenController.initDataRoom();
            roomSocket.emit("changeUserState", {
              "userUid":
              clientSocketController.messenger.currentUser.value.USER_UID,
              "IS_ONLINE": "true"
            });
          }
          print("autoLogin success");
        } else {
          checkLoginExpiresIn();
        }
      } else {
        checkLoginExpiresIn();
      }
    }
  }

  checkLoginExpiresIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expires_in = prefs.getString('expires_in');
    final String? accessToken = prefs.getString('access_token');
    final String? userUid = prefs.getString('userUid');

    roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "auth": {"token": accessToken},
      "userUid": userUid
    });
    roomSocket.connect();

    DateTime dateTime = DateTime.parse(expires_in!);
    DateTime timeCompare = DateTime.now().add(new Duration(
        days: 0, hours: 0, minutes: 10, seconds: 0, milliseconds: 0));

    if (timeCompare.compareTo(dateTime) < 0) {
      String? username = prefs.getString("username");
      authenticationStateStream.value =
          Authenticated(user: new User(name: username!, email: ""));
      // Get.put(CallController());
      // Get.put(ClientSocketController());
      await Future.delayed(Duration(seconds: 1));
      Get.put(MessageScreenController());
      ChatScreenController chatScreenController = Get.find();
      chatScreenController.initDataRoom();
    } else {
      await Future.delayed(Duration(milliseconds: 2000));
      authenticationStateStream.value = UnAuthenticated();
    }
  }
}
