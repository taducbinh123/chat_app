import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/model/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  final _controller = Get.put(HomeController());

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  color: kContentColorDarkTheme,
                  child: TextAppBar(
                    title: "Home Page",
                  )),
              Text(
                'Welcome, ${user.name}',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              TextButton(
                child: Text('Logout'),
                onPressed: () {
                  _controller.signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
