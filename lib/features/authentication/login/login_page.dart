import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hello_world_flutter/features/authentication/login/loading.dart';
import 'package:lottie/lottie.dart';

import 'login_controller.dart';
import 'login_state.dart';

class LoginPage extends StatelessWidget {
  // LoginPage(){
  //   Get.reset();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      title: "Login Page",
      home: _SignInForm(),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final _controller = Get.put(LoginController());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _autoValidate = false;

  void click() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 200,
                width: 300,
                child: LottieBuilder.asset("assets/lottie/login2.json"),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  width: 325,
                  height: 470,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Form(
                    key: _key,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Hello",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Please Login to Your Account",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 260,
                          height: 60,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.red,
                                ),
                                labelText: "Username",
                                filled: true,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null) {
                                return 'Username is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: 260,
                          height: 60,
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Colors.red,
                                ),
                                labelText: "Password",
                                filled: true,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null) {
                                return 'Password is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: click,
                                child: const Text(
                                  "Forget Password",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (_controller.state is LoginFailure)
                          Text(
                            (_controller.state as LoginFailure).error,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Get.theme.errorColor),
                          ),
                        if (_controller.state is LoginLoading)
                          Center(
                            child: Loading(),
                          ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF8A2387),
                                      Color(0xFFE94057),
                                      Color(0xFFF27121),
                                    ])),
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextButton(
                                child: Text(
                                  'LOG IN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: _controller.state is LoginLoading
                                    ? () {}
                                    : _onLoginButtonPressed,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        const Text(
                          "Or Login using Social Media Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: click,
                                icon: const Icon(FontAwesomeIcons.facebook,
                                    color: Colors.blue)),
                            IconButton(
                                onPressed: click,
                                icon: const Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.redAccent,
                                )),
                            IconButton(
                                onPressed: click,
                                icon: const Icon(
                                  FontAwesomeIcons.twitter,
                                  color: Colors.orangeAccent,
                                )),
                            IconButton(
                                onPressed: click,
                                icon: const Icon(
                                  FontAwesomeIcons.linkedinIn,
                                  color: Colors.green,
                                ))
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  //   return Obx(() {
  //     return Form(
  //       key: _key,
  //       autovalidateMode:
  //           _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Username',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               controller: _usernameController,
  //               keyboardType: TextInputType.text,
  //               autocorrect: false,
  //               validator: (value) {
  //                 if (value == null) {
  //                   return 'Username is required.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(
  //               height: 12,
  //             ),
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Password',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               obscureText: true,
  //               controller: _passwordController,
  //               validator: (value) {
  //                 if (value == null) {
  //                   return 'Password is required.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(
  //               height: 16,
  //             ),
  //             ElevatedButton(
  //               child: Text('LOG IN'),
  //               onPressed: _controller.state is LoginLoading
  //                   ? () {}
  //                   : _onLoginButtonPressed,
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             if (_controller.state is LoginFailure)
  //               Text(
  //                 (_controller.state as LoginFailure).error,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(color: Get.theme.errorColor),
  //               ),
  //             if (_controller.state is LoginLoading)
  //               Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
  //
  _onLoginButtonPressed() {
    print(_usernameController.text + " " + _passwordController.text);

    if (_key.currentState!.validate()) {
      _controller.login(_usernameController.text, _passwordController.text);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
