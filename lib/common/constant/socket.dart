import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

final IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
  "transports": ["websocket"],
  "autoConnect": false,
  "auth": {"token": box.read('access_token')}
});

downloadFile(String fileUrl, String fileName) async {
  String? downloadsDirPath = await _findLocalPath();
  await FlutterDownloader.enqueue(
    url: fileUrl,
    fileName: fileName,
    savedDir: downloadsDirPath.toString(),
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );
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
