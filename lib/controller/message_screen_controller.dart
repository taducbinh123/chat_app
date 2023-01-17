import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/model/message.dart';
import 'package:AMES/provider/message_provider.dart';
import 'package:AMES/features/authentication/authentication_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:audio_session/audio_session.dart';

import '../provider/file_provider.dart';

class MessageScreenController extends GetxController {
  final MessageProvider messageProvider = MessageProvider();
  final FileProvider fileProvider = FileProvider();
  ScrollController controller = ScrollController();
  var result = [].obs;
  var page = box.read("pageState");
  var myController = TextEditingController().obs;
  ReceivePort _port = ReceivePort();
  final ClientSocketController clientSocketController = Get.find();
  ChatScreenController chatScreenController = Get.find();
  var emojiShowing = false.obs;
  var recordFilePath;
  var isRecording = false.obs;
  var isTexting = true.obs;
  var i = 0;
  var check = false.obs;
  var _uuid;
  var _currentUuid;
  var textEvents = "";
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final pathToSaveAudio = 'audio_example.aac';
  var _isRecordInitialised = false;
  FlutterSoundRecorder? _audioRecorder;

  MessageScreenController() {}

  @override
  void onInit() {
    _uuid = Uuid();
    _currentUuid = "";
    myController.value.addListener(() {
      if (myController.value.text.trim() != '') {
        chatScreenController.isTyping.value = true;
      } else {
        chatScreenController.isTyping.value = false;
      }
    });
    controller.addListener(_onScroll);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });
    LoadMessage("null");
    FlutterDownloader.registerCallback(downloadCallback);
    init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  onEvent(event) {
    textEvents += "${event.toString()}\n";
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    // _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecordInitialised = false;
    clientSocketController.messenger.chatList.clear();
    super.onClose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  _onScroll() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      // print(page);
      if (box.read("pageState") != "null") {
        LoadMessage(box.read("pageState"));
      }
    }
  }

  LoadMessage(var page) async {
    messageProvider.getMessageByRoomId(
        clientSocketController.messenger.selectedRoom?.roomUid ?? "", page);
    await Future.delayed(const Duration(milliseconds: 500));
    clientSocketController.messenger.chatList.refresh();
    // print("demo " + clientSocketController.messenger.chatList.value.toString());
  }

  // create jitsi meet room by current selected roomUid
  // and emit sendCreateCall to socket

  makeCall(var room, bool isCallAudio) {
    var roomChatUid = room.roomUid.toString();
    var roomId = DateTime.now().millisecondsSinceEpoch.toString() + roomChatUid;
    String? roomName =
    clientSocketController.messenger.selectedRoom?.roomType ==
        "IN_CONTACT_ROOM"
        ? clientSocketController.messenger.currentUser.value.USER_NM_KOR
        : clientSocketController.messenger.selectedRoom?.roomDefaultName;
    if (isCallAudio) {
      roomSocket.emit("sendCreateCall", {
        "ROOM_NAME": roomName,
        "USER_UID": clientSocketController.messenger.currentUser.value.USER_UID,
        "ROOM_ID": roomId,
        "ROOM_TYPE": room.roomType,
        "ROOM_UID": room.roomUid,
        "TYPE_CALL": "AUDIO"
      });
    } else {
      roomSocket.emit("sendCreateCall", {
        "ROOM_NAME": roomName,
        "USER_UID": clientSocketController.messenger.currentUser.value.USER_UID,
        "ROOM_ID": roomId,
        "ROOM_TYPE": room.roomType,
        "ROOM_UID": room.roomUid,
      });
    }
    clientSocketController.messenger.callRoom.value.ROOM_ID = roomId;
    clientSocketController.messenger.callRoom.value.ROOM_UID = room.roomUid;
    clientSocketController.messenger.callRoom.value.CALL_USER_UID =
        clientSocketController.messenger.currentUser.value.USER_UID;
    clientSocketController.messenger.callRoom.value.ROOM_TYPE = room.roomType;
    clientSocketController.messenger.callRoom.value.TYPE_CALL =
        isCallAudio ? "AUDIO" : "CALL";
    return roomId;
  }

  sendMessage(String msgContent) {
    msgContent = msgContent.trim();
    if (msgContent != "") {
      // print(clientSocketController.messenger.selectedRoom?.roomUid);
      var uidTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      MessageModel message = MessageModel(
          MSG_CONT: myController.value.text,
          MSG_TYPE_CODE: "TEXT",
          SEND_DATE: DateTime.now().toString(),
          USER_UID: box.read("userUid"),
          UID_TIMESTAMP: uidTimeStamp,
          STATUS: 0);
      message.PRE_MSG_SEND_DATE =
          !clientSocketController.messenger.chatList.isEmpty
              ? clientSocketController.messenger.chatList[0].SEND_DATE
              : new DateTime.fromMillisecondsSinceEpoch(0).toString();
      clientSocketController.messenger.chatList.value.insert(0, message);
      clientSocketController.messenger.chatList.refresh();
      String? roomName =
          clientSocketController.messenger.selectedRoom?.roomType ==
                  "IN_CONTACT_ROOM"
              ? clientSocketController.messenger.currentUser.value.USER_NM_KOR
              : clientSocketController.messenger.selectedRoom?.roomDefaultName;
      messageProvider.sendMessage(
          clientSocketController.messenger.selectedRoom?.roomUid ?? "",
          msgContent,
          uidTimeStamp,
          roomName!);
      myController.value.text = "";
    }
    // LoadMessage(page);
  }

  checkTyping(bool check) {
    if (check) {
      roomSocket.emit(
          "focus_chat", clientSocketController.messenger.selectedRoom?.roomUid);
    } else {
      roomSocket.emit(
          "blur_chat", clientSocketController.messenger.selectedRoom?.roomUid);
    }
  }

  changeStateEmoji() {
    emojiShowing.value = !emojiShowing.value;
  }

  onEmojiSelected(Emoji emoji) {
    myController.value
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: myController.value.text.length));
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(('message'));
    }
    await _audioRecorder!.openRecorder();
    // await _audioRecorder!.openAudioSession(
    //   mode: SessionMode.modeSpokenAudio,
    //   focus: AudioFocus.requestFocusAndDuckOthers,
    //   category: SessionCategory.record,
    // );

    await _audioRecorder!
        .setSubscriptionDuration(const Duration(milliseconds: 1000));
    var _recorderSubscription = _audioRecorder?.onProgress?.listen((event) {
      print("AAA event: $event");
    });
    _isRecordInitialised = true;
  }

  Future startRecord() async {
    if (!_isRecordInitialised) return;
    isRecording.value = true;
    recordFilePath = await getFilePath();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await _audioRecorder!.startRecorder(toFile: recordFilePath);
  }

  Future<void> makeFakeCallInComing() async {
    await Future.delayed(const Duration(seconds: 10), () async {
      this._currentUuid = Uuid().v4();
      String? nameCaller = "";
      if (clientSocketController.messenger.selectedRoom?.roomType ==
          "IN_CONTACT_ROOM") {
        nameCaller =
            clientSocketController.messenger.currentUser.value.USER_NM_ENG;
      } else {
        nameCaller = clientSocketController
            .messenger.selectedRoom?.roomDefaultName
            .toString();
      }
      var params = <String, dynamic>{
        'id': _currentUuid,
        'nameCaller': nameCaller,
        'appName': 'Callkit',
        'avatar': 'https://i.pravatar.cc/100',
        'handle': '',
        'type': 0,
        'duration': 10000,
        'textAccept': 'Accept',
        'textDecline': 'Decline',
        'textMissedCall': 'Missed call',
        'textCallback': 'Call back',
        'extra': <String, dynamic>{'userId': '1a2b3c4d'},
        'headers': <String, dynamic>{
          'apiKey': 'Abc@123!',
          'platform': 'flutter'
        },
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

  Future<void> endCurrentCall() async {
    var params = <String, dynamic>{'id': this._currentUuid};
    await FlutterCallkitIncoming.endCall(params);
  }

  Future<void> startOutGoingCall() async {
    this._currentUuid = _uuid.v4();
    var params = <String, dynamic>{
      'id': this._currentUuid,
      'nameCaller': 'Hien Nguyen',
      'handle': '0123456789',
      'type': 1,
      'extra': <String, dynamic>{'userId': '1a2b3c4d'},
      'ios': <String, dynamic>{'handleType': 'number'}
    }; //number/email
    await FlutterCallkitIncoming.startCall(params);
  }

  Future<void> activeCalls() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    print(calls);
  }

  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  Future stopRecord() async {
    if (!_isRecordInitialised) return;
    await _audioRecorder!.stopRecorder();
    if (_audioRecorder!.isStopped) {
      isRecording.value = false;
    }
  }

  Future sendAudioRecord() async {
    if (_audioRecorder!.isStopped) {
      uploadAudio();
    }
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/${getRandomString(10)}.aac";
  }

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  uploadAudio() {
    var data = {
      'ROOM_UID': clientSocketController.messenger.selectedRoom?.roomUid,
      'USER_UID': box.read("userUid")
    };

    final File fileForFirebase = File(recordFilePath);

    fileProvider.uploadFile(fileForFirebase, data);
  }

  onBackspacePressed() {
    myController.value
      ..text = myController.value.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: myController.value.text.length));
  }
}
