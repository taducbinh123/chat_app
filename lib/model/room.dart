import 'package:hello_world_flutter/model/message.dart';

class Room {
  String roomUid;
  String regDate;
  String modiDate;
  String regUserUid;
  String? modiUserUid;
  String roomDefaultName;
  String roomType;
  String keyRoom;
  String? roomImg;
  String? notifyType;
  int lastMsgUid;
  MessageModel messageModel;
  List memberUidList;
  bool? isOnline;

  Room({
    required this.roomUid,
    required this.regDate,
    required this.modiDate,
    required this.regUserUid,
    this.modiUserUid,
    required this.roomDefaultName,
    required this.roomType,
    required this.keyRoom,
    this.roomImg,
    this.notifyType,
    required this.lastMsgUid,
    required this.messageModel,
    required this.memberUidList,
    this.isOnline,
  });

  Room.fromJson(Map<dynamic, dynamic> json)
      : roomUid = json['ROOM_UID'] as String,
        regDate = json['REG_DATE'] as String,
        modiDate = json['MODI_DATE'] as String,
        regUserUid = json['REG_USER_UID'] as String,
        modiUserUid = json['MODI_USER_UID'],
        roomDefaultName = json['ROOM_DEFAULT_NAME'] as String,
        roomType = json['ROOM_TYPE'] as String,
        keyRoom = json['KEY_ROOM'] as String,
        roomImg = json['ROOM_IMG'],
        notifyType = json['NOTIFY_TYPE'],
        lastMsgUid = json['LAST_MSG_UID'],
        memberUidList = json['MEMBER_UID_LIST'] as List,
        messageModel = MessageModel.fromJson(json['LAST_MSG']),
        isOnline = json['isOnline'];

  Map<dynamic, dynamic> toJson() {
    return {
      'ROOM_UID': roomUid,
      'REG_DATE': regDate,
      'MODI_DATE': modiDate,
      'REG_USER_UID': regUserUid,
      'MODI_USER_UID': modiUserUid,
      'ROOM_DEFAULT_NAME': roomDefaultName,
      'ROOM_TYPE': roomType,
      'KEY_ROOM': keyRoom,
      'ROOM_IMG': roomImg,
      'NOTIFY_TYPE': notifyType,
      'LAST_MSG_UID': lastMsgUid,
      'LAST_MSG':messageModel,
      'MEMBER_UID_LIST':memberUidList,
      'isOnline':isOnline
    };
  }

  @override
  String toString() {
    return 'Room{roomUid: $roomUid, regDate: $regDate, modiDate: $modiDate, regUserUid: $regUserUid, modiUserUid: $modiUserUid, roomDefaultName: $roomDefaultName, roomType: $roomType, keyRoom: $keyRoom, roomImg: $roomImg, notifyType: $notifyType, lastMsgUid: $lastMsgUid, messageModel: $messageModel, memberUidList: $memberUidList, isOnline: $isOnline}';
  }
}

// var roomsData = [
//   Room(
//       listChats: [chatsData[0],chatsData[1]],
//       roomUid: "1",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[0].id,
//       modiUserUid: chatsData[0].id,
//       roomDefaultName: chatsData[0].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[1]],
//       roomUid: "2",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[1].id,
//       modiUserUid: chatsData[1].id,
//       roomDefaultName: chatsData[1].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[2]],
//       roomUid: "3",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[2].id,
//       modiUserUid: chatsData[2].id,
//       roomDefaultName: chatsData[2].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[3]],
//       roomUid: "4",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[3].id,
//       modiUserUid: chatsData[3].id,
//       roomDefaultName: chatsData[3].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[4]],
//       roomUid: "5",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[4].id,
//       modiUserUid: chatsData[4].id,
//       roomDefaultName: chatsData[4].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[5]],
//       roomUid: "6",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[5].id,
//       modiUserUid: chatsData[5].id,
//       roomDefaultName: chatsData[5].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[6]],
//       roomUid: "7",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[6].id,
//       modiUserUid: chatsData[6].id,
//       roomDefaultName: chatsData[6].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType"),
//   Room(
//       listChats: [chatsData[7]],
//       roomUid: "8",
//       regDate: DateTime.now(),
//       modiDate: DateTime.now(),
//       regUserUid: chatsData[7].id,
//       modiUserUid: chatsData[7].id,
//       roomDefaultName: chatsData[7].name,
//       roomType: "roomType",
//       keyRoom: "keyRoom",
//       roomImg: "roomImg",
//       notifyType: "notifyType")
// ];
