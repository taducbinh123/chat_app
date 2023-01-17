import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/model/employee.dart';
import 'package:AMES/provider/contact_view_provider.dart';
import 'package:http/http.dart' as http;
import 'package:AMES/provider/room_chat_provider.dart';
import 'package:AMES/provider/socket_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constant/path.dart';
import '../provider/message_provider.dart';

class HistoryCallController extends GetxController {
  final RoomChatProvider roomChatProvider = RoomChatProvider();
  final ContactViewProvider contactViewProvider = ContactViewProvider();
  final SocketProvider socketProvider = SocketProvider();
  final ClientSocketController clientSocketController = Get.find();
  final MessageProvider messageProvider = MessageProvider();
  var employees = [].obs;

  @override
  void onInit() {
    // messageProvider.getUserCallHistory();
    super.onInit();
  }

  HistoryCallController() {

  }

  getUser(String roomUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('access_token');

    final response = await http.get(
        Uri.parse(chatApiHost + '/api/chat/getUser/' + roomUid),
        headers: {"Authorization": "Bearer " + access_token!});
    // print(response.body);
    List<dynamic> decodeData = new List.empty();

    try {
      decodeData = convert.jsonDecode(response.body);
    } catch (e) {}
    print(decodeData);
    return decodeData.map((e) => Employee.fromJson(e));
  }
}
