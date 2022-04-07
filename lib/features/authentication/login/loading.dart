import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 50, 120, 241),
      child: Center(
          child: SpinKitChasingDots(
            color: Color.fromARGB(255, 22, 56, 116),
            size: 50.0,
          )),
    );
  }
}