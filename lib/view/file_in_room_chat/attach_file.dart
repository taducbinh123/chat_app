import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/view/message/preview_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:AMES/model/file_multimedia.dart';
import 'package:get/get.dart';
import 'package:holding_gesture/holding_gesture.dart';

import '../../common/app_theme.dart';
import '../../common/constant/socket.dart';
import '../../controller/nav_bar_controller.dart';

class AttachFileMultimedia extends StatelessWidget {
  AttachFileMultimedia({Key? key, required this.fileMultimedia})
      : super(key: key);

  FileModel fileMultimedia;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    return HoldTimeoutDetector(
        holdTimeout: Duration(milliseconds: 500),
        onTimerInitiated: () {},
        onTimeout: () {
          showAlertDialog(context, fileMultimedia);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              if (fileMultimedia.FILE_TYPE.contains("image")) {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Scaffold(
                      appBar: AppBar(
                        backgroundColor: AppTheme.white,
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: AppTheme.nearlyBlack),
                            onPressed: () => {
                              Get.back(),
                            }),
                      ),
                      body: PreviewImage(
                        imageUrl: chatApiHost +
                            "/api/chat/getFile/" +
                            fileMultimedia.FILE_PATH.toString(),
                        tag: fileMultimedia.MSG_UID.toString(),
                      ));
                }));
              }
            },
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: chatApiHost +
                  "/api/chat/getFile/" +
                  fileMultimedia.FILE_PATH.toString(),
              placeholder: (context, url) => Center(
                child: Container(

                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
              new Icon(Icons.error),
            ),
          ),
        ));
  }

  showAlertDialog(BuildContext context, FileModel fileMultimedia) {
// set up the buttons
    final NavBarController navBarController = Get.find();

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget launchButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        downloadFile(
            chatApiHost +
                "/api/chat/getFile/" +
                fileMultimedia.FILE_PATH.toString(),
            fileMultimedia.FILE_ORI_NM.toString());
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Download"),
      content: Text("Would you like download image?"),
      actions: [
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
