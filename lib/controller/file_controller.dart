import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/provider/file_provider.dart';

import '../common/constant/ulti.dart';

class FileController extends GetxController {
  final FileProvider fileProvider = FileProvider();
  var listFiles = List<PlatformFile>.empty().obs;

  uploadFile() {
    var data = {
      'ROOM_UID': Get.arguments['room'].roomUid,
      'USER_UID': box.read("userUid")
    };
    for(int i=0;i<listFiles.length;i++){
      var file={
        'name':listFiles[i].name,
        'type':""
      };
      fileProvider.uploadFile(file, data);
    }

  }
}
