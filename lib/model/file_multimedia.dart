class FileModel{
  String FILE_ORI_NM;
  String FILE_PATH;
  int FILE_SIZE;
  String FILE_EXTN;
  String FILE_VALD_DATE;
  String FILE_LARGE_CHECK;
  String FILE_DEL_CHECK;
  String FILE_MODI_NM;
  String MSG_UID;
  String FILE_TYPE;

  FileModel({
      required this.FILE_ORI_NM,
      required this.FILE_PATH,
      required this.FILE_SIZE,
      required this.FILE_EXTN,
      required this.FILE_VALD_DATE,
      required this.FILE_LARGE_CHECK,
      required this.FILE_DEL_CHECK,
      required this.FILE_MODI_NM,
      required this.MSG_UID,
      required this.FILE_TYPE});

  @override
  String toString() {
    return 'FileMultimedia{FILE_ORI_NM: $FILE_ORI_NM, FILE_PATH: $FILE_PATH, FILE_SIZE: $FILE_SIZE, FILE_EXTN: $FILE_EXTN, FILE_VALD_DATE: $FILE_VALD_DATE, FILE_LARGE_CHECK: $FILE_LARGE_CHECK, FILE_DEL_CHECK: $FILE_DEL_CHECK, FILE_MODI_NM: $FILE_MODI_NM, MSG_UID: $MSG_UID, FILE_TYPE: $FILE_TYPE}';
  }

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      FileModel(
          FILE_ORI_NM: json['FILE_ORI_NM'],
          FILE_PATH: json['FILE_PATH'],
          FILE_SIZE : json['FILE_SIZE'],
          FILE_EXTN : json['FILE_EXTN'],
          FILE_VALD_DATE : json['FILE_VALD_DATE'],
          FILE_LARGE_CHECK : json['FILE_LARGE_CHECK'],
          FILE_DEL_CHECK : json['FILE_DEL_CHECK'],
          FILE_MODI_NM : json['FILE_MODI_NM'],
          MSG_UID : json['MSG_UID'],
          FILE_TYPE : json['FILE_TYPE']
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FILE_ORI_NM'] = this.FILE_ORI_NM;
    data['FILE_PATH'] = this.FILE_PATH;
    data['FILE_SIZE'] = this.FILE_SIZE;
    data['FILE_EXTN'] = this.FILE_EXTN;
    data['FILE_VALD_DATE'] = this.FILE_VALD_DATE;
    data['FILE_LARGE_CHECK'] = this.FILE_LARGE_CHECK;
    data['FILE_DEL_CHECK'] = this.FILE_DEL_CHECK;
    data['FILE_MODI_NM'] = this.FILE_MODI_NM;
    data['MSG_UID'] = this.MSG_UID;
    data['FILE_TYPE'] = this.FILE_TYPE;

    return data;
  }

  List<FileModel> listFromJson(list) =>
      List<FileModel>.from(list.map((x) => FileModel.fromJson(x)));
}