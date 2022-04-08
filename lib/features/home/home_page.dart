import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/features/features.dart';

class HomePage extends StatelessWidget {

  HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final _controller = Get.put(HomeController());

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userName = prefs.getString("username");
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
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome, ' + _controller.username ,
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
