import 'dart:convert';
import 'dart:math';

class Encryption {

  static int pre = 5;

  static String encrypt(String s) {
    if (s.isEmpty) {
      return "";
    }
    s = s.toUpperCase();
    Random random = new Random();
    int randomNumber = random.nextInt(10); // from 0 upto 10 included
    randomNumber = randomNumber + 1;
    String result = String.fromCharCode(randomNumber.toString().codeUnitAt(0) + pre);
    for (int i = 0; i < s.length; i++) {
      int pos = s.codeUnitAt(i);
      String char = String.fromCharCode(pos+randomNumber);
      result+= char;
    }

    return result;
  }

  static String decrypt(String s){
    if (s.isEmpty || s.length < 2) {
      return "";
    }
    String result = "";
    int randomNumber = int.parse(String.fromCharCode(s.codeUnitAt(0) - pre));
    s = s.substring(1);
    for(int i = 0; i < s.length; i++){
      int pos = s.codeUnitAt(i);
      String char = String.fromCharCode(pos-randomNumber);
      result+= char;
    }
    return result;
  }
}
