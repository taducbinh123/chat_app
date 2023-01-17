import 'package:flutter/material.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';

class CommonButton extends StatelessWidget {
  CommonButton({Key? key, required this.icon}) : super(key: key);
  IconButton icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // gradient: fabGradient,
          color: AppTheme.nearlyBlack,
          borderRadius: BorderRadius.circular(50)
      ),
      child: icon,
      padding: EdgeInsets.all(10),
    );
  }
}
