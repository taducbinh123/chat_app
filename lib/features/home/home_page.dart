import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/controller/call_controller.dart';
import 'package:AMES/controller/nav_bar_controller.dart';
import 'package:AMES/features/pending_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/qr_controller.dart';
import 'package:AMES/features/features.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../common/constant/path.dart';
import '../../provider/user_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var imgVariable;
  String imgPath = "";
  var _uuid;
  var _currentUuid;

  final HomeController _controller = Get.put(HomeController());
  late ClientSocketController clientSocketController = Get.find();

  final QRController qrController = Get.find();
  final AuthenticationController authenticationController = Get.find();
  final CallController callController = Get.find();
  final NavBarController navBarController = Get.find();
  final AuthenticationController _authenticationController = Get.find();
  final UserProvider userProvider = UserProvider();
  final service = FlutterBackgroundService();
  @override
  initState() {
    qrController.animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // print(box.read("userUid").toString());

    Timer.periodic(Duration(seconds: 10), (timer) {
      refreshQRCode();
    });
    super.initState();
    _uuid = Uuid();
    WidgetsBinding.instance?.addObserver(this);
    checkAndNavigationCallingPage();
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isCalled = preferences.getBool("isCall");
    // print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    // print(isCalled);
    if (calls is List) {
      print('DATA :${calls}');
      if (calls.isNotEmpty && isCalled!) {
        // print(calls[0]['extra']);
        var data = {
          "ROOM_ID": calls[0]['handle'],
          "ROOM_TYPE": calls[0]['extra']['ROOM_TYPE'],
          "USER_UID": preferences.getString("userUid"),
          "ROOM_UID": calls[0]['extra']['ROOM_UID'],
          "CALL_USER_UID": calls[0]['extra']['USER_UID'],
          "TYPE_CALL": "AUDIO"
        };
        if (calls[0]['extra']['TYPE_CALL'] != null) {
          // roomSocket.emit("sendJoinCall", data);
          // data['CALL_USER_UID'] = data['USER_UID'];
          // Get.back();
          callController.roomId.value = calls[0]['handle'];
          callController.isCallAudio.value = true;
          callController.isPickedUp();
          print("***********AUDIO***************");
          print(data);
          roomSocket.emit("sendJoinCall", data);
          // Get.toNamed(dashboard);
          clientSocketController.joinMeeting(data, false, true);
        } else {
          data = {
            "ROOM_ID": calls[0]['handle'],
            "ROOM_TYPE": calls[0]['extra']['ROOM_TYPE'],
            "USER_UID": preferences.getString("userUid"),
            "ROOM_UID": calls[0]['extra']['ROOM_UID'],
            "CALL_USER_UID": calls[0]['extra']['USER_UID'],
            "TYPE_CALL": ""
          };
          roomSocket.emit("sendJoinCall", data);
          // data['CALL_USER_UID'] = data['USER_UID'];
          print("***********NOT AUDIO***************");
          print(data);
          callController.isPickedUp();
          // Get.toNamed(dashboard);
          clientSocketController.joinMeeting(data, false, false);
        }
        // callController.roomChat =
        //     clientSocketController.messenger.listRoom.value.firstWhere(
        //         (element) => element.roomUid == calls[0]['extra']['ROOM_UID']);
        // clientSocketController.messenger.callRoom.value.ROOM_ID =
        //     calls[0]['handle'];
        // clientSocketController.messenger.callRoom.value.ROOM_UID =
        //     calls[0]['extra']['ROOM_UID'];
        // clientSocketController.messenger.callRoom.value.CALL_USER_UID =
        //     data['CALL_USER_UID'];
        // clientSocketController.messenger.callRoom.value.ROOM_TYPE =
        //     calls[0]['extra']['ROOM_TYPE'];
        // clientSocketController.messenger.callRoom.value.TYPE_CALL =
        //     calls[0]['extra']['TYPE_CALL'] != null ? "AUDIO" : "CALL";
        // print('DATA: $calls');
        // this._currentUuid = calls[0]['extra']['TYPE_CALL'];
        // return calls[0];
      } else {
        // this._currentUuid = "";
        // return null;
      }
    }
  }

  checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {}
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.paused) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("isCall", false);
    }
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    qrController.animationController!.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  refreshQRCode() {
    qrController.getMessage();
    qrController.controller.text = qrController.deviceId.value;
    // service.invoke("getLog", {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: AppTheme.nearlyWhiteBg,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              //   Colors.green.shade900,
              //   Colors.green.shade500,
              //   Colors.green.shade400,
              // ])
              color: AppTheme.background2),
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
              Row(
                children: [
                  Spacer(),
                  Obx(() => ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: queryData.size.width - 60),
                      child: IntrinsicWidth(
                        child: Text(
                          'Welcome, ${clientSocketController.messenger.currentUser.value.USER_NM_KOR}',
                          style: TextStyle(
                              color: AppTheme.nearlyBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))),
                  Spacer(),
                  IconButton(
                      color: AppTheme.nearlyBlack,
                      onPressed: () {
                        _controller.signOut();
                        _controller.isStop = false;
                        final service = FlutterBackgroundService();
                        service.invoke("stopService");
                      },
                      icon: Icon(Icons.logout)),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    FutureBuilder(
                        future: _controller.fetchUser(),
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {
                          return new CachedNetworkImage(
                            imageUrl:
                                'https://backend.atwom.com.vn/public/resource/imageView/' +
                                    text.data.toString() +
                                    '.jpg',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image(
                                image: AssetImage(
                                    "assets/images/user_avatar_c.png")),
                          );
                        }),
                    Positioned(
                        right: -6,
                        bottom: 0,
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.white, // Button color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                _getFromCamera();
                              },
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: AppTheme.nearlyBlack,
                                  )),
                            ),
                          ),
                        )

                        // SizedBox(
                        //   height: 30,
                        //   width: 30,
                        //   child: IconButton(
                        //          iconSize: 20,
                        //          color: AppTheme.white,
                        //         icon: Icon(Icons.camera_alt, color: Colors.black),
                        //         onPressed: () {
                        //           _getFromCamera();
                        //         },
                        //       ),
                        // ),
                        )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Expanded(
                child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.background2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        // color: AppTheme.white,
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List<Widget>.generate(
                            1,
                            (int index) {
                              final int count = 1;
                              // final Animation<double> animation =
                              //     Tween<double>(begin: 0.0, end: 1.0).animate(
                              //   CurvedAnimation(
                              //     parent: qrController.animationController!,
                              //     curve: Interval((1 / count) * index, 1.0,
                              //         curve: Curves.fastOutSlowIn),
                              //   ),
                              // );
                              qrController.animationController?.forward();
                              return Container(
                                child: Center(
                                    child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => QrImage(
                                            data: qrController.msg.value,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 30, 0),
                                              child: SizedBox(
                                                width:
                                                    queryData.size.width * 0.55,
                                                child: TextField(
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    height: 1.0,
                                                  ),
                                                  focusNode: FocusNode(),
                                                  enableInteractiveSelection:
                                                      false,
                                                  readOnly: true,
                                                  controller:
                                                      qrController.controller,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: AppTheme
                                                              .dark_grey
                                                              .withOpacity(0.3),
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            Clipboard.setData(new ClipboardData(
                                                                    text: qrController
                                                                        .deviceId
                                                                        .value
                                                                        .toString()))
                                                                .then((_) {
                                                              print(qrController
                                                                  .deviceId
                                                                  .value
                                                                  .toString());
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackBar(
                                                                          'Device ID copied to clipboard'));
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.copy,
                                                            color: AppTheme
                                                                .dark_grey
                                                                .withOpacity(
                                                                    0.6),
                                                          )),
                                                      // border: OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          color: AppTheme
                                                              .dark_grey
                                                              .withOpacity(
                                                                  0.8)),
                                                      labelText: 'Device ID'),
                                                ),
                                              )),
                                          // Spacer(),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary:
                                                      AppTheme.nearlyBlack),
                                              onPressed: () async {
                                                refreshQRCode();
                                              },
                                              child: Icon(Icons.refresh)),
                                        ],
                                      )

                                      // Countdown(
                                      //   seconds: 10,
                                      //   build: (_, double time) => Text(
                                      //     "Code expired in " +
                                      //         time.toInt().toString(),
                                      //   ),
                                      //   interval: Duration(milliseconds: 1000),
                                      //   controller: qrController.controllerCountdown,
                                      //   onFinished: () {
                                      //     qrController.controller.text =
                                      //         qrController.deviceId.value;
                                      //     qrController.getMessage();
                                      //     qrController.controllerCountdown.restart();
                                      //   },
                                      // ),

                                      // #email, #password
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white,
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     boxShadow: const [
                                      //       BoxShadow(
                                      //           color: Colors.white,
                                      //           blurRadius: 20,
                                      //           offset: Offset(0, 10)),
                                      //     ],
                                      //   ),
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       _controller.signOut();
                                      //     },
                                      //     child: Container(
                                      //         height: 50,
                                      //         margin: const EdgeInsets.symmetric(
                                      //             horizontal: 50),
                                      //         decoration: BoxDecoration(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(50),
                                      //             color: AppTheme.nearlyBlack),
                                      //         child: Center(
                                      //           child: Text(
                                      //             "Logout",
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontWeight: FontWeight.bold),
                                      //           ),
                                      //         )),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )),
                              );
                            },
                          ),
                        ),
                      ),
                    )),
                // ),
                // TextButton(
                //   child: Text('Logout'),
                //   onPressed: () {
                //     _controller.signOut();
                //   },
              )
            ],
          ),
        ));
  }

  // final snackBar = SnackBar(
  //   action: SnackBarAction(
  //     label: 'OK',
  //     onPressed: () {
  //       // Code to execute.
  //     },
  //   ),
  //   content: const Text('Device ID copied to clipboard'),
  //   duration: const Duration(milliseconds: 1500),
  //   // width: 280.0, // Width of the SnackBar.
  //   padding: const EdgeInsets.symmetric(
  //     horizontal: 8.0, // Inner padding for SnackBar content.
  //   ),
  //   behavior: SnackBarBehavior.floating,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(10.0),
  //   ),
  // );

  Widget appBar() {
    return SizedBox();
  }

  Future<Null> _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() async {
        imgVariable = File(pickedFile.path);
        var result = await _controller.uploadFile(imgVariable);
        if (result == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar('Upload avatar success'));
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar('Upload avatar fail'));
        }
      });
    }
  }

  SnackBar snackBar(String content) {
    return SnackBar(
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Code to execute.
        },
      ),
      content: Text(content),
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
  }
}
