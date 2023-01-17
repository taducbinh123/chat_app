import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:AMES/features/authentication/authentication_service.dart';

class SocketProvider extends GetxController {
  var chatsDatas = [].obs;
  final box = GetStorage();

  //update date last read message (NOT get last message)
  updateLastReadMessage(var roomUid, var lastReadMsgId) async {
    roomSocket.connect();
    roomSocket.emit("updateLastReadMsg",
        {"roomUid": roomUid, "lastReadMsgId": lastReadMsgId});
    roomSocket.on("updateLastReadMsg", (data) => print("done"));
  }


}
