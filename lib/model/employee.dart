class Employee {
  String? USER_CHECK;
  String? USER_NM_KOR;
  String? USE_CHECK;
  String? USER_EMAIL;
  String? USER_ID;
  String? USER_UID;
  String? DEPT_NM;
  String? DEPT_CD;
  int? DEPT_LEV;
  String? ROOM_OPEN_CHECK;
  String? ONLINE_YN;
  String? POSITION;
  int? POSITION_ORDER;
  String? USER_PHONE;
  String? UP_DEPT_CODE;
  String? USER_NM_ENG;
  String? USER_IMG;
  String? ADDED_FRIEND;
  int? IS_FRIEND;

  Employee(
      {this.USER_CHECK,
      this.USER_NM_KOR,
      this.USE_CHECK,
      this.USER_EMAIL,
      this.USER_ID,
      this.USER_UID,
      this.DEPT_NM,
      this.DEPT_CD,
      this.DEPT_LEV,
      this.ROOM_OPEN_CHECK,
      this.ONLINE_YN,
      this.POSITION,
      this.POSITION_ORDER,
      this.USER_PHONE,
      this.UP_DEPT_CODE,
      this.USER_NM_ENG,
      this.USER_IMG,
      this.ADDED_FRIEND,
      this.IS_FRIEND});

  @override
  String toString() {
    return 'Employee{USER_CHECK: $USER_CHECK, USER_NM_KOR: $USER_NM_KOR, USE_CHECK: $USE_CHECK, USER_EMAIL: $USER_EMAIL, USER_ID: $USER_ID, USER_UID: $USER_UID, DEPT_NM: $DEPT_NM, DEPT_CD: $DEPT_CD, DEPT_LEV: $DEPT_LEV, ROOM_OPEN_CHECK: $ROOM_OPEN_CHECK, ONLINE_YN: $ONLINE_YN, POSITION: $POSITION, POSITION_ORDER: $POSITION_ORDER, USER_PHONE: $USER_PHONE, UP_DEPT_CODE: $UP_DEPT_CODE, USER_NM_ENG: $USER_NM_ENG, USER_IMG: $USER_IMG, ADDED_FRIEND: $ADDED_FRIEND, IS_FRIEND: $IS_FRIEND}';
  }

  Employee.fromJson(Map<String, dynamic> json) {
    USER_CHECK = json['USER_CHECK'];
    USER_NM_KOR = json['USER_NM_KOR'];
    USE_CHECK = json['USE_CHECK'];
    USER_EMAIL = json['USER_EMAIL'];
    USER_ID = json['USER_ID'];
    USER_UID = json['USER_UID'];
    DEPT_NM = json['DEPT_NM'];
    DEPT_CD = json['DEPT_CD'];
    DEPT_LEV = json['DEPT_LEV'];
    ROOM_OPEN_CHECK = json['ROOM_OPEN_CHECK'];
    ONLINE_YN = json['ONLINE_YN'];
    POSITION = json['POSITION'];
    POSITION_ORDER = json['POSITION_ORDER'];
    USER_PHONE = json['USER_PHONE'];
    UP_DEPT_CODE = json['UP_DEPT_CODE'];
    USER_NM_ENG = json['USER_NM_ENG'];
    USER_IMG = json['USER_IMG'];
    ADDED_FRIEND = json['ADDED_FRIEND'];
    IS_FRIEND = json['IS_FRIEND'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USER_CHECK'] = this.USER_CHECK;
    data['USER_NM_KOR'] = this.USER_NM_KOR;
    data['USE_CHECK'] = this.USE_CHECK;
    data['USER_EMAIL'] = this.USER_EMAIL;
    data['USER_ID'] = this.USER_ID;
    data['USER_UID'] = this.USER_UID;
    data['DEPT_NM'] = this.DEPT_NM;
    data['DEPT_CD'] = this.DEPT_CD;
    data['DEPT_LEV'] = this.DEPT_LEV;
    data['ROOM_OPEN_CHECK'] = this.ROOM_OPEN_CHECK;
    data['ONLINE_YN'] = this.ONLINE_YN;
    data['POSITION'] = this.POSITION;
    data['POSITION_ORDER'] = this.POSITION_ORDER;
    data['USER_PHONE'] = this.USER_PHONE;
    data['UP_DEPT_CODE'] = this.UP_DEPT_CODE;
    data['USER_IMG'] = this.USER_IMG;
    data['ADDED_FRIEND'] = this.ADDED_FRIEND;
    data['IS_FRIEND'] = this.IS_FRIEND;

    return data;
  }

  List<Employee> listFromJson(list) =>
      List<Employee>.from(list.map((x) => Employee.fromJson(x)));
}
