import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
//   "transports": ["websocket"],
//   "autoConnect": false,
//   "auth": {"token": box.read('access_token')}
// });

downloadFile(String fileUrl, String fileName) async {
  String? downloadsDirPath = await _findLocalPath();
  var status = await Permission.storage.request();
  if (status.isGranted) {
    await FlutterDownloader.enqueue(
      url: fileUrl,
      // fileName: fileName,
      savedDir: downloadsDirPath.toString(),
      showNotification: true,
      saveInPublicStorage: true,

      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }
}

Future<String?> _findLocalPath() async {
  var externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}
