import 'package:AMES/model/message.dart';

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
  int? lastMsgUid;
  int? lastReadMsgUid;
  MessageModel? messageModel;
  List? memberUidList;
  bool? isOnline;
  int unReadMsgCount;
  String? contactRoomName;
  String? timeLastMessageDisplay;
  String? userUidContact;

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
    this.lastMsgUid,
    this.lastReadMsgUid,
    this.messageModel,
    this.memberUidList,
    this.isOnline,
    required this.unReadMsgCount,
    this.contactRoomName,
    this.timeLastMessageDisplay,
    this.userUidContact
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
        messageModel = json['LAST_MSG'] != null
            ? MessageModel.fromJson(json['LAST_MSG'])
            : MessageModel(),
        isOnline = json['isOnline'],
        unReadMsgCount = json['UNREAD_MSG_COUNT'],
        lastReadMsgUid = json["LAST_READ_MSG_ID"],
        contactRoomName = json['CONTACT_ROOM_NM'];

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
      'LAST_MSG': messageModel,
      'MEMBER_UID_LIST': memberUidList,
      'isOnline': isOnline,
      'UNREAD_MSG_COUNT': unReadMsgCount,
      'LAST_READ_MSG_ID': lastReadMsgUid,
      'CONTACT_ROOM_NM': contactRoomName
    };
  }

  @override
  String toString() {
    return 'Room{roomUid: $roomUid, regDate: $regDate, modiDate: $modiDate, regUserUid: $regUserUid, modiUserUid: $modiUserUid, roomDefaultName: $roomDefaultName, roomType: $roomType, keyRoom: $keyRoom, roomImg: $roomImg, notifyType: $notifyType, lastMsgUid: $lastMsgUid, lastReadMsgUid: $lastReadMsgUid, messageModel: $messageModel, memberUidList: $memberUidList, isOnline: $isOnline, unReadMsgCount: $unReadMsgCount, contactRoomName: $contactRoomName, timeLastMessageDisplay: $timeLastMessageDisplay, userUidContact: $userUidContact}';
  }
}
