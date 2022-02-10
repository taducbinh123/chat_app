import 'package:flutter/cupertino.dart';
import 'package:hello_world_flutter/model/chat_card.dart';

class Room {
  final List<Chat> listChats;
  final String roomUid;
  final DateTime regDate;
  final DateTime modiDate;
  final String regUserUid;
  final String modiUserUid;
  final String roomDefaultName;
  final String roomType;
  final String keyRoom;
  final String roomImg;
  final String notifyType;

  Room(
      {required this.listChats,
      required this.roomUid,
      required this.regDate,
      required this.modiDate,
      required this.regUserUid,
      required this.modiUserUid,
      required this.roomDefaultName,
      required this.roomType,
      required this.keyRoom,
      required this.roomImg,
      required this.notifyType});

  @override
  String toString() {
    return 'Room{listChats: $listChats, roomUid: $roomUid, regDate: $regDate, modiDate: $modiDate, regUserUid: $regUserUid, modiUserUid: $modiUserUid, roomDefaultName: $roomDefaultName, roomType: $roomType, keyRoom: $keyRoom, roomImg: $roomImg, notifyType: $notifyType}';
  }
}

var roomsData = [
  Room(
      listChats: [chatsData[0],chatsData[1]],
      roomUid: "1",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[0].id,
      modiUserUid: chatsData[0].id,
      roomDefaultName: chatsData[0].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[1]],
      roomUid: "2",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[1].id,
      modiUserUid: chatsData[1].id,
      roomDefaultName: chatsData[1].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[2]],
      roomUid: "3",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[2].id,
      modiUserUid: chatsData[2].id,
      roomDefaultName: chatsData[2].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[3]],
      roomUid: "4",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[3].id,
      modiUserUid: chatsData[3].id,
      roomDefaultName: chatsData[3].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[4]],
      roomUid: "5",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[4].id,
      modiUserUid: chatsData[4].id,
      roomDefaultName: chatsData[4].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[5]],
      roomUid: "6",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[5].id,
      modiUserUid: chatsData[5].id,
      roomDefaultName: chatsData[5].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[6]],
      roomUid: "7",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[6].id,
      modiUserUid: chatsData[6].id,
      roomDefaultName: chatsData[6].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType"),
  Room(
      listChats: [chatsData[7]],
      roomUid: "8",
      regDate: DateTime.now(),
      modiDate: DateTime.now(),
      regUserUid: chatsData[7].id,
      modiUserUid: chatsData[7].id,
      roomDefaultName: chatsData[7].name,
      roomType: "roomType",
      keyRoom: "keyRoom",
      roomImg: "roomImg",
      notifyType: "notifyType")
];
