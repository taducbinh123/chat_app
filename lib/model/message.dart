class MessageModel {
  String? ROOM_UID;
  String? MSG_UID;
  String? MSG_CONT;
  String? MSG_TYPE_CODE;
  String? SEND_DATE;
  String? USER_UID;

  MessageModel(
      {this.ROOM_UID,
      this.MSG_UID,
      this.MSG_CONT,
      this.MSG_TYPE_CODE,
      this.SEND_DATE,
      this.USER_UID});

  @override
  String toString() {
    return 'MessageModel{ROOM_UID: $ROOM_UID, MSG_UID: $MSG_UID, MSG_CONT: $MSG_CONT, MSG_TYPE_CODE: $MSG_TYPE_CODE, SEND_DATE: $SEND_DATE, USER_UID: $USER_UID}';
  }

  MessageModel.fromJson(Map<dynamic, dynamic> json) {
    ROOM_UID = json['ROOM_UID'];
    MSG_UID = json['MSG_UID'];
    MSG_CONT = json['MSG_CONT'];
    MSG_TYPE_CODE = json['MSG_TYPE_CODE'];
    SEND_DATE = json['SEND_DATE'];
    USER_UID = json['USER_UID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ROOM_UID'] = this.ROOM_UID;
    data['MSG_UID'] = this.MSG_UID;
    data['MSG_CONT'] = this.MSG_CONT;
    data['MSG_TYPE_CODE'] = this.MSG_TYPE_CODE;
    data['SEND_DATE'] = this.SEND_DATE;
    data['USER_UID'] = this.USER_UID;

    return data;
  }
}
