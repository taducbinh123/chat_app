import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/model/models.dart';

class HomePage extends StatelessWidget {
  final User user;
  final _controller = Get.put(HomeController());
  final ClientSocketController clientSocketController = Get.find();

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _controller = Get.put(HomeController());
    // _controller.getUser();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userName = prefs.getString("username");
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.green.shade900,
        Colors.green.shade500,
        Colors.green.shade400,
      ])),
      child: Column(
        children: <Widget>[
          // Container(
          //
          //     // color: kContentColorDarkTheme,
          //     child: TextAppBar(
          //       title: "Home Page",
          //     )),
          SizedBox(
            height: 20,
          ),
          Text(
            'Home Page',
            style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Welcome, ${clientSocketController.messenger.currentUser?.USER_NM_KOR}',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      // #email, #password
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 20,
                                offset: Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                            children: [
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green[800]),
                            child: Center(
                              child: InkWell(
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap:(){
                                  _controller.signOut();
                                } ,
                              )
                            ),
                          ),
                        ]),
                      ),
                      // #login
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TextButton(
          //   child: Text('Logout'),
          //   onPressed: () {
          //     _controller.signOut();
          //   },
          // )
        ],
      ),
    )
        // SafeArea(
        // child:
        // Center(

        // ),
        // ),
        );
  }
}
