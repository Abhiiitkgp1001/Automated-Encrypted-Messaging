import 'package:flutter/material.dart';

Widget appBarmain(BuildContext context) {
  return AppBar(
      title: Image.asset(
        "assets/images/at.png",
        height: 40,
        width: 40,
      ),
      backgroundColor: const Color(0xffff4646));
}

InputDecoration textFieldInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.black54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.black54, fontSize: 18);
}

TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.black, fontSize: 19);
}
