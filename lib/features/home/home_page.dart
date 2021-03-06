import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/controller/client_socket_controller.dart';
import 'package:hello_world_flutter/controller/qr_controller.dart';
import 'package:hello_world_flutter/features/features.dart';
import 'package:hello_world_flutter/model/models.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  // qrController.animationController = AnimationController(
  // duration: const Duration(milliseconds: 2000), vsync: this);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _controller = Get.put(HomeController());
  final ClientSocketController clientSocketController = Get.find();
  final QRController qrController = Get.find();

  @override
  initState() {
    qrController.animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 20,
          ),
          // Text(
          //   'Home Page',
          //   style: TextStyle(
          //       color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 50,
          // ),
          Text(
            'Welcome, ${clientSocketController.messenger.currentUser?.USER_NM_KOR}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 50,
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
                                      size: MediaQuery.of(context).size.width /
                                          2),
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
                                              Clipboard.setData(
                                                      new ClipboardData(
                                                          text: qrController
                                                              .deviceId.value
                                                              .toString()))
                                                  .then((_) {
                                                print(qrController
                                                    .deviceId.value
                                                    .toString());
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
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
                                    "Code expired in " +
                                        time.toInt().toString(),
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
                                const SizedBox(
                                  height: 70,
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
                                    InkWell(
                                      onTap: () {
                                        _controller.signOut();
                                      },
                                      child: Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.green[800]),
                                          child: Center(
                                            child: Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          )),
                        );
                      },
                    ),
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
    ));
  }

  final snackBar = SnackBar(
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        // Code to execute.
      },
    ),
    content: const Text('Device ID copied to clipboard'),
    duration: const Duration(milliseconds: 1500),
    // width: 280.0, // Width of the SnackBar.
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  Widget appBar() {
    return SizedBox();
  }
}
