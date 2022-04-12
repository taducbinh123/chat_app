import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

  final IO.Socket roomSocket = IO.io(chatApiHost + "/chat", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    "auth": {"token": box.read('access_token')}
  });
