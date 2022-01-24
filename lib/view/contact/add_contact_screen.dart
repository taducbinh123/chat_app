import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/floating_action_button.dart';
import 'package:hello_world_flutter/controller/contact_screen_controller.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AddContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactScreenController contactController =
        Get.put(ContactScreenController());
    return Scaffold(
      appBar: searchAppBar(context),
      body: Column(
        children: [],
      ),
    );
  }

  searchAppBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          gradientColorStart,
          gradientColorEnd,
        ],
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {
                Get.back(),
              }),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            cursorColor: blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
