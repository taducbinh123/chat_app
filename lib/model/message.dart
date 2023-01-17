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
  int? IS_READ;
  String? UID_TIMESTAMP;
  int? STATUS;
  String _PRE_MSG_SEND_DATE = '0';
  String PRE_USER_UID = '';
  int? STATUS_CALL;
  int? ROLE_CALL;

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
      this.FILE_PATH,
      this.IS_READ,
      this.UID_TIMESTAMP,
      this.STATUS,
      this.STATUS_CALL,
      this.ROLE_CALL});


  @override
  String toString() {
    return 'MessageModel{ROOM_UID: $ROOM_UID, MSG_UID: $MSG_UID, MSG_CONT: $MSG_CONT, MSG_TYPE_CODE: $MSG_TYPE_CODE, SEND_DATE: $SEND_DATE, USER_UID: $USER_UID, FILE_EXTN: $FILE_EXTN, FILE_ORI_NM: $FILE_ORI_NM, FILE_TYPE: $FILE_TYPE, FILE_PATH: $FILE_PATH, IS_READ: $IS_READ, UID_TIMESTAMP: $UID_TIMESTAMP, STATUS: $STATUS, _PRE_MSG_SEND_DATE: $_PRE_MSG_SEND_DATE, STATUS_CALL: $STATUS_CALL, ROLE_CALL: $ROLE_CALL}';
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
    IS_READ = json['IS_READ'];
    UID_TIMESTAMP = json["UID_TIMESTAMP"];
    STATUS = 1;
    STATUS_CALL = json['STATUS_CALL'];
    ROLE_CALL = json["ROLE_CALL"];
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
    data['IS_READ'] = this.IS_READ;
    data['UID_TIMESTAMP'] = this.UID_TIMESTAMP;
    data['STATUS_CALL'] = this.STATUS_CALL;
    data['ROLE_CALL'] = this.ROLE_CALL;

    return data;
  }

  set status(int value) {
    this.STATUS = value;
  }

  String get PRE_MSG_SEND_DATE => _PRE_MSG_SEND_DATE;

  set PRE_MSG_SEND_DATE(String value) {
    _PRE_MSG_SEND_DATE = value;
  }
}


class MessageConfirm{
  String? USER_UID;
  String? MSG_UID;
  String? ROOM_UID;
  String? READ_CHECK;

  MessageConfirm({this.USER_UID, this.MSG_UID, this.ROOM_UID, this.READ_CHECK});

  @override
  String toString() {
    return 'MessageConfirm{USER_UID: $USER_UID, MSG_UID: $MSG_UID, ROOM_UID: $ROOM_UID, READ_CHECK: $READ_CHECK}';
  }

  MessageConfirm.fromJson(Map<dynamic, dynamic> json) {
    ROOM_UID = json['ROOM_UID'];
    MSG_UID = json['MSG_UID'];
    USER_UID = json['USER_UID'];
    READ_CHECK = json['READ_CHECK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ROOM_UID'] = this.ROOM_UID;
    data['MSG_UID'] = this.MSG_UID;
    data['USER_UID'] = this.USER_UID;
    data['READ_CHECK'] = this.READ_CHECK;

    return data;
  }
}
