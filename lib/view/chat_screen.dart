import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/widgets/avatar.dart';
import 'package:AMES/common/widgets/chat_app_bar.dart';
import 'package:AMES/common/widgets/text_field_search.dart';
import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:skeletons/skeletons.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    final contactController = Get.put(ContactScreenController());
    final chatController = Get.put(ChatScreenController());

    final ClientSocketController clientSocketController = Get.find();

    bool check = false;
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhiteBg,
      body: Obx(
        () => RefreshIndicator(
            onRefresh: chatController.pullRefresh,
            child: Column(children: [
              Container(
                color: AppTheme.dark_grey,
                child: Obx(
                  () => ChatAppBar(
                    numberNotification: clientSocketController
                        .messenger.totalRoomUnReadMessage.value,
                    title: Text(
                      "Conversations",
                      style: TextStyle(color: AppTheme.nearlyBlack),
                    ),

                    // UserCircle(
                    //   height: screenHeight * 0.06,
                    //   width: screenWidth * 0.12,
                    //   check: true,
                    // ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: AppTheme.nearlyBlack,
                        ),
                        onPressed: () {
                          check = !check;
                          chatController.onPress(check);
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.more_vert,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                    visible: chatController.state.value,
                    child: TextFieldSearch(
                        textEditingController: chatController.searchController,
                        isPrefixIconVisible: true,
                        onChanged: chatController.chatNameSearch)),
              ),
              Visibility(
                  visible: clientSocketController
                          .messenger.currentUser.value.USER_UID !=
                      "",
                  child: Expanded(
                      child: Skeleton(
                          shimmerGradient: LinearGradient(
                            colors: [
                              Color(0xffc4e1ef),
                              Color(0xffa3d3e8),
                              Color(0xffa3d3e8),
                              Color(0xffc4e1ef),
                            ],
                            stops: [
                              0.0,
                              0.3,
                              1,
                              1,
                            ],
                            begin: Alignment(-1, 0),
                            end: Alignment(1, 0),
                          ),
                          isLoading: chatController.reLoadListRoom.value,
                          skeleton: _skeletonView(),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: clientSocketController
                                  .messenger.listRoom.value.length,
                              itemBuilder: (context, index) => CustomAvatar(
                                chat: clientSocketController
                                    .messenger.listRoom.value[index],
                                press: () => {
                                  chatController.getMessageByRoomId(
                                      clientSocketController
                                          .messenger.listRoom.value[index],
                                      1),
                                },
                              ),
                            ),
                          )))),
              Visibility(
                visible: clientSocketController
                        .messenger.currentUser.value.USER_UID ==
                    "",
                child: Center(child: Text("Unable to load data")),
              )
            ])),
      ),
    );
    // floatingActionButton: CommonButton(
    //   icon: IconButton(
    //     icon: Icon(
    //       Icons.message,
    //       color: AppTheme.white,
    //       size: 25,
    //     ),
    //     onPressed: () {
    //       Get.to(() => AddContactScreen());
    //       contactController.listContactChoose.value = [];
    //       contactController.resetState();
    //     },
    //   ),
    // ),
  }

  Widget _skeletonView() => SkeletonListView(
        item: SkeletonListTile(
          verticalSpacing: 12,
          leadingStyle: SkeletonAvatarStyle(
              width: 60, height: 60, shape: BoxShape.circle),
          titleStyle: SkeletonLineStyle(
              height: 16,
              minLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          subtitleStyle: SkeletonLineStyle(
              height: 12,
              maxLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          hasSubtitle: true,
        ),
      );

  showAlertDialog(BuildContext context) {
// set up the buttons

    Widget launchButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        // Navigator.of(context).pop(context);
        Navigator.pop(context);
        // Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notification"),
      content: Text("Unable to load data"),
      actions: [
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
