class CallRoom {
  String? ROOM_ID;
  String? ROOM_TYPE;
  String? TYPE_CALL;
  String? ROOM_UID;
  String? CALL_USER_UID;

  CallRoom({
    this.ROOM_ID,
    this.ROOM_TYPE,
    this.TYPE_CALL,
    this.ROOM_UID,
    this.CALL_USER_UID,
  });

  @override
  String toString() {
    return 'CallRoom{ROOM_ID: $ROOM_ID, ROOM_TYPE: $ROOM_TYPE, TYPE_CALL: $TYPE_CALL, ROOM_UID: $ROOM_UID, CALL_USER_UID: $CALL_USER_UID}';
  }

}