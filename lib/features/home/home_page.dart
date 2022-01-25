import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/model/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  final _controller = Get.put(HomeController());

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
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
