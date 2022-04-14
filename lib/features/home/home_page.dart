import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/common/app_theme.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';
import 'package:hello_world_flutter/common/widgets/text_appbar.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/controller/qr_controller.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/model/models.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatelessWidget {
  final User user;
  final _controller = Get.put(HomeController());
  final ClientSocketController clientSocketController = Get.find();
  final qrController = Get.put(QRController());


  HomePage({Key? key, required this.user}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // final _controller = Get.put(HomeController());
    // _controller.getUser();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userName = prefs.getString("username");

    // qrController.animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);

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
          appBar(),
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
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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

          Column(
            children: List<Widget>.generate(
              1,
              (int index) {
                final int count = 1;
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: qrController.animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                );
                qrController.animationController?.forward();
                return Container(
                  child: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => QrImage(
                              data: qrController.msg.value,
                              size: MediaQuery.of(context).size.width / 2),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: TextField(
                            focusNode: FocusNode(),
                            enableInteractiveSelection: false,
                            readOnly: true,
                            controller: qrController.controller,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      Clipboard.setData(new ClipboardData(
                                              text: qrController.deviceId.value
                                                  .toString()))
                                          .then((_) {
                                        print(qrController.deviceId.value
                                            .toString());
                                        _scaffoldKey.currentState
                                            ?.showSnackBar(snackBar);
                                      });
                                    },
                                    icon: Icon(Icons.copy)),
                                border: OutlineInputBorder(),
                                labelText: 'Device ID'),
                          ),
                        ),
                        Countdown(
                          seconds: 10,
                          build: (_, double time) => Text(
                            "Code expired in " + time.toInt().toString(),
                          ),
                          interval: Duration(milliseconds: 1000),
                          controller: qrController.controllerCountdown,
                          onFinished: () {
                            qrController.controller.text =
                                qrController.deviceId.value;
                            qrController.getMessage();
                            qrController.controllerCountdown.restart();
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              qrController.getMessage();
                              qrController.controller.text =
                                  qrController.deviceId.value;
                            },
                            child: Icon(Icons.refresh)),
                      ],
                    ),
                  )),
                );
              },
            ),
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
                        child: Column(children: [
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
                              onTap: () {
                                _controller.signOut();
                              },
                            )),
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

  final snackBar = SnackBar(
    elevation: 6.0,
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    content: Text(
      "Device ID copied to clipboard",
      style: TextStyle(color: Colors.black),
    ),
  );

  Widget appBar() {
    return SizedBox(
        // height: AppBar().preferredSize.height,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.only(top: 8, left: 8),
        //       child: Container(
        //         width: AppBar().preferredSize.height - 8,
        //         height: AppBar().preferredSize.height - 8,
        //       ),
        //     ),
        //     Expanded(
        //       child: Center(
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 4),
        //           child: Text(
        //             'Im In',
        //             style: TextStyle(
        //               fontSize: 22,
        //               color: AppTheme.darkText,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 8, right: 8),
        //       child: Container(
        //         width: AppBar().preferredSize.height - 8,
        //         height: AppBar().preferredSize.height - 8,
        //         color: Colors.white,
        //         child: Material(
        //           color: Colors.transparent,
        //           child: InkWell(
        //             borderRadius:
        //             BorderRadius.circular(AppBar().preferredSize.height),
        //             child: Icon(
        //               Icons.view_agenda,
        //               color: AppTheme.dark_grey,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
