

import 'package:shared_preferences/shared_preferences.dart';

class HelpFunction {
  static String sharedPreferenceUserLoggedInkey = "ISLOGGEDIN";
  static String sharedPreferenceUserNamekey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailkey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPreferenece(
      bool isUserrLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(
        sharedPreferenceUserLoggedInkey, isUserrLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreferenece(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNamekey, username);
  }

  static Future<bool> saveUserEmailSharedPreferenece(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailkey, email);
  }

  static Future<bool> getUserLoggedInSharedPreferenece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInkey);
  }

  static Future<String> getUserNameSharedPreferenece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNamekey);
  }

  static Future<String> getUserEmailSharedPreferenece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailkey);
  }
}
