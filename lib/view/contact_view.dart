import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/avatar_contact.dart';
import 'package:hello_world_flutter/common/widgets/bottom_nav_bar.dart';

import 'package:hello_world_flutter/model/chat_card.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';

class ContactView extends StatelessWidget {

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
            child: Container(),
          ),
          Expanded(
            child:AlphabetListScrollView(
              strList: chatsData.map((e) => e.name).toList(),
              highlightTextStyle: TextStyle(
                color: Colors.yellow,
              ),
              showPreview: true,
              itemBuilder: (context, index) => CustomAvatarContact(
                chat: chatsData[index],
                press: () => {
                  Get.toNamed(contactView),

                },
              ),
              indexedHeight: (i) {
                return 80;
              },
              keyboardUsage: true,
              headerWidgetList: <AlphabetScrollListHeader>[
                AlphabetScrollListHeader(widgetList: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      // controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffix: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        labelText: "Search",
                      ),
                    ),
                  )
                ], icon: Icon(Icons.search), indexedHeaderHeight: (index) => 80),
                // AlphabetScrollListHeader(
                //     widgetList: chatsData,
                //     icon: Icon(Icons.star),
                //     indexedHeaderHeight: (index) {
                //       return 80;
                //     }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SuperFaBottomNavigationBar(),
    );
  }
}
