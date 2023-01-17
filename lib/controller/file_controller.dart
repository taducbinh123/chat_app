import 'dart:io';

import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:AMES/provider/file_provider.dart';
import 'package:image_picker/image_picker.dart';


class FileController extends GetxController {
  final FileProvider fileProvider = FileProvider();
  final ClientSocketController clientSocketController = Get.find();
  var listFiles = List<PlatformFile>.empty().obs;
  var listImages = List<XFile>.empty().obs;
  // final ClientSocketController clientSocketController = Get.find();

  uploadFile() {
    var data = {
      'ROOM_UID': clientSocketController.messenger.selectedRoom?.roomUid,
      'USER_UID': box.read("userUid")
    };
    for (int i = 0; i < listFiles.length; i++) {
      PlatformFile file = listFiles.elementAt(i);
      final File fileForFirebase = File(file.path!);

      fileProvider.uploadFile(fileForFirebase, data);
    }
  }

  uploadImage(){
    var data = {
      'ROOM_UID': clientSocketController.messenger.selectedRoom?.roomUid,
      'USER_UID': box.read("userUid")
    };
    for (int i = 0; i < listImages.length; i++) {
      XFile file = listImages.elementAt(i);
      final File fileForFirebase = File(file.path);

      fileProvider.uploadFile(fileForFirebase, data);
    }
  }
}
