import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';

class CommonButton extends StatelessWidget {
  CommonButton({Key? key, required this.icon}) : super(key: key);
  IconButton icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: fabGradient, borderRadius: BorderRadius.circular(50)),
      child: icon,
      padding: EdgeInsets.all(10),
    );
  }
}
