import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/widgets/avatar_contact.dart';
import 'package:AMES/common/widgets/user_circle.dart';
import 'package:AMES/controller/chat_screen_controller.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/contact_screen_controller.dart';
import 'package:AMES/common/widgets/text_field_search.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/widgets/chat_app_bar.dart';

class ContactView extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find();
    final ClientSocketController clientSocketController = Get.find();
    ChatScreenController chatController = Get.find();
    bool check = false;
    var _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    List emp;
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppTheme.white,
            body: Column(
              children: [
                Container(
                  color: AppTheme.white,
                  child: ChatAppBar(
                    numberNotification: 0,
                    title: UserCircle(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.12,
                      check: true,
                    ),
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
                Visibility(
                  visible: chatController.state.value,
                  child: TextFieldSearch(
                      textEditingController: contactController.searchController,
                      isPrefixIconVisible: true,
                      onChanged: contactController.contactNameSearch),
                ),
                Expanded(
                  child: Obx(
                    () => RefreshIndicator(
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
                        isLoading: contactController.reLoadContact.value,
                        skeleton: _skeletonView(),
                        child: GroupedListView<dynamic, String>(
                          elements: clientSocketController.messenger.contactList.value.where((element) => element.USER_UID != clientSocketController.messenger.currentUser.value.USER_UID).toList(),
                          groupBy: (element) =>
                              element.USER_NM_KOR[0].toString().toUpperCase(),
                          groupComparator: (value1, value2) =>
                              value2.compareTo(value1),
                          itemComparator: (item1, item2) => item1.USER_NM_KOR
                              .toString()
                              .compareTo(item2.USER_NM_KOR.toString()),
                          order: GroupedListOrder.DESC,
                          useStickyGroupSeparators: true,
                          groupSeparatorBuilder: (String value) => Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
                            child: Text(
                              value,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                          // showPreview: true,
                          itemBuilder: (context, element) =>
                              CustomAvatarContact(
                            employee: element,
                            press: () => {
                              // print("contact with ${element.USER_NM_ENG}"),
                              emp = [],
                              emp.add(element),
                              chatController.createChatroom(emp, "contact"),
                              // Get.toNamed(messagescreen, arguments: {"data": element}),
                            },
                          ),
                        ),
                      ),
                      onRefresh: contactController.pullRefresh,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (chatController.inProcess.value)
          //   Center(
          //     child: CircularProgressIndicator(),
          //     // CircularProgressIndicator
          //   ),
        ],
      ),
    );
  }

  Widget _skeletonView() => SkeletonListView(
        item: SkeletonListTile(
          verticalSpacing: 12,
          leadingStyle: SkeletonAvatarStyle(
              width: 50, height: 50, shape: BoxShape.circle),
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
}
