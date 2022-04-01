import 'dart:io';

import 'package:hello_world_flutter/common/constant/path.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hello_world_flutter/model/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationService extends GetxService {
  Future<User?> getCurrentUser();
  Future<User> signInWithUsernameAndPassword(String email, String password);
  Future<void> signOut();
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
      String username, String password) async {
    await Future.delayed(Duration(seconds: 2));
    password = md5.convert(utf8.encode(password)).toString();

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

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print("đăng nhập thành công");
      var info = jsonDecode(utf8convert(response.body));

      var t = DateTime.now().add(Duration(seconds: info['expires_in'] * 1000));

      print(t);

      saveInforUser(info['access_token'], info['userUid'], info['username'], info['expires_in']);
    } else if (response.statusCode == 400) {
      throw AuthenticationException(message: 'Wrong username or password');
    } else {
      throw AuthenticationException(message: 'Error');
    }

    return User(name: 'Test User', email: username);
  }

  @override
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    print(accessToken);
    if (accessToken != null) {
      saveLogoutInfo();
      final response = await http.post(
          Uri.parse(
              authApiUrl + '/api/logout/logout.do?access_token=' + accessToken),
          headers: {
            'Authorization': 'Bearer ' + accessToken,
            'Content-type': 'application/json',
          });

      if (response.statusCode == 200) {
      } else {
        print(response.body);
        // throw Exception('Error');

      }
    }

    await prefs.clear();
  }

  saveInforUser(String token, String userUid, String username, var expires_in) async {
    final response = await http.post(
        Uri.parse(imwareApiHost + '/api/userInfo/saveLoginInfo'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-type': 'application/json',
        });

    if (response.statusCode == 200) {

    } else {
      print(response.body);
      // throw Exception('Error');
    }
    DateTime now = DateTime.now();
    print(now);
    now = now.add(new Duration(days:0, hours : 0,minutes:0, seconds:0, milliseconds : expires_in*1000));
    print(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();


    await prefs.setString("access_token", token);
    await prefs.setString("userUid", userUid);
    await prefs.setString("username", username);
    await prefs.setString("expires_in", now.toString());
    print(prefs.getString("userUid").toString());
  }

  saveLogoutInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      final response = await http.post(
          Uri.parse(imwareApiHost + '/api/userInfo/saveLogoutInfo'),
          headers: {
            'Authorization': 'Bearer ' + accessToken,
            'Content-type': 'application/json',
          });

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error');
      }
    } else {
      final response = await http.post(
          Uri.parse(imwareApiHost + '/api/userInfo/saveLogoutInfo'),
          headers: {
            'Content-type': 'application/json',
          });

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error');
      }
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Unknown error occurred. '});
}
