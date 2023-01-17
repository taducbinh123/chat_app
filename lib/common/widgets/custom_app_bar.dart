import 'package:flutter/material.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:AMES/common/constant/ulti.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
    required this.leading,
    required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        // border: Border(
        //   bottom: BorderSide(
        //     color: lightBlueColor,
        //     width: 1.4,
        //     style: BorderStyle.solid,
        //   ),
        // ),
      ),
      child: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}