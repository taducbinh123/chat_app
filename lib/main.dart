import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/features/pending_page.dart';
import 'package:AMES/view/call/history_call_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/features/features.dart';
import 'package:AMES/provider/notification_provider.dart';
import 'package:AMES/view/Call/call_screen.dart';
import 'package:AMES/view/Dashboard.dart';
import 'package:AMES/view/chat_screen.dart';
import 'package:AMES/view/contact/contact_view.dart';
import 'package:AMES/view/pm_screen.dart';
import 'package:AMES/view/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:uuid/uuid.dart';
import 'common/constant/path.dart';
import 'firebase_options.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initialize();
  // await initializeService();
  await FlutterDownloader.initialize();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
    }

    /// you can see this log in logcat
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

bool _callKeepStarted = false;
late final AuthenticationService _authenticationService;

void listenNotifcations() => NotificationProvider.onNotifications;

void initialize() {
  Get.lazyPut(
    () => AuthenticationController(Get.put(AuthenticationServiceImpl())),
  );
  // Get.put(ClientSocketController());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // you need to initialize firebase first
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("isCall", false);
  var payload = message.data;
  print("handling playload");
  print(payload);
  if (message.data.isNotEmpty) {
    if (payload['IS_CANCEL'] =="true") {
      await FlutterCallkitIncoming.endAllCalls();
    } else {
      print("handling background");
      print(message.data);
      makeFakeCallInComing(payload);
    }

    // joinMeeting(var room, bool isCaller, bool isCallAudio) async {
    //   try {
    //     if (isCallAudio) {
    //       featureFlags = {
    //         FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    //         FeatureFlagEnum.INVITE_ENABLED: false,
    //         FeatureFlagEnum.CHAT_ENABLED: false,
    //         FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
    //         FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
    //         FeatureFlagEnum.CALENDAR_ENABLED: false,
    //         FeatureFlagEnum.RAISE_HAND_ENABLED: false,
    //         FeatureFlagEnum.RECORDING_ENABLED: false,
    //         FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
    //         FeatureFlagEnum.TILE_VIEW_ENABLED: false,
    //         FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
    //         FeatureFlagEnum.IOS_RECORDING_ENABLED: false
    //       };
    //     } else {
    //       featureFlags = {
    //         FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    //         FeatureFlagEnum.INVITE_ENABLED: false,
    //         FeatureFlagEnum.CHAT_ENABLED: false,
    //         FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
    //         FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
    //         FeatureFlagEnum.CALENDAR_ENABLED: false,
    //         FeatureFlagEnum.RAISE_HAND_ENABLED: false,
    //         FeatureFlagEnum.RECORDING_ENABLED: false,
    //         FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
    //         FeatureFlagEnum.TILE_VIEW_ENABLED: false,
    //         FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
    //         FeatureFlagEnum.IOS_RECORDING_ENABLED: false
    //       };
    //     }
    //     print(payload["ROOM_ID"]);
    //     var options = JitsiMeetingOptions(room: '${payload["ROOM_ID"]}')
    //       ..serverURL = "https://meet.jit.si/"
    //       ..subject = ""
    //       ..userDisplayName = "${payload["ROOM_NM"]}"
    //       ..userEmail = "${payload["ROOM_NM"]}1@email.com"
    //       ..userAvatarURL = "" // or .png
    //       ..audioOnly = true
    //       ..audioMuted = true
    //       ..videoMuted = true
    //       ..featureFlags = featureFlags
    //       // ..token = "eyJraWQiOiJ2cGFhcy1tYWdpYy1jb29raWUtYjIyNWQzNmM4ZDBlNDUzODg0NmRjMjkzMzhmYzdjZGMvMzgwNDU1LVNBTVBMRV9BUFAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJqaXRzaSIsImlzcyI6ImNoYXQiLCJpYXQiOjE2NTM2MjQ4MTEsImV4cCI6MTY1MzYzMjAxMSwibmJmIjoxNjUzNjI0ODA2LCJzdWIiOiJ2cGFhcy1tYWdpYy1jb29raWUtYjIyNWQzNmM4ZDBlNDUzODg0NmRjMjkzMzhmYzdjZGMiLCJjb250ZXh0Ijp7ImZlYXR1cmVzIjp7ImxpdmVzdHJlYW1pbmciOnRydWUsIm91dGJvdW5kLWNhbGwiOnRydWUsInNpcC1vdXRib3VuZC1jYWxsIjpmYWxzZSwidHJhbnNjcmlwdGlvbiI6dHJ1ZSwicmVjb3JkaW5nIjp0cnVlfSwidXNlciI6eyJtb2RlcmF0b3IiOnRydWUsIm5hbWUiOiJ0YWR1Y2JpbmgxNTEyIiwiaWQiOiJnb29nbGUtb2F1dGgyfDEwNDgxNzY2NjA3Mjc2NTIyMTM3MiIsImF2YXRhciI6IiIsImVtYWlsIjoidGFkdWNiaW5oMTUxMkBnbWFpbC5jb20ifX0sInJvb20iOiIqIn0.GW9FoGR2_4zmRQ012hy46IwbQl6ZHL7LzqkZe_4uAsjPLj90WYtTAB4R4AGPPkuBe_8S1IKd6C26rHDkNlPJ8AF_Pk3lvfBR0EYEs6UM2ZUheYUbVYcf-ZGodPNC1eJEv6EmcQ93vyTFwqCnTvCjckMqZ-uSqnmX32TWsevjaf0ppgny5CSflvElnoheHzWCSNPuXI7gaynbzDmWxgQU5Dmdpo_DBRESeNCCisKxcJp_BKLjdM2QwFT4g9Of80ih9teLuOf5lc1RlbbNs33StFD6hSnW3DeqvZWguDIdHytSMDpNh_xp7frVEZ_j7n1_somB_ucRORkqrSLSBLPJkA"
    //       ..webOptions = {
    //         "width": "100%",
    //         "height": "100%",
    //         "enableWelcomePage": true,
    //         "chromeExtensionBanner": null,
    //         "desktopSharingChromeDisabled": false,
    //         "configOverwrite": {"prejoinPageEnabled": false}
    //       };
    //
    //     await JitsiMeet.joinMeeting(options,
    //         listener: JitsiMeetingListener(
    //             //     onConferenceWillJoin: (Map<dynamic, dynamic> message) {
    //             //   debugPrint("${options.room} will join with message: $message");
    //             // },
    //             onConferenceJoined: (Map<dynamic, dynamic> message) {
    //           print("***********************");
    //           print("${options.room} joined with message: $message");
    //         }, onConferenceTerminated: (Map<dynamic, dynamic> message) {
    //           // if (!callController.forcedEndCall.value) {
    //           //   roomSocket.emit("sendLeftCall", {
    //           //     "USER_UID": messenger.currentUser.value.USER_UID,
    //           //     "ROOM_ID": room['ROOM_ID'],
    //           //     "ROOM_TYPE": room['ROOM_TYPE'],
    //           //     "CALL_USER_UID": room['CALL_USER_UID'],
    //           //     "ROOM_UID": room['ROOM_UID'],
    //           //   });
    //           // }
    //           // callController.unforcedEnd();
    //           // callController.room.value =
    //           // new JitsiMeetingResponse(isSuccess: false);
    //           // callController.isEnded();
    //           // messenger.callRoom.value = CallRoom();
    //           print("${options.room} terminated with message: $message");
    //         }, onPictureInPictureWillEnter: (Map<dynamic, dynamic> message) {
    //           print("${options.room} entered PIP mode with message: $message");
    //         }, onPictureInPictureTerminated: (Map<dynamic, dynamic> message) {
    //           print("${options.room} exited PIP mode with message: $message");
    //         }));
    //   } catch (error) {
    //     print("error: $error");
    //   }
    // }

    // final CallController callController = Get.find();
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print('HOME: $event');
      SharedPreferences preferences = await SharedPreferences.getInstance();

      switch (event!.name) {
        case CallEvent.ACTION_CALL_INCOMING:
          // TODO: received an incoming call
          break;
        case CallEvent.ACTION_CALL_START:
          // TODO: started an outgoing call
          // TODO: show screen calling in FlutterF
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
          preferences.setBool("isCall", true);
          // roomSocket.emit("sendJoinCall", {
          //   "ROOM_ID": payload['ROOM_ID'],
          //   "ROOM_TYPE": payload['ROOM_TYPE'],
          //   "USER_UID": userUid,
          //   "ROOM_UID": payload['ROOM_UID'],
          //   "CALL_USER_UID": userUid,
          //   "TYPE_CALL": "AUDIO"
          // });

          // callController.roomId.value = payload['ROOM_ID'];
          // callController.isCallAudio.value = true;
          // callController.isPickedUp();
          // Get.toNamed(callscreen);
          // joinMeeting(payload, true, true);

          break;
        case CallEvent.ACTION_CALL_DECLINE:
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // TODO: declined an incoming call
          preferences.setBool("isCall", false);
          final String? accessToken = preferences.getString('access_token');

          roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": false,
            "auth": {"token": accessToken},
            "userUid": preferences.getString("userUid")
          });

          roomSocket.connect();
          roomSocket.emit("sendRejectCall", {
            "ROOM_ID": payload['ROOM_ID'],
            "ROOM_TYPE": payload['ROOM_TYPE'],
            "USER_UID": preferences.getString("userUid"),
            "ROOM_UID": payload['ROOM_UID'],
            "CALL_USER_UID": payload['USER_UID']
          });
          break;
        case CallEvent.ACTION_CALL_ENDED:
          // preferences.setBool("isCall", false);
          // TODO: ended an incoming/outgoing call
          break;
        case CallEvent.ACTION_CALL_TIMEOUT:
          // preferences.setBool("isCall", false);
          // TODO: missed an incoming call
          break;
        case CallEvent.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }
}

