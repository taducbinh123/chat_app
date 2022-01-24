import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';

import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:hello_world_flutter/view/contact/add_contact_screen.dart';
import 'package:hello_world_flutter/view/pm_screen.dart';
import 'package:hello_world_flutter/view/search/text_field_search.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ContactView extends GetView<ContactScreenController> {
  @override
  Widget build(BuildContext context) {
    final contactController = Get.put(ContactScreenController());
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
              () => GroupedListView<Chat, String>(
                elements: contactController.contactList.value ,
                groupBy: (element) => element.name[0].toString().toUpperCase(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1.name.toString().compareTo(item2.name.toString()),
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
                  chat: element,
                  press: () => {
                    print("contact with ${element.name}"),
                    // Get.to(() => MessagesScreen()),
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
          Get.to(() => AddContactScreen());
        },
      )),
    );
  }
}
