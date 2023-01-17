import 'dart:convert';
import 'dart:convert' as convert;
import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/controller/message_screen_controller.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:AMES/controller/room_chat_controller.dart';
import 'package:AMES/features/authentication/authentication.dart';
import 'package:AMES/model/call_room.dart';
import 'package:AMES/provider/room_chat_provider.dart';
import 'package:AMES/view/call/pending_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/model/message.dart';
import 'package:AMES/model/messenger.dart';
import 'package:AMES/model/room.dart';
import 'package:AMES/provider/contact_view_provider.dart';
import 'package:AMES/provider/socket_provider.dart';
import 'package:AMES/provider/user_provider.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class ClientSocketController extends GetxController
    with WidgetsBindingObserver {
  final Messenger messenger = new Messenger();
  final service = FlutterBackgroundService();
  final UserProvider userProvider = UserProvider();
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final RoomChatProvider roomChatProvider = RoomChatProvider();
  final SocketProvider socketProvider = SocketProvider();
  AuthenticationController authenticationController = Get.find();
  final CallController callController = Get.find();
  var newAudioMessage = false.obs;

  var visibleIncomingCallDialog = false.obs;
  var isTyping = false.obs;
  var _uuid;
  var _currentUuid;
  var textEvents = "";
  AppLifecycleState appState = AppLifecycleState.resumed;
  String? userUid;

  @override
  Future<void> onInit() async {
    await Future.delayed(Duration(seconds: 1));
    if (!(authenticationController.state is AuthenticationLoading))
      await initUser();
    roomChatProvider.getData();
    // await getContactList();
    clientSocketIO();
    _uuid = Uuid();
    _currentUuid = "";
    WidgetsBinding.instance?.addObserver(this);
    super.onInit();
  }

  // @override
  // void onReady() {
  //   Get.put(MessageScreenController());
  //   super.onReady();
  // }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    appState = state;
    if (state == AppLifecycleState.paused) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("isCall", false);
    }
  }

  initUser() async {
    var userInfo = await userProvider.getUserInfo();
    messenger.currentUser.value = userInfo;
  }

  Future<bool> checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    return ifr;
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  getContactList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List decodeData;
    var data;
    checkFirstRun().then((value) async => {
          if (value)
            {
              await loadContactList(),
              prefs.setString("contactList",
                  jsonEncode(messenger.contactList.value).toString()),
            }
          else
            {
              // print("*****************************************"),
              // print(prefs.getString("contactList").toString()),
              data = prefs.getString("contactList"),
              if (data != null)
                {
                  decodeData = convert.jsonDecode(data.toString()),
                  messenger.contactList.value =
                      decodeData.map((e) => Employee.fromJson(e)).toList(),
                  await getOnlineMember(messenger.contactList.value),
                  messenger.contactList.refresh(),
                  messenger.contactListFlag.value = messenger.contactList.value,
                }
              else
                {
                  await loadContactList(),
                  prefs.setString("contactList",
                      jsonEncode(messenger.contactList.value).toString()),
                }
            }
        });
  }

  joinMeeting(var room, bool isCaller, bool isCallAudio) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags;
      if (isCallAudio) {
        featureFlags = {
          FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
          FeatureFlagEnum.INVITE_ENABLED: false,
          FeatureFlagEnum.CHAT_ENABLED: false,
          FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
          FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
          FeatureFlagEnum.CALENDAR_ENABLED: false,
          FeatureFlagEnum.RAISE_HAND_ENABLED: false,
          FeatureFlagEnum.RECORDING_ENABLED: false,
          FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
          FeatureFlagEnum.TILE_VIEW_ENABLED: false,
          FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
          FeatureFlagEnum.IOS_RECORDING_ENABLED: false
        };
      } else {
        featureFlags = {
          FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
          FeatureFlagEnum.INVITE_ENABLED: false,
          FeatureFlagEnum.CHAT_ENABLED: false,
          FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
          FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
          FeatureFlagEnum.CALENDAR_ENABLED: false,
          FeatureFlagEnum.RAISE_HAND_ENABLED: false,
          FeatureFlagEnum.RECORDING_ENABLED: false,
          FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
          FeatureFlagEnum.TILE_VIEW_ENABLED: false,
          FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
          FeatureFlagEnum.IOS_RECORDING_ENABLED: false
        };
      }

      var options = JitsiMeetingOptions(room: '${room['ROOM_ID']}')
        ..serverURL = "https://meet.jit.si/"
        ..subject = ""
        ..userDisplayName = "${messenger.currentUser.value.USER_NM_ENG}"
        ..userEmail = "${messenger.currentUser.value.USER_ID}1@email.com"
        ..userAvatarURL = "" // or .png
        ..audioOnly = isCallAudio
        ..audioMuted = false
        ..videoMuted = isCallAudio
        ..featureFlags = featureFlags
        // ..token = "eyJraWQiOiJ2cGFhcy1tYWdpYy1jb29raWUtYjIyNWQzNmM4ZDBlNDUzODg0NmRjMjkzMzhmYzdjZGMvMzgwNDU1LVNBTVBMRV9BUFAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJqaXRzaSIsImlzcyI6ImNoYXQiLCJpYXQiOjE2NTM2MjQ4MTEsImV4cCI6MTY1MzYzMjAxMSwibmJmIjoxNjUzNjI0ODA2LCJzdWIiOiJ2cGFhcy1tYWdpYy1jb29raWUtYjIyNWQzNmM4ZDBlNDUzODg0NmRjMjkzMzhmYzdjZGMiLCJjb250ZXh0Ijp7ImZlYXR1cmVzIjp7ImxpdmVzdHJlYW1pbmciOnRydWUsIm91dGJvdW5kLWNhbGwiOnRydWUsInNpcC1vdXRib3VuZC1jYWxsIjpmYWxzZSwidHJhbnNjcmlwdGlvbiI6dHJ1ZSwicmVjb3JkaW5nIjp0cnVlfSwidXNlciI6eyJtb2RlcmF0b3IiOnRydWUsIm5hbWUiOiJ0YWR1Y2JpbmgxNTEyIiwiaWQiOiJnb29nbGUtb2F1dGgyfDEwNDgxNzY2NjA3Mjc2NTIyMTM3MiIsImF2YXRhciI6IiIsImVtYWlsIjoidGFkdWNiaW5oMTUxMkBnbWFpbC5jb20ifX0sInJvb20iOiIqIn0.GW9FoGR2_4zmRQ012hy46IwbQl6ZHL7LzqkZe_4uAsjPLj90WYtTAB4R4AGPPkuBe_8S1IKd6C26rHDkNlPJ8AF_Pk3lvfBR0EYEs6UM2ZUheYUbVYcf-ZGodPNC1eJEv6EmcQ93vyTFwqCnTvCjckMqZ-uSqnmX32TWsevjaf0ppgny5CSflvElnoheHzWCSNPuXI7gaynbzDmWxgQU5Dmdpo_DBRESeNCCisKxcJp_BKLjdM2QwFT4g9Of80ih9teLuOf5lc1RlbbNs33StFD6hSnW3DeqvZWguDIdHytSMDpNh_xp7frVEZ_j7n1_somB_ucRORkqrSLSBLPJkA"
        ..webOptions = {
          "width": "100%",
          "height": "100%",
          "enableWelcomePage": true,
          "chromeExtensionBanner": null,
          "desktopSharingChromeDisabled": false,
          "configOverwrite": {"prejoinPageEnabled": false}
        };

      callController.room.value = await JitsiMeet.joinMeeting(options,
          listener: JitsiMeetingListener(
              //     onConferenceWillJoin: (Map<dynamic, dynamic> message) {
              //   debugPrint("${options.room} will join with message: $message");
              // },
              onConferenceJoined: (Map<dynamic, dynamic> message) {
            print("***********************");
            print("${options.room} joined with message: $message");
          }, onConferenceTerminated: (Map<dynamic, dynamic> message) {
            if (!callController.forcedEndCall.value) {
              roomSocket.emit("sendLeftCall", {
                "USER_UID": messenger.currentUser.value.USER_UID,
                "ROOM_ID": room['ROOM_ID'],
                "ROOM_TYPE": room['ROOM_TYPE'],
                "CALL_USER_UID": room['CALL_USER_UID'],
                "ROOM_UID": room['ROOM_UID'],
              });
            }
            callController.unforcedEnd();
            callController.room.value =
                new JitsiMeetingResponse(isSuccess: false);
            callController.isEnded();
            messenger.callRoom.value = CallRoom();
            print("${options.room} terminated with message: $message");
          }, onPictureInPictureWillEnter: (Map<dynamic, dynamic> message) {
            print("${options.room} entered PIP mode with message: $message");
          }, onPictureInPictureTerminated: (Map<dynamic, dynamic> message) {
            print("${options.room} exited PIP mode with message: $message");
          }));
    } catch (error) {
      print("error: $error");
    }
  }

  loadContactList() async {
    print("load contact");
    messenger.contactList.value = await contactViewProvider
        .getEmployee(messenger.currentUser.value.USER_UID.toString());
    await await getOnlineMember(messenger.contactList.value);
    messenger.contactList.refresh();
    messenger.contactListFlag.value = messenger.contactList.value;
  }

  clientSocketIO() {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    roomSocket.connect();

    var roomMessage;
    var index;
    Room rm;
    MessageModel message;
    DateTime sendDate;
    Duration timeAgo;
    var time;
    var uid;
    var dataFlag;
    var stringFlag = "";

    roomSocket.on(
        "server_send_message",
        (data) => {
              // print("-----------------/message/------------------"),
              // print(data),
              rm = Room.fromJson(data as Map<dynamic, dynamic>),
              // print(rm),
              // format sendDate display screen
              if (rm.messageModel?.SEND_DATE != null)
                {
                  sendDate = DateTime.parse(
                          rm.messageModel?.SEND_DATE.toString() ?? "")
                      .toLocal(),
                  // print(sendDate),
                  timeAgo = DateTime.now().difference(sendDate),
                  time = DateTime.now().subtract(timeAgo),
                  rm.timeLastMessageDisplay = timeago.format(time),
                },
              // get uid other IN_CONTACT_ROOM
              if (rm.roomType == "IN_CONTACT_ROOM")
                {
                  uid = rm.memberUidList?.firstWhere((element) =>
                      messenger.currentUser.value.USER_UID != element),
                  rm.userUidContact = uid,
                },
              roomMessage = messenger.listRoom.value
                  .firstWhereOrNull((element) => element.roomUid == rm.roomUid),

              if (roomMessage != null)
                {
                  index = messenger.listRoom.value.indexOf(roomMessage),
                  if (rm.roomType == "IN_CONTACT_ROOM")
                    {
                      rm.contactRoomName = roomMessage.contactRoomName,
                    },
                  if (index >= 0)
                    {
                      if (rm.messageModel?.USER_UID != null &&
                          rm.messageModel?.USER_UID !=
                              messenger.currentUser.value.USER_UID &&
                          rm.roomUid != messenger.selectedRoom?.roomUid)
                        {
                          rm.unReadMsgCount = ++roomMessage.unReadMsgCount,
                          // print(rm.unReadMsgCount),
                        },
                      messenger.listRoom.value.removeAt(index),
                      messenger.listRoom.value.insert(0, rm),
                      messenger.listRoom.refresh(),
                      messenger.listRoomFlag.value = messenger.listRoom.value,
                      // print("-----------------/list room update/------------------"),
                      // print(messenger.listRoom),
                    },
                  if (rm.roomUid == messenger.selectedRoom?.roomUid)
                    {
                      if (rm.messageModel?.MSG_TYPE_CODE != 'CALL')
                        {
                          rm.messageModel?.PRE_USER_UID =
                              messenger.chatList.value.length <= 1
                                  ? ""
                                  : messenger.chatList.value[0].MSG_TYPE_CODE ==
                                          "CALL"
                                      ? ""
                                      : messenger.chatList.value[0].USER_UID,
                          print("------------------------------00"),
                          print(rm.messageModel?.PRE_USER_UID),
                        },
                      dataFlag = data['LAST_MSG_OBJ'],
                      if (rm.messageModel?.MSG_TYPE_CODE == 'TEXT' &&
                          dataFlag['UID_TIMESTAMP'] ==
                              messenger.chatList.value[0].UID_TIMESTAMP &&
                          dataFlag['USER_UID'] ==
                              messenger.chatList.value[0].USER_UID)
                        {
                          message = MessageModel.fromJson(
                              data['LAST_MSG_OBJ'] as Map<dynamic, dynamic>),
                          message.status = 1,
                          message.PRE_MSG_SEND_DATE =
                              messenger.chatList.value.length <= 1
                                  ? new DateTime.fromMillisecondsSinceEpoch(0)
                                      .toString()
                                  : messenger.chatList.value[1].SEND_DATE,
                          messenger.chatList.value[0] = message,
                          // print("oke---------------"),
                        }
                      else
                        {
                          rm.messageModel?.PRE_MSG_SEND_DATE =
                              messenger.chatList.value.length <= 1
                                  ? new DateTime.fromMillisecondsSinceEpoch(0)
                                      .toString()
                                  : messenger.chatList.value[0].SEND_DATE,
                          stringFlag = rm.messageModel?.FILE_EXTN ?? "",
                          if (stringFlag.contains("audio"))
                            {
                              newAudioMessage.value = true,
                            },
                          messenger.chatList.insert(0, rm.messageModel),
                          print(
                              "oke------------------------------------------"),
                        },
                      // else
                      //   {
                      //     messenger.chatList.insert(0, rm.messageModel),
                      //   },
                      messenger.chatList.refresh(),
                      socketProvider.updateLastReadMessage(
                          rm.roomUid, rm.lastMsgUid)
                    }
                  else
                    {
                      Get.snackbar(
                        "New message",
                        "Có 1 tin nhắn mới trong room:" + rm.roomType ==
                                "IN_CONTACT_ROOM"
                            ? rm.contactRoomName!
                            : rm.roomDefaultName,
                        icon: Icon(Icons.message, color: Colors.white),
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 5),
                      ),
                    }
                }
              else
                {
                  if (rm.roomType == "IN_CONTACT_ROOM")
                    {
                      if (messenger.currentUser.value.USER_UID != rm.regUserUid)
                        {
                          rm.contactRoomName =
                              getEmployeeByUserUid(rm.regUserUid).USER_NM_KOR,
                        }
                    },
                  if (rm.messageModel?.USER_UID != null &&
                      rm.messageModel?.USER_UID !=
                          messenger.currentUser.value.USER_UID)
                    {
                      rm.unReadMsgCount++,
                      print(rm.unReadMsgCount),
                    },
                  messenger.listRoom.value.insert(0, rm),
                  messenger.listRoom.refresh(),
                  messenger.listRoomFlag.value = messenger.listRoom.value,
                },
              updateNotification(),
              // print(messenger.listRoom.value),
            });

    roomSocket.on(
        "sendMessageCall",
        (data) => {
              if (data != null)
                {
                  message =
                      MessageModel.fromJson(data as Map<dynamic, dynamic>),
                  roomMessage = messenger.listRoom.value.firstWhereOrNull(
                      (element) => element.roomUid == message.ROOM_UID),
                  if (roomMessage != null)
                    {
                      index = messenger.listRoom.value.indexOf(roomMessage),
                      roomMessage.messageModel = message,
                      if (messenger.selectedRoom?.roomUid !=
                              roomMessage.roomUid &&
                          message.USER_UID != null)
                        {
                          roomMessage.unReadMsgCount++,
                          print(
                              "------------------------------------------------------------------"),
                          print(roomMessage.unReadMsgCount),
                        },
                      messenger.listRoom.value.removeAt(index),
                      messenger.listRoom.value.insert(0, roomMessage),
                      messenger.listRoom.refresh(),
                      messenger.listRoomFlag.value = messenger.listRoom.value,
                      messenger.listRoomFlag.refresh(),
                    },
                  if (roomMessage.roomUid == messenger.selectedRoom?.roomUid)
                    {
                      messenger.chatList.insert(0, roomMessage.messageModel),
                      messenger.chatList.refresh(),
                      socketProvider.updateLastReadMessage(
                          roomMessage.roomUid, message.MSG_UID)
                    },
                  updateNotification(),
                },
            });

    roomSocket.on(
        "memberJoinRoom",
        (data) => {
              //print("memberJoinRoom----------------------"),
              rm = Room.fromJson(data as Map<dynamic, dynamic>),
              messenger.listRoom.value.insert(0, rm),
              messenger.listRoom.refresh(),
              messenger.listRoomFlag.value = messenger.listRoom.value,
            });

    roomSocket.on(
        "typing_check",
        (data) => {
              if (data != null &&
                  data["isTyping"] &&
                  messenger.selectedRoom?.roomUid == data["ROOM_UID"])
                {
                  isTyping.value = true,
                }
              else
                {
                  isTyping.value = false,
                }
            });
    var list;
    var empContact;
    roomSocket.on(
        "onlineMember",
        (data) => {
              if (data != null)
                {
                  //print(data),
                  for (var i in data)
                    {
                      if (i != messenger.currentUser.value.USER_UID)
                        {
                          list = messenger.listRoom.value
                              .where((element) =>
                                  element.memberUidList.contains(i))
                              .toList(),
                          if (list != null && list.length > 0)
                            {
                              for (var item in list)
                                {
                                  messenger.listRoom.value
                                      .firstWhere((element) =>
                                          element.roomUid == item.roomUid)
                                      .isOnline = true,
                                }
                            }
                        },
                      empContact = messenger.contactList.value
                          .firstWhereOrNull((element) => element.USER_UID == i),
                      if (empContact != null)
                        {
                          empContact.ONLINE_YN = 'Y',
                        }
                    },
                },
              messenger.contactList.refresh(),
              messenger.contactListFlag.value = messenger.contactList.value,
              messenger.listRoom.refresh(),
              messenger.listRoomFlag.value = messenger.listRoom.value,
            });
    var roomFlag;
    var userFlag;
    roomSocket.on(
        "offlineMember",
        (data) => {
              if (data != null)
                {
                  empContact = messenger.contactList.value
                      .firstWhereOrNull((element) => element.USER_UID == data),
                  if (empContact != null)
                    {
                      empContact.ONLINE_YN = 'N',
                    },
                  //print(data),
                  if (data != messenger.currentUser.value.USER_UID)
                    {
                      list = messenger.listRoom.value
                          .where(
                              (element) => element.memberUidList.contains(data))
                          .toList(),
                      // list room chứa member offline
                      if (list != null && list.length > 0)
                        {
                          for (var item in list) // for từng room trong list
                            {
                              roomFlag = messenger.listRoom.value.firstWhere(
                                  (element) => element.roomUid == item.roomUid),

                              // check từng thành viên trong room xem có offline không
                              // tất cả offline thì phòng offline
                              roomFlag.isOnline = false,
                              for (var id in roomFlag.memberUidList)
                                {
                                  userFlag = messenger.contactList.value
                                      .firstWhereOrNull(
                                          (element) => element.USER_UID == id),
                                  if (userFlag != null &&
                                      userFlag.ONLINE_YN == 'Y' &&
                                      userFlag.USER_UID !=
                                          messenger.currentUser.value.USER_UID)
                                    {
                                      roomFlag.isOnline = true,
                                    }
                                }
                            },
                          messenger.listRoom.refresh(),
                          messenger.listRoomFlag.value =
                              messenger.listRoom.value,
                        }
                    },
                },
              messenger.contactList.refresh(),
              messenger.contactListFlag.value = messenger.contactList.value,
            });
    // Not tested
    roomSocket.on(
        "receiveCancelCall",
        (data) => {
              if (data != null && visibleIncomingCallDialog.value)
                {
                  // && navBarController.visibleIncomingCallDialog.value
                  Get.back(),
                  // messenger.callRoom.value = CallRoom(),
                },
            });

    roomSocket.on(
        "receiveTerminatedCall",
        (data) async => {
              if (data != null)
                {
                  print(callController.room.value),
                  if (callController.room.value.isSuccess)
                    {
                      callController.forcedEnd(),
                      await JitsiMeet.closeMeeting(),
                      callController.isEnded(),
                    }
                },
            });
    roomSocket.on(
        "receiveRejected",
        (data) async => {
              if (data != null)
                {
                  if (Get.currentRoute == callscreen)
                    {
                      callController.isRejected(),
                    }
                  else
                    {
                      if (callController.room.value.isSuccess)
                        {
                          callController.forcedEnd(),
                          await JitsiMeet.closeMeeting(),
                        }
                    }
                },
            });
    roomSocket.on(
        "receiveBusy",
        (data) => {
              if (data != null)
                {
                  if (Get.currentRoute == callscreen &&
                      callController.roomId == data['ROOM_ID'])
                    {
                      callController.isBusy(),
                    }
                },
            });
    roomSocket.on(
        "receiveUnavailableCallee",
        (data) => {
              if (data != null)
                {
                  if (Get.currentRoute == callscreen &&
                      callController.roomId == data['ROOM_ID'])
                    {
                      callController.isUnavailable(),
                    }
                },
            });

    roomSocket.on(
        "sendSocketLeftAll",
        (data) => {
              if (data != null)
                {
                  Get.defaultDialog(
                    title: "Notification",
                    confirm: IconButton(
                        onPressed: () async {
                          Get.back();
                          callController.forcedEnd();
                          await JitsiMeet.closeMeeting();
                        },
                        icon: Icon(Icons.check, color: Colors.green)),
                    cancel: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.cancel, color: Colors.red)),
                    middleText: "Everyone has left the room. Quit call ?",
                    backgroundColor: Colors.white,
                    titleStyle: TextStyle(color: Colors.red),
                    middleTextStyle: TextStyle(color: Colors.black),
                  )
                },
            });

    roomSocket.on(
        "receiveEndCall",
        (data) async => {
              if (data != null)
                {
                  if (Get.isDialogOpen == true)
                    {
                      Get.back(),
                    }
                  else
                    {
                      if (callController.room.value.isSuccess)
                        {
                          callController.forcedEnd(),
                          await JitsiMeet.closeMeeting(),
                          callController.isEnded(),
                        }
                    }
                },
            });

    roomSocket.on(
        "receiveSignalJoinCall",
        (data) => {
              if (data != null)
                {
                  if (data['CALL_USER_UID'] ==
                      messenger.currentUser.value.USER_UID)
                    {
                      if (Get.currentRoute == callscreen)
                        {callController.isPickedUp()},
                      if (data['TYPE_CALL'] != null)
                        {
                          joinMeeting(data, true, true),
                        }
                      else
                        {
                          joinMeeting(data, true, false),
                        }
                    }
                },
            });

    // Catch receiveIncomeCall socket and emit sendJoinCall or sendRejectCall

    roomSocket.on(
        "receiveIncomeCall",
        (data) => {
              print(
                  "----------------------------////------------------------------"),
              if (data != null)
                {
                  // if(messenger.callRoom.value.ROOM_ID == null || messenger.callRoom.value.ROOM_ID == ""){
                  //
                  // }else{
                  if (data['USER_UID'] != messenger.currentUser.value.USER_UID)
                    {
                      callController.roomChat = messenger.listRoom.value
                          .firstWhere(
                              (element) => element.roomUid == data['ROOM_UID']),
                      print("test state"),
                      if (appState == AppLifecycleState.detached) {},

                      FlutterCallkitIncoming.onEvent.listen((event) async {
                        print('HOME: $event');
                        switch (event!.name) {
                          case CallEvent.ACTION_CALL_INCOMING:
                            // TODO: received an incoming call
                            break;
                          case CallEvent.ACTION_CALL_START:
                            // TODO: started an outgoing call
                            // TODO: show screen calling in Flutter
                            break;
                          case CallEvent.ACTION_CALL_ACCEPT:
                            if (data['TYPE_CALL'] != null) {
                              roomSocket.emit("sendJoinCall", {
                                "ROOM_ID": data['ROOM_ID'],
                                "ROOM_TYPE": data['ROOM_TYPE'],
                                "USER_UID":
                                    messenger.currentUser.value.USER_UID,
                                "ROOM_UID": data['ROOM_UID'],
                                "CALL_USER_UID": data['USER_UID'],
                                "TYPE_CALL": "AUDIO"
                              });
                              data['CALL_USER_UID'] = data['USER_UID'];
                              visibleIncomingCallDialog.value = false;
                              Get.back();
                              callController.roomId.value = data['ROOM_ID'];
                              callController.isCallAudio.value = true;
                              callController.isPickedUp();
                              Get.toNamed(callscreen);
                              joinMeeting(data, false, true);
                            } else {
                              roomSocket.emit("sendJoinCall", {
                                "ROOM_ID": data['ROOM_ID'],
                                "ROOM_TYPE": data['ROOM_TYPE'],
                                "USER_UID":
                                    messenger.currentUser.value.USER_UID,
                                "ROOM_UID": data['ROOM_UID'],
                                "CALL_USER_UID": data['USER_UID']
                              });
                              data['CALL_USER_UID'] = data['USER_UID'];

                              visibleIncomingCallDialog.value = false;
                              Get.back();
                              callController.isPickedUp();
                              Get.toNamed(callscreen);
                              joinMeeting(data, false, false);
                            }

                            messenger.callRoom.value.ROOM_ID = data['ROOM_ID'];
                            messenger.callRoom.value.ROOM_UID =
                                data['ROOM_UID'];
                            messenger.callRoom.value.CALL_USER_UID =
                                data['CALL_USER_UID'];
                            messenger.callRoom.value.ROOM_TYPE =
                                data['ROOM_TYPE'];
                            messenger.callRoom.value.TYPE_CALL =
                                data['TYPE_CALL'] != null ? "AUDIO" : "CALL";

                            break;
                          case CallEvent.ACTION_CALL_DECLINE:
                            // TODO: declined an incoming call
                            if (appState == AppLifecycleState.detached) {
                              print("terminated");
                            }
                            roomSocket.emit("sendRejectCall", {
                              "ROOM_ID": data['ROOM_ID'],
                              "ROOM_TYPE": data['ROOM_TYPE'],
                              "USER_UID": messenger.currentUser.value.USER_UID,
                              "ROOM_UID": data['ROOM_UID'],
                              "CALL_USER_UID": data['USER_UID']
                            });
                            visibleIncomingCallDialog.value = false;
                            break;
                          case CallEvent.ACTION_CALL_ENDED:
                            // TODO: ended an incoming/outgoing call
                            break;
                          case CallEvent.ACTION_CALL_TIMEOUT:
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
                          case CallEvent
                              .ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
                            // TODO: only iOS
                            break;
                        }
                      }),

                      // navBarController =  Get.find(),
                      visibleIncomingCallDialog.value = true,
                      callController.roomId.value = data['ROOM_ID'],
                      Future.delayed(const Duration(seconds: waitCall), () {
                        if (visibleIncomingCallDialog.value &&
                            data['ROOM_ID'] == callController.roomId.value) {
                          roomSocket.emit("sendRejectCall", {
                            "ROOM_ID": data['ROOM_ID'],
                            "ROOM_TYPE": data['ROOM_TYPE'],
                            "USER_UID": messenger.currentUser.value.USER_UID,
                            "TYPE": "busy",
                            "ROOM_UID": data['ROOM_UID'],
                            "CALL_USER_UID": data['USER_UID']
                          });
                          Get.back();
                        }
                      }),
                      callController.infoRoomCall = data,
                      callController.isComingCall(),
                      Get.toNamed(callscreen),
                      // Get.defaultDialog(
                      //   title: "Imcoming Call",
                      //   confirm: IconButton(
                      //       onPressed: () {
                      //         // Can Use joinMeeting function below
                      //         if (data['TYPE_CALL'] != null) {
                      //           roomSocket.emit("sendJoinCall", {
                      //             "ROOM_ID": data['ROOM_ID'],
                      //             "ROOM_TYPE": data['ROOM_TYPE'],
                      //             "USER_UID":
                      //                 messenger.currentUser.value.USER_UID,
                      //             "ROOM_UID": data['ROOM_UID'],
                      //             "CALL_USER_UID": data['USER_UID'],
                      //             "TYPE_CALL": "AUDIO"
                      //           });
                      //           data['CALL_USER_UID'] = data['USER_UID'];
                      //           visibleIncomingCallDialog.value = false;
                      //           Get.back();
                      //           callController.roomId.value = data['ROOM_ID'];
                      //           callController.isCallAudio.value = true;
                      //           callController.isPickedUp();
                      //           Get.toNamed(callscreen);
                      //           joinMeeting(data, false, true);
                      //         } else {
                      //           roomSocket.emit("sendJoinCall", {
                      //             "ROOM_ID": data['ROOM_ID'],
                      //             "ROOM_TYPE": data['ROOM_TYPE'],
                      //             "USER_UID":
                      //                 messenger.currentUser.value.USER_UID,
                      //             "ROOM_UID": data['ROOM_UID'],
                      //             "CALL_USER_UID": data['USER_UID']
                      //           });
                      //           data['CALL_USER_UID'] = data['USER_UID'];
                      //
                      //           visibleIncomingCallDialog.value = false;
                      //           Get.back();
                      //           callController.isPickedUp();
                      //           Get.toNamed(callscreen);
                      //           joinMeeting(data, false, false);
                      //         }
                      //         callController.roomChat = messenger.listRoom.value
                      //             .firstWhere((element) =>
                      //                 element.roomUid == data['ROOM_UID']);
                      //         messenger.callRoom.value.ROOM_ID =
                      //             data['ROOM_ID'];
                      //         messenger.callRoom.value.ROOM_UID =
                      //             data['ROOM_UID'];
                      //         messenger.callRoom.value.CALL_USER_UID =
                      //             data['CALL_USER_UID'];
                      //         messenger.callRoom.value.ROOM_TYPE =
                      //             data['ROOM_TYPE'];
                      //         messenger.callRoom.value.TYPE_CALL =
                      //             data['TYPE_CALL'] != null ? "AUDIO" : "CALL";
                      //       },
                      //       icon: Icon(Icons.check, color: Colors.green)),
                      //   cancel: IconButton(
                      //       onPressed: () {
                      //         roomSocket.emit("sendRejectCall", {
                      //           "ROOM_ID": data['ROOM_ID'],
                      //           "ROOM_TYPE": data['ROOM_TYPE'],
                      //           "USER_UID":
                      //               messenger.currentUser.value.USER_UID,
                      //           "ROOM_UID": data['ROOM_UID'],
                      //           "CALL_USER_UID": data['USER_UID']
                      //         });
                      //         visibleIncomingCallDialog.value = false;
                      //         Get.back();
                      //       },
                      //       icon: Icon(Icons.cancel, color: Colors.red)),
                      //   middleText: "Accept Call ?",
                      //   backgroundColor: Colors.white,
                      //   titleStyle: TextStyle(color: Colors.red),
                      //   middleTextStyle: TextStyle(color: Colors.black),
                      // )
                      // }
                    }
                },
            });
    roomSocket.on(
        "receiveChangeUserState",
        (data) => {
              if (data != null)
                {
                  // print("**********************************"),
                  // print(data),
                  if (data['IS_ONLINE'] == "false")
                    {
                      empContact = messenger.contactList.value.firstWhereOrNull(
                          (element) => element.USER_UID == data['userUid']),
                      if (empContact != null) empContact.ONLINE_YN = 'N',
                    }
                  else
                    {
                      empContact = messenger.contactList.value.firstWhereOrNull(
                          (element) => element.USER_UID == data['userUid']),
                      if (empContact != null) empContact.ONLINE_YN = 'Y',
                    }
                },
              messenger.contactList.refresh(),
              messenger.contactListFlag.value = messenger.contactList.value,
            });

    roomSocket.on(
        "removeRoom",
        (data) => {
              if (data != null)
                {
                  //print(data),
                  if (data["USER_UID"] == messenger.currentUser.value.USER_UID)
                    {
                      roomMessage = messenger.listRoom.value.firstWhere(
                          (element) => element.roomUid == data["ROOM_UID"]),
                      index = messenger.listRoom.value.indexOf(roomMessage),
                      if (index >= 0)
                        {
                          messenger.listRoom.value.removeAt(index),
                          messenger.listRoom.refresh(),
                          messenger.listRoomFlag.value =
                              messenger.listRoom.value,
                        },
                      if (messenger.selectedRoom?.roomUid == data["ROOM_UID"])
                        {
                          Get.offAndToNamed('/Chat_Screen'),
                          // navBarController.onItemTapped(0),
                        }
                    }
                }
            });

    roomSocket.on(
        "receiveChangeRoomName",
        (data) => {
              if (data != null)
                {
                  for (int i = 0; i < messenger.listRoom.value.length; i++)
                    {
                      if (messenger.listRoom[i].roomUid == data["ROOM_UID"])
                        {
                          messenger.listRoom[i].roomDefaultName =
                              data["ROOM_NM"],
                          messenger.listRoom.refresh(),
                          messenger.listRoomFlag.value =
                              messenger.listRoom.value,
                        }
                    },
                  if (messenger.selectedRoom?.roomUid == data["ROOM_UID"])
                    {
                      messenger.selectedRoom?.roomDefaultName = data["ROOM_NM"],
                      messenger.roomNameSelected.value = data["ROOM_NM"],
                    }
                }
            });

    roomSocket.on("exception", (data) => print(data));
    roomSocket.on("disconnect", (data) => print("Disconnect socket to sever"));
  }

  updateNotification() {
    var listRoom = messenger.listRoomFlag.value
        .where((element) => element.unReadMsgCount > 0)
        .toList();
    messenger.totalRoomUnReadMessage.value = listRoom.length;
  }

  getEmployeeByUserUid(var userUid) {
    return messenger.contactListFlag.value
        .firstWhereOrNull((element) => userUid == element.USER_UID);
  }

  getOnlineMember(var listMember) async {
    roomSocket.io.options['extraHeaders'] = {
      "Content-Type": "application/json"
    };
    var list;
    var empContact;
    roomSocket.emit("getUserOnline");
    roomSocket.on(
        "onlineMember",
        (data) => {
              for (var i in data)
                {
                  if (i != messenger.currentUser.value.USER_UID)
                    {
                      list = messenger.listRoom.value
                          .where((element) => element.memberUidList.contains(i))
                          .toList(),
                      if (list != null && list.length > 0)
                        {
                          for (var item in list)
                            {
                              messenger.listRoom.value
                                  .firstWhere((element) =>
                                      element.roomUid == item.roomUid)
                                  .isOnline = true,
                            }
                        }
                    },
                  empContact = messenger.contactList.value
                      .firstWhereOrNull((element) => element.USER_UID == i),
                  if (empContact != null)
                    {
                      empContact.ONLINE_YN = 'Y',
                    }
                },
              messenger.listRoomFlag.value = messenger.listRoom.value,
            });
  }

  makeCall(var room, bool isCallAudio) {
    var roomChatUid = room.roomUid.toString();
    var roomId = DateTime.now().millisecondsSinceEpoch.toString() + roomChatUid;
    String? roomName = messenger.selectedRoom?.roomType == "IN_CONTACT_ROOM"
        ? messenger.selectedRoom?.contactRoomName
        : messenger.selectedRoom?.roomDefaultName;
    if (isCallAudio) {
      roomSocket.emit("sendCreateCall", {
        "ROOM_NAME": roomName,
        "USER_UID": messenger.currentUser.value.USER_UID,
        "ROOM_ID": roomId,
        "ROOM_TYPE": room.roomType,
        "ROOM_UID": room.roomUid,
        "TYPE_CALL": "AUDIO"
      });
    } else {
      roomSocket.emit("sendCreateCall", {
        "ROOM_NAME": roomName,
        "USER_UID": messenger.currentUser.value.USER_UID,
        "ROOM_ID": roomId,
        "ROOM_TYPE": room.roomType,
        "ROOM_UID": room.roomUid,
      });
    }
    messenger.callRoom.value.ROOM_ID = roomId;
    messenger.callRoom.value.ROOM_UID = room.roomUid;
    messenger.callRoom.value.CALL_USER_UID =
        messenger.currentUser.value.USER_UID;
    messenger.callRoom.value.ROOM_TYPE = room.roomType;
    messenger.callRoom.value.TYPE_CALL = isCallAudio ? "AUDIO" : "CALL";
    return roomId;
  }

  Future<void> makeFakeCallInComing(
      var roomType, var ROOM_UID, var userUid) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      this._currentUuid = Uuid().v4();
      String? nameCaller = "";
      var room;
      for (int i = 0; i < messenger.listRoom.length; i++) {
        if (messenger.listRoom[i].roomUid == ROOM_UID) {
          room = messenger.listRoom[i];
        }
      }
      print(room);
      if (roomType == "IN_CONTACT_ROOM") {
        nameCaller = room.contactRoomName + " is calling";
      } else {
        nameCaller = room.roomDefaultName + " is calling";
      }
      var params = <String, dynamic>{
        'id': _currentUuid,
        'nameCaller': nameCaller,
        'appName': 'Callkit',
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
}
