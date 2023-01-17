import 'package:AMES/common/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextAppBar extends StatelessWidget {
  TextAppBar({Key? key, required this.title}) : super(key: key);
  var title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.nearlyBlack,
      title: Text(
        title.toString(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }
}
