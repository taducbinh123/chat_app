class HistoryItem {
  String? ROOM_UID;
  String? USER_UID;
  int? STATUS;
  String? CREATED_DATE;
  String? UPDATED_DATE;
  int? ROLE;

  HistoryItem(
      {this.USER_UID,
      this.ROOM_UID,
      this.STATUS,
      this.CREATED_DATE,
      this.UPDATED_DATE,
      this.ROLE});

  HistoryItem.fromJson(Map<dynamic, dynamic> json) {
    USER_UID = json['USER_UID'];
    ROOM_UID = json['ROOM_UID'];
    STATUS = json['STATUS'];
    CREATED_DATE = json['CREATED_DATE'];
    UPDATED_DATE = json['UPDATED_DATE'];
    ROLE = json['ROLE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ROOM_UID'] = this.ROOM_UID;
    data['USER_UID'] = this.USER_UID;
    data['STATUS'] = this.STATUS;
    data['CREATED_DATE'] = this.CREATED_DATE;
    data['UPDATED_DATE'] = this.UPDATED_DATE;
    data['ROLE'] = this.ROLE;

    return data;
  }
}
