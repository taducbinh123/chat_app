import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:hello_world_flutter/common/widgets/text_field_search.dart';


class ContactView extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    ContactScreenController contactController = Get.find();
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kContentColorDarkTheme,
            child: TextAppBar(
              title: "Contacts",
            ),
          ),
          TextFieldSearch(
              textEditingController: contactController.searchController,
              isPrefixIconVisible: true,
              onChanged: contactController.contactNameSearch),
          Expanded(
            child: Obx(
              () => GroupedListView<dynamic, String>(
                elements: contactController.contactList.value,
                groupBy: (element) => element.USER_NM_KOR[0].toString().toUpperCase(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1.USER_NM_KOR.toString().compareTo(item2.USER_NM_KOR.toString()),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 8.0, 8.0, 8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // showPreview: true,
                itemBuilder: (context, element) => CustomAvatarContact(
                  employee: element,
                  press: () => {
                    print("contact with ${element.USER_NM_ENG}"),
                    // Get.toNamed(messagescreen, arguments: {"data": element}),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CommonButton(
          icon: IconButton(
        icon: Icon(
          Icons.group_add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () {
          // Get.to(() => AddContactScreen());
          // contactController.listNameChoose.value = "";
          // contactController.listContactChoose.value = [];
          // contactController.resetState();
        },
      )),
    );
  }
}
