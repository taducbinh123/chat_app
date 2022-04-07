import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/features/authentication/authentication.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/view/Call/call_screen.dart';
import 'package:hello_world_flutter/view/Dashboard.dart';
import 'package:hello_world_flutter/view/chat_screen.dart';
import 'package:hello_world_flutter/view/contact/contact_view.dart';
import 'package:hello_world_flutter/view/pm_screen.dart';
import 'package:hello_world_flutter/view/room_member/room_member_screen.dart';
import 'package:hello_world_flutter/view/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/constant/path.dart';

void main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await GetStorage.init();
  initialize();
  runApp(const MyApp());
}


void initialize() {

  Get.lazyPut(() => AuthenticationController(Get.put(AuthenticationServiceImpl())),);
}

class MyApp extends GetWidget<AuthenticationController> {
  static const String title = 'Chat Messenger';
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      // initialRoute: contactView,
      home: Obx(() {
        if (controller.state is UnAuthenticated) {
          // Get.deleteAll();
          return LoginPage();
        }

        if (controller.state is Authenticated) {
          return Dashboard();
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
        // GetPage(name: loginScreen, page: () => LoginPage())
      ],
    );
  }
}
