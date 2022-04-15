import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hello_world_flutter/common/ulti/Encryption.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_controller.dart';

class QRController extends GetxController{

  TextEditingController controller = TextEditingController();
  AnimationController? animationController;
  CountdownController controllerCountdown =
  new CountdownController(autoStart: true);

  var deviceId = "".obs;
  var pre = "0".obs;
  var msg = "".obs;



  @override
  Future<void> onInit() async {
    await getId();
    controller.text = deviceId.value;
    getMessage();
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    print("----------------------id---------------------");
    print(deviceId.value);
    super.onInit();
  }

  getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId.value = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId.value = androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  getMessage() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String strTime = dateFormat.format(DateTime.now());
    msg.value = pre + "&" + deviceId.value + '&' + strTime;
    msg.value = Encryption.encrypt(msg.value);
//    print(msg);
    print(Encryption.decrypt(msg.value));
//    print(msg.length);
  }
}