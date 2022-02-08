import 'package:flutter/material.dart';
import 'package:hello_world_flutter/common/constant/ulti.dart';

class SelectCircle extends StatelessWidget {
  SelectCircle(
      {Key? key, required this.height, required this.width, required this.text})
      : super(key: key);
  var height;
  var width;
  var text;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: lightBlueColor,
                fontSize: width * 0.3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Container(
                height: height * 0.25,
                width: width * 0.5,
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: width * 0.25,
                ),
              ),
              onTap: (){
                print("tapped");
              },
            ),
          )
        ],
      ),
    );
  }
}
