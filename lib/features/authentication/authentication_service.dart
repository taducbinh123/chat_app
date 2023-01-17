import 'dart:io';

import 'package:AMES/common/constant/ulti.dart';
import 'package:get_storage/get_storage.dart';
import 'package:AMES/common/constant/path.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:AMES/model/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


late IO.Socket roomSocket;

abstract class AuthenticationService extends GetxService {
  Future<User?> getCurrentUser();
  Future<User> signInWithUsernameAndPassword(String email, String password, bool convertPassword);
  Future<void> signOut();
  Future<bool> autoLogin(String username, String fcm_token);
}

class AuthenticationServiceImpl extends AuthenticationService {
  // final prefs = SharedPreferences.getInstance();
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  @override
  Future<User?> getCurrentUser() async {
    // simulated delay
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  @override
  Future<User> signInWithUsernameAndPassword(
      String username, String password, bool convertPassword) async {
    await Future.delayed(Duration(seconds: 1));
    if(convertPassword){
      password = md5.convert(utf8.encode(password)).toString();
    }

    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    map['grant_type'] = 'password';

    final response = await http.post(Uri.parse(authApiUrl + '/oauth/token'),
        headers: {
          'Authorization': 'Basic YTJtOmJldGh1bmFtMjAyMA==',
          'Content-type': 'application/x-www-form-urlencoded',
        },
        body: map);

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      print("đăng nhập thành công");
      var info = jsonDecode(utf8convert(response.body));

      var t = DateTime.now().add(Duration(seconds: info['expires_in'] * 1000));

      print(info);


      await saveInforUser(info['access_token'], info['expires_in'],password);
    } else{
      throw AuthenticationException(message: 'Wrong username or password');
    }

    return User(name: username, email: "");
  }

  @override
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    await saveLogoutInfo();
    // print(accessToken);
    roomSocket.emit("changeUserState",
        {"userUid": prefs.getString("userUid"), "IS_ONLINE": "false"});

    // await prefs.clear();

    await prefs.remove("access_token");
    await prefs.remove("rememberValue");
    // accessToken = prefs.getString('access_token');
    // prefs.remove("accessToken");
    // print(accessToken);
    await box.erase();
    // await Future.delayed(Duration(seconds: 3));
    roomSocket.disconnect();
  }

  saveInforUser(
      String token, var expires_in, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove("access_token");
    await prefs.setString("access_token", token);
    if(password != null && password !=''){
      await prefs.remove("password");
      await prefs.setString("password", password);
    }
    // print(prefs.getString("userUid").toString());

    final response = await http.post(
        Uri.parse(imwareApiHost + '/api/userInfo/saveLoginInfo'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-type': 'application/json',
        });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
      // throw Exception('Error');
    }
    DateTime now = DateTime.now();
    // print(now);
    now = now.add(new Duration(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        milliseconds: expires_in * 1000));
    // print(now);

    await prefs.setString("expires_in", now.toString());
    final box = GetStorage();
    box.write("access_token", token);
  }

  saveLogoutInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.put(
          Uri.parse(imwareApiHost + '/api/userInfo/saveLogoutInfo'),
          headers: {
            'Authorization': 'Bearer ' + accessToken,
            'Content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.body);
      }
    } else {
      final response = await http.post(
          Uri.parse(imwareApiHost + '/api/userInfo/saveLogoutInfo'),
          headers: {
            'Content-type': 'application/json',
          });

      if (response.statusCode == 200) {
      } else {
        // print(response.body);
      }
    }
  }

  @override
  Future<bool> autoLogin(String username, String fcm_token) async {
    final response = await http.post(
        Uri.parse(authApiUrl + '/oauth/autoLogin?username='+ username +'&fcm_token='+ fcm_token),
        headers: {
          'Content-type': 'application/json',
        });
    if (response.statusCode == 200) {
      print("autoLogin success");
      var info = jsonDecode(utf8convert(response.body));

      var t = DateTime.now().add(Duration(seconds: info['expires_in'] * 1000));

      // print(t);


      await saveInforUser(info['access_token'], info['expires_in'],'');
      return true;
    } else {
      return false;
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Unknown error occurred. '});
}

