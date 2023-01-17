import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/controller/client_socket_controller.dart';
import 'package:AMES/controller/qr_controller.dart';
import 'package:AMES/features/features.dart';
import 'package:AMES/model/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PendingPage extends StatefulWidget {
  PendingPage({Key? key}) : super(key: key);

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var imgVariable;
  String imgPath = "";
  final qrController = Get.put(QRController());

  @override
  initState() {
    qrController.animationController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
    // print(box.read("userUid").toString());
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   refreshQRCode();
    // });
    super.initState();
  }

  @override
  void dispose() {
    // qrController.animationController!.dispose();
    super.dispose();
  }

  refreshQRCode() {
    qrController.getMessage();
    qrController.controller.text = qrController.deviceId.value;
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
                height: 50,
              ),
              ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: queryData.size.width - 60),
                  child: IntrinsicWidth(
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          color: AppTheme.nearlyBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              SizedBox(
                width: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 115,
              //   width: 115,
              //   child: Stack(
              //     fit: StackFit.expand,
              //     clipBehavior: Clip.none,
              //     children: [
              //       FutureBuilder(
              //           future: _controller.fetchUser(),
              //           builder:
              //               (BuildContext context, AsyncSnapshot<String> text) {
              //             return new CachedNetworkImage(
              //               imageUrl:
              //               'https://backend.atwom.com.vn/public/resource/imageView/' +
              //                   text.data.toString() +
              //                   '.jpg',
              //               imageBuilder: (context, imageProvider) =>
              //                   CircleAvatar(
              //                     backgroundImage: imageProvider,
              //                   ),
              //               placeholder: (context, url) =>
              //                   CircularProgressIndicator(),
              //               errorWidget: (context, url, error) => Image(
              //                   image: AssetImage(
              //                       "assets/images/user_avatar_c.png")),
              //             );
              //           }),
              //       Positioned(
              //           right: -6,
              //           bottom: 0,
              //           child: ClipOval(
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: AppTheme.white, // Button color
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.grey.withOpacity(0.8),
              //                     spreadRadius: 5,
              //                     blurRadius: 7,
              //                     offset: Offset(
              //                         0, 3), // changes position of shadow
              //                   ),
              //                 ],
              //               ),
              //               child: InkWell(
              //                 onTap: () {
              //                   _getFromCamera();
              //                 },
              //                 child: SizedBox(
              //                     width: 30,
              //                     height: 30,
              //                     child: Icon(
              //                       Icons.camera_alt,
              //                       size: 20,
              //                       color: AppTheme.nearlyBlack,
              //                     )),
              //               ),
              //             ),
              //           )
              //
              //         // SizedBox(
              //         //   height: 30,
              //         //   width: 30,
              //         //   child: IconButton(
              //         //          iconSize: 20,
              //         //          color: AppTheme.white,
              //         //         icon: Icon(Icons.camera_alt, color: Colors.black),
              //         //         onPressed: () {
              //         //           _getFromCamera();
              //         //         },
              //         //       ),
              //         // ),
              //       )
              //     ],
              //   ),
              // ),

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
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: qrController.animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              );
                              // qrController.animationController?.forward();
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
                                              onPressed: () {
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


  Widget appBar() {
    return SizedBox();
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
