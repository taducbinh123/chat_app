import 'package:AMES/common/constant/path.dart';
import 'package:AMES/common/constant/socket.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/model/file_multimedia.dart';


class File extends StatelessWidget {
  File({Key? key, required this.file}) : super(key: key);

  FileModel file;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return InkWell(
      child:
      // Container(
          // constraints: BoxConstraints(
          //     minWidth: queryData.size.width * 0.1,
          //     maxWidth: queryData.size.width * 0.5),
          // padding: EdgeInsets.symmetric(
          //   horizontal: kDefaultPadding * 0.75,
          //   vertical: kDefaultPadding / 3,
          // ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(16),
          //     bottomRight: Radius.circular(16),
          //   ),
          // ),
          // child:
          // Wrap(
          //   children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 10),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        // color: Colors.grey,
                        // height: 90,
                        constraints: BoxConstraints(
                            minWidth: queryData.size.width ,
                            maxWidth: queryData.size.width ,
                        maxHeight:  queryData.size.height * 0.08,
                        minHeight:  queryData.size.height * 0.08),
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: kDefaultPadding * 0.75,
                        //   vertical: queryData.size.height * 0.1,
                        // ),
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyBlack,
                          borderRadius: BorderRadius.all(Radius.circular(16),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Spacer(),
                          Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                          ),
                          Expanded(
                            flex: 4,
                            child: AutoSizeText(
                              file.FILE_ORI_NM.toString(),
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.0,
                                  color: Colors.white),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.file_download,
                                color: AppTheme.white,
                              ),
                              onPressed: () => {
                                downloadFile(
                                    chatApiHost +
                                        "/api/chat/getFile/" +
                                        file.FILE_PATH.toString(),
                                    file.FILE_ORI_NM.toString())
                              })
                        ],
                      ),
                    ],
                  ),
            ],
          ));
    // );
  }
}
