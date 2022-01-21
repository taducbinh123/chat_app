import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';

import 'package:hello_world_flutter/model/chat_card.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: kContentColorDarkTheme,
            child: TextAppBar(
              title: "Contacts",
            ),
          ),
          Expanded(
            child: GroupedListView<Chat, String>(
              elements: chatsData,
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
                press: () => print("contact with ${element.name}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
