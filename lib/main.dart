import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/view/Call/call_screen.dart';
import 'package:hello_world_flutter/view/Contact/contact_screen.dart';
import 'package:hello_world_flutter/view/Dashboard.dart';
import 'package:hello_world_flutter/view/chat_screen.dart';
import 'package:hello_world_flutter/view/contact_view.dart';
import 'package:hello_world_flutter/view/pm_screen.dart';

import 'common/constant/path.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Chat Messenger';
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      // initialRoute: contactView,

      initialRoute: dashboard,
      getPages: [
        GetPage(name: contactView, page: () => ContactView()),
        GetPage(name: chatscreen, page: () => ChatScreen()),
        GetPage(name: contact, page: () => ContactScreen()),
        GetPage(name: dashboard, page: () => Dashboard()),
        GetPage(name: callscreen, page: () => CallScreen()),
        GetPage(name: messagescreen, page: () => MessagesScreen()),
      ],
    );
  }
}
