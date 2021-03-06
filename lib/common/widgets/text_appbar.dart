import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextAppBar extends StatelessWidget {
  TextAppBar({Key? key, required this.title}) : super(key: key);
  var title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title.toString(),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}
