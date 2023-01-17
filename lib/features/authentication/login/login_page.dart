import 'package:AMES/features/authentication/login/login_controller.dart';
import 'package:AMES/features/authentication/login/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:AMES/common/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<LoginPage> {
  final _controller = Get.put(LoginController());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _autoValidate = false;

  void click() {}
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // key: _key,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //   Colors.purpleAccent,
              //   Colors.amber,
              //   Colors.blue,
              // ])
              color: AppTheme.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // const SizedBox(
              //   height: 100,
              // ),
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    // height: 150,
                    width: width * 0.8,
                    // child: Image.asset('assets/images/logo_a.png'),
                    child: Image.asset('assets/images/ames_logo.png'),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _key,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const Text(
                        //   "Hello",
                        //   style: TextStyle(
                        //       fontSize: 28, fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // const Text(
                        //   "Please Login to Your Account",
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 15,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: 260,
                          height: 60,
                          child: TextFormField(
                            style: TextStyle(color: AppTheme.nearlyBlack),
                            decoration: InputDecoration(
                                fillColor: AppTheme.dark_grey.withOpacity(0.1),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.dark_grey.withOpacity(0.8),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.dark_grey.withOpacity(0.3),
                                    width: 2.0,
                                  ),
                                ),
                                suffix: Icon(
                                  FontAwesomeIcons.user,
                                  // color: Colors.red,
                                  color: AppTheme.dark_grey.withOpacity(0.8),
                                ),
                                labelText: "Username",
                                labelStyle: TextStyle(
                                    color: AppTheme.dark_grey.withOpacity(0.8)),
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
                        Obx(
                          () => Visibility(
                            child: Center(
                              child: CircularProgressIndicator(),
                              // CircularProgressIndicator
                            ),
                            visible: _controller.state is LoginLoading,
                          ),
                        ),
                        Container(
                          width: 260,
                          height: 60,
                          child: TextFormField(
                            obscureText: true,
                            style: TextStyle(color: AppTheme.nearlyBlack),
                            decoration: InputDecoration(
                                fillColor: AppTheme.dark_grey.withOpacity(0.1),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.dark_grey.withOpacity(0.8),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.dark_grey.withOpacity(0.3),
                                    width: 2.0,
                                  ),
                                ),
                                suffix: Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: AppTheme.dark_grey.withOpacity(0.8),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    color: AppTheme.dark_grey.withOpacity(0.8)),
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
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       TextButton(
                        //         onPressed: click,
                        //         child: const Text(
                        //           "Forget Password",
                        //           style: TextStyle(color: Colors.deepOrange),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        Container(
                          width: 260,
                          child: Obx(
                            () => CheckboxListTile(
                                // secondary: Icon(Icons.ale),
                                title: Text("Remember me"),
                                value: _controller.rememberValue.value,
                                onChanged: (value) {
                                  print(value);
                                  _controller.rememberValue.value = value!;
                                }),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: _controller.state is LoginLoading
                                  ? () {}
                                  : _onLoginButtonPressed,
                              child: Container(
                                alignment: Alignment.center,
                                width: 250,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)),

                                    // gradient: LinearGradient(
                                    //     begin: Alignment.centerLeft,
                                    //     end: Alignment.centerRight,
                                    //     colors: [
                                    //       Color(0xFF8A2387),
                                    //       Color(0xFFE94057),
                                    //       Color(0xFFF27121),
                                    //     ])
                                    color: AppTheme.nearlyBlack),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    child: Text(
                                      'LOG IN',
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // onPressed: _controller.state is LoginLoading
                                    //     ? () {}
                                    //     : _onLoginButtonPressed,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final isAvailable =
                                await _controller.hasBiometrics();
                                final isAuthenticated =
                                await _controller.authenticate();
                                if (isAuthenticated) {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  print(prefs.getString("username"));
                                  print(prefs.getString("password"));
                                  _controller.login(
                                      prefs.getString("username").toString(),
                                      prefs.getString("password").toString(),
                                      false);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(50),
                                        topRight: Radius.circular(50)),
                                    // gradient: LinearGradient(
                                    //     begin: Alignment.centerLeft,
                                    //     end: Alignment.centerRight,
                                    //     colors: [
                                    //       Color(0xFF8A2387),
                                    //       Color(0xFFE94057),
                                    //       Color(0xFFF27121),
                                    //     ])
                                    color: AppTheme.nearlyWhite),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                      child: Icon(
                                        Icons.face,
                                        color: Colors.white,
                                      )
                                    // onPressed: _controller.state is LoginLoading
                                    //     ? () {}
                                    //     : _onLoginButtonPressed,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),
                        Obx(
                          () => Visibility(
                            child: Text(
                              _controller.state is LoginFailure
                                  ? (_controller.state as LoginFailure).error
                                  : "",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Get.theme.errorColor),
                            ),
                            visible: _controller.state is LoginFailure,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _onLoginButtonPressed() {
    //print(_usernameController.text + " " + _passwordController.text);

    if (_key.currentState!.validate()) {
      _controller.login(_usernameController.text, _passwordController.text,true);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
