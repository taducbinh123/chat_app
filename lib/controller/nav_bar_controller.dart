import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/qr_controller.dart';
import 'package:AMES/features/authentication/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../provider/message_provider.dart';

class NavBarController extends GetxController {
  var _selectedIndex = 0.obs;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  set selectedIndex(value) => this._selectedIndex.value = value;
  get selectedIndex => this._selectedIndex.value;
  final QRController qrController = Get.find();
  final ClientSocketController clientSocketController = Get.find();
  final MessageProvider messageProvider = MessageProvider();
  var _uuid;
  var _currentUuid;
  var textEvents = "";
  var appState;
  @override
  void onInit() {
    _selectedIndex = 0.obs;
    _uuid = Uuid();
    qrController.controllerCountdown.pause();
    firebaseCloudMessaging_Listeners();
    super.onInit();
  }

  @override
  onClose() {
    _selectedIndex = 0.obs;
    super.onClose();
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        this._currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        this._currentUuid = "";
        return null;
      }
    }
  }

  initFirebase() async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      this._currentUuid = _uuid.v4();
    });
    _firebaseMessaging.getToken().then((token) {
      print('Device Token FCM: $token');
    });
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
    await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  void firebaseCloudMessaging_Listeners() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    var token = await _firebaseMessaging.getToken();
    print("Token*********************");
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("tokenFirebase");
    await prefs.setString("tokenFirebase", token!);
    roomSocket.emit("saveDeviceToken", {
      "userUid": clientSocketController.messenger.currentUser.value.USER_UID,
      "TOKEN": token
    });

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    //   print('getInitialMessage data: ${message.data}');
    //
    // });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      // _serialiseAndNavigate(message);
    });

    // void iOS_Permission() async {
    //   FirebaseMessaging messaging = FirebaseMessaging.instance;
    //
    //   NotificationSettings settings = await messaging.requestPermission(
    //     alert: true,
    //     announcement: false,
    //     badge: true,
    //     carPlay: false,
    //     criticalAlert: false,
    //     provisional: false,
    //     sound: true,
    //   );
    //
    //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //     print('User granted permission');
    //   } else if (settings.authorizationStatus ==
    //       AuthorizationStatus.provisional) {
    //     print('User granted provisional permission');
    //   } else {
    //     print('User declined or has not accepted permission');
    //   }
    //   {
    //     print("Settings registered: $settings");
    //   }
    // }
    //
    // ;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  onItemTapped(int index) {
    this.selectedIndex =
        index;
    if(index == 2 ) messageProvider.getUserCallHistory();

    // The set method is accessed this way, you have confused it with methods.
    // if (index != 2) qrController.controllerCountdown.pause();
    //
    // if (index == 2) qrController.controllerCountdown.restart();
  }

  // Future<void> listenerEvent(Function? callback) async {
  //
  //   try {
  //     FlutterCallkitIncoming.onEvent.listen((event) async {
  //       print('HOME: $event');
  //       switch (event!.name) {
  //         case CallEvent.ACTION_CALL_INCOMING:
  //         // TODO: received an incoming call
  //           break;
  //         case CallEvent.ACTION_CALL_START:
  //         // TODO: started an outgoing call
  //         // TODO: show screen calling in Flutter
  //           break;
  //         case CallEvent.ACTION_CALL_ACCEPT:
  //         // TODO: accepted an incoming call
  //         // TODO: show screen calling in Flutter
  //         // var roomId = messageController.makeCall(true);
  //         // if (messenger.selectedRoom?.roomType == "IN_CONTACT_ROOM") {
  //         //   Get.toNamed(callscreen, arguments: [
  //         //     {'ROOM_ID': roomId, 'IS_CALL_AUDIO': true}
  //         //   ]);
  //         // } else {
  //         //   joinMeeting(roomId, true, true);
  //         // }
  //           break;
  //         case CallEvent.ACTION_CALL_DECLINE:
  //         // TODO: declined an incoming call
  //         //   await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
  //           break;
  //         case CallEvent.ACTION_CALL_ENDED:
  //         // TODO: ended an incoming/outgoing call
  //           break;
  //         case CallEvent.ACTION_CALL_TIMEOUT:
  //         // TODO: missed an incoming call
  //           break;
  //         case CallEvent.ACTION_CALL_CALLBACK:
  //         // TODO: only Android - click action `Call back` from missed call notification
  //           break;
  //         case CallEvent.ACTION_CALL_TOGGLE_HOLD:
  //         // TODO: only iOS
  //           break;
  //         case CallEvent.ACTION_CALL_TOGGLE_MUTE:
  //         // TODO: only iOS
  //           break;
  //         case CallEvent.ACTION_CALL_TOGGLE_DMTF:
  //         // TODO: only iOS
  //           break;
  //         case CallEvent.ACTION_CALL_TOGGLE_GROUP:
  //         // TODO: only iOS
  //           break;
  //         case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
  //         // TODO: only iOS
  //           break;
  //         case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
  //         // TODO: only iOS
  //           break;
  //       }
  //       if (callback != null) {
  //         callback(event.toString());
  //       }
  //     }
  //     );
  //   } on Exception {}
  // }

  onEvent(event) {
    textEvents += "${event.toString()}\n";
  }
}
