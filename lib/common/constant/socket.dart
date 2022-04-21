import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
  "transports": ["websocket"],
  "autoConnect": false,
  "auth": {"token": box.read('access_token')}
});
downloadFile(String fileUrl, String fileName) async {
  await FlutterDownloader.enqueue(
    url: fileUrl,
    fileName: fileName,
    savedDir: downloadsDirPath,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );
}
