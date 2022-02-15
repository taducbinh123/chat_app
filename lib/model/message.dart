class MessageModel {
  String? mSGCONT;
  String? mSGUID;
  String? uSERNMENG;
  String? uSERNMKOR;
  String? rYN;
  String? uSERIMG;
  String? rEADMEMBERS;
  String? uSERID;
  String? rOOMUID;
  String? uSERUID;
  String? mSGTYPECODE;
  int? sENDDATE;

  MessageModel(
      {this.mSGCONT,
      this.mSGUID,
      this.uSERNMENG,
      this.uSERNMKOR,
      this.rYN,
      this.uSERIMG,
      this.rEADMEMBERS,
      this.uSERID,
      this.rOOMUID,
      this.uSERUID,
      this.mSGTYPECODE,
      this.sENDDATE});

  MessageModel.fromJson(Map<String, dynamic> json) {
    mSGCONT = json['MSG_CONT'];
    mSGUID = json['MSG_UID'];
    uSERNMENG = json['USER_NM_ENG'];
    uSERNMKOR = json['USER_NM_KOR'];
    rYN = json['RYN'];
    uSERIMG = json['USER_IMG'];
    rEADMEMBERS = json['READ_MEMBERS'];
    uSERID = json['USER_ID'];
    rOOMUID = json['ROOM_UID'];
    uSERUID = json['USER_UID'];
    mSGTYPECODE = json['MSG_TYPE_CODE'];
    sENDDATE = json['SEND_DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MSG_CONT'] = this.mSGCONT;
    data['MSG_UID'] = this.mSGUID;
    data['USER_NM_ENG'] = this.uSERNMENG;
    data['USER_NM_KOR'] = this.uSERNMKOR;
    data['RYN'] = this.rYN;
    data['USER_IMG'] = this.uSERIMG;
    data['READ_MEMBERS'] = this.rEADMEMBERS;
    data['USER_ID'] = this.uSERID;
    data['ROOM_UID'] = this.rOOMUID;
    data['USER_UID'] = this.uSERUID;
    data['MSG_TYPE_CODE'] = this.mSGTYPECODE;
    data['SEND_DATE'] = this.sENDDATE;
    return data;
  }
}
