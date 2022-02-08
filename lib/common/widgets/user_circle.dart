import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';

class UserCircle extends StatelessWidget {
  UserCircle({Key? key, required this.height, required this.width})
      : super(key: key);
  var height;
  var width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: blackColor,
        builder: (context) => Container(),
      ),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "ABC",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: lightBlueColor,
                  fontSize: width*0.3,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: height*0.25,
                width: width*0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: blackColor, width: 2),
                  color: kDotColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
