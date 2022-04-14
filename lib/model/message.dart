class MessageModel {
  String? ROOM_UID;
  String? MSG_UID;
  String? MSG_CONT;
  String? MSG_TYPE_CODE;
  String? SEND_DATE;
  String? USER_UID;
  String? FILE_EXTN;
  String? FILE_ORI_NM;
  String? FILE_TYPE;
  String? FILE_PATH;

  MessageModel(
      {this.ROOM_UID,
      this.MSG_UID,
      this.MSG_CONT,
      this.MSG_TYPE_CODE,
      this.SEND_DATE,
      this.USER_UID,
      this.FILE_EXTN,
      this.FILE_ORI_NM,
      this.FILE_TYPE,
      this.FILE_PATH});

  @override
  String toString() {
    return 'MessageModel{ROOM_UID: $ROOM_UID, MSG_UID: $MSG_UID, MSG_CONT: $MSG_CONT, MSG_TYPE_CODE: $MSG_TYPE_CODE, SEND_DATE: $SEND_DATE, USER_UID: $USER_UID, FILE_EXTN: $FILE_EXTN, FILE_ORI_NM: $FILE_ORI_NM, FILE_TYPE: $FILE_TYPE, FILE_PATH: $FILE_PATH}';
  }

  MessageModel.fromJson(Map<dynamic, dynamic> json) {
    ROOM_UID = json['ROOM_UID'];
    MSG_UID = json['MSG_UID'];
    MSG_CONT = json['MSG_CONT'];
    MSG_TYPE_CODE = json['MSG_TYPE_CODE'];
    SEND_DATE = json['SEND_DATE'];
    USER_UID = json['USER_UID'];
    FILE_EXTN = json['FILE_EXTN'];
    FILE_ORI_NM = json['FILE_ORI_NM'];
    FILE_TYPE = json['FILE_TYPE'];
    FILE_PATH = json['FILE_PATH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ROOM_UID'] = this.ROOM_UID;
    data['MSG_UID'] = this.MSG_UID;
    data['MSG_CONT'] = this.MSG_CONT;
    data['MSG_TYPE_CODE'] = this.MSG_TYPE_CODE;
    data['SEND_DATE'] = this.SEND_DATE;
    data['USER_UID'] = this.USER_UID;
    data['FILE_EXTN'] = this.FILE_EXTN;
    data['FILE_ORI_NM'] = this.FILE_ORI_NM;
    data['FILE_TYPE'] = this.FILE_TYPE;
    data['FILE_PATH'] = this.FILE_PATH;

    return data;
  }
}