Future<void> makeFakeCallInComing(var roomNm) async {
  await Future.delayed(const Duration(seconds: 2), () async {
    // print(room);
    // if (roomType == "IN_CONTACT_ROOM") {
    //   nameCaller = room.contactRoomName + " is calling";
    // } else {
    //   nameCaller = room.roomDefaultName + " is calling";
    // }
    var params = <String, dynamic>{
      'id': Uuid().v4(),
      'nameCaller': roomNm["ROOM_NAME"],
      'appName': roomNm["USER_UID"],
      'handle': '${roomNm["ROOM_ID"]}',
      'type': 0,
      'duration': 10000,
      'textAccept': 'Accept',
      'textDecline': 'Decline',
      'textMissedCall': 'Missed call',
      'textCallback': 'Call back',
      'extra': <String, dynamic>{
        'ROOM_TYPE': '${roomNm["ROOM_TYPE"]}',
        'ROOM_UID': '${roomNm["ROOM_UID"]}',
        'TYPE_CALL': '${roomNm["TYPE_CALL"]}',
        'USER_UID': '${roomNm["USER_UID"]}'
      },
      'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      'android': <String, dynamic>{
        'isCustomNotification': true,
        'isShowLogo': false,
        'isShowCallback': true,
        'isShowMissedCallNotification': true,
        'ringtonePath': 'system_ringtone_default',
        'backgroundColor': '#0955fa',
        'background': 'https://i.pravatar.cc/500',
        'actionColor': '#4CAF50'
      },
      'ios': <String, dynamic>{
        'iconName': 'CallKitLogo',
        'handleType': '',
        'supportsVideo': true,
        'maximumCallGroups': 2,
        'maximumCallsPerCallGroup': 1,
        'audioSessionMode': 'default',
        'audioSessionActive': true,
        'audioSessionPreferredSampleRate': 44100.0,
        'audioSessionPreferredIOBufferDuration': 0.005,
        'supportsDTMF': true,
        'supportsHolding': true,
        'supportsGrouping': false,
        'supportsUngrouping': false,
        'ringtonePath': 'system_ringtone_default'
      }
    };

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  });
}

