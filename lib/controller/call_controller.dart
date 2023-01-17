import 'dart:async';
import 'dart:io';
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/features/authentication/authentication_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:uuid/uuid.dart';
import 'client_socket_controller.dart';

class CallController extends GetxController {
  // 0: ringing, 1: calling, 2: end, -1:rejected, -2: busy, -3: Receiver is unavailable, 4: coming call
  var status = 0.obs;
  var roomId = ''.obs;
  // dynamic argumentData = Get.arguments;
  var isCallAudio = false.obs;
  var forcedEndCall = false.obs;
  var roomChat;
  var _currentUuid;
  var _uuid;
  var room = new JitsiMeetingResponse(isSuccess: false).obs;
  var infoRoomCall;


  forcedEnd(){
    forcedEndCall.value = true;
  }

  unforcedEnd(){
    forcedEndCall.value = false;
    isEnded();
  }

  @override
  void onInit() {
    _uuid = Uuid();
    _currentUuid = "";
    initCurrentCall();
    super.onInit();
  }

  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  makeNew() {
    status.value = 0;
  }



  isBusy() {
    status.value = -2;
  }

  isUnavailable() async {
    status.value = -3;
    await Future.delayed(Duration(milliseconds: 1500));
    if (Get.currentRoute == callscreen) {
      Get.back();
    }
  }

  isRejected() {
    status.value = -1;
  }

  isPickedUp() {
    status.value = 1;
  }

  isComingCall(){
    status.value = 4;
  }
  
  initCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        this._currentUuid = calls[0]['uuid'];
      } else {
        this._currentUuid = "";
      }
    }
  }

  isEnded() async {
    status.value = 2;
    await Future.delayed(Duration(milliseconds: 1000));
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
    print("###########DEMO###############");
    var params = <String, dynamic>{'id':calls[0]['uuid']};
    print(params);
    await FlutterCallkitIncoming.endCall(params);
      }
    }
    if (Get.currentRoute == callscreen) {
      Get.back();
    }
  }


}
