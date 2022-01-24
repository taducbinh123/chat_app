import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';



class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor:blackColor,
        builder: (context) => Container(),
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color:separatorColor,
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
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: blackColor, width: 2),
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