class MyApp extends GetWidget<AuthenticationController> {
  static const String title = 'Chat Messenger';
  const MyApp({Key? key}) : super(key: key);

  FirebaseOptions get firebaseOptions => const FirebaseOptions(
        apiKey: 'AIzaSyA5uBj3wrifSizTBF-zzMAj-emEfhma1h8',
        appId: '1:462870207180:android:6420256f426cda24778069',
        messagingSenderId: '462870207180',
        projectId: 'chatapp-e44d9',
      );

  Future<void> initializeDefault() async {
    final app = await Firebase.initializeApp(options: firebaseOptions);
    // log('Initialized default app $app');
  }

  Future<void> initializeSecondary() async {
    final app = await Firebase.initializeApp(
      name: "Mes",
      options: firebaseOptions,
    );

    // log('Initialized $app');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        child: GetMaterialApp(
          title: title,
          debugShowCheckedModeBanner: false,
          // initialRoute: contactView,
          home: Obx(() {
            if (controller.state is UnAuthenticated) {
              // Get.deleteAll();
              // Get.put(ClientSocketController());
              return LoginPage();
            }
            //test commit
            if (controller.state is Authenticated) {
              Get.put(CallController());
              Get.put(ClientSocketController());
              // Get.put(MessageScreenController());
              return Dashboard();
            }
            if (controller.state is AuthenticationLoading) {
              // Get.put(ClientSocketController());
              return PendingPage();
            }
            return SplashScreen();
          }),
          // initialRoute: dashboard,
          getPages: [
            GetPage(name: contactView, page: () => ContactView()),
            GetPage(name: chatscreen, page: () => ChatScreen()),
            GetPage(name: dashboard, page: () => Dashboard()),
            GetPage(name: callscreen, page: () => CallScreen()),
            GetPage(name: messagescreen, page: () => MessagesScreen()),
            GetPage(name: settingScreen, page: () => SettingScreen()),
            GetPage(name: hisScreen, page: () => HistoryCallScreen()),
            // GetPage(name: loginScreen, page: () => LoginPage())
          ],
        ));
  }
}
