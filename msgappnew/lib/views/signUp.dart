import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:msgappnew/helper/helpfunction.dart';
import 'package:msgappnew/services/auth.dart';
import 'package:msgappnew/services/database.dart';
import 'package:msgappnew/views/chatroomscreen.dart';
import 'package:msgappnew/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formkey = GlobalKey<FormState>();
  TextEditingController usernametec = new TextEditingController();
  TextEditingController emailtec = new TextEditingController();
  TextEditingController passtec = new TextEditingController();

  signMeUp() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailtec.text, passtec.text)
          .then((value) {
        //print("$value");
        //users.add({'name': usernametec.text, 'email': emailtec.text});
        Map<String, String> userInfo = {
          "name": usernametec.text,
          "email": emailtec.text
        };

        databaseMethods.uploadUserInfo(userInfo);
        HelpFunction.saveUserLoggedInSharedPreferenece(true);
        HelpFunction.saveUserNameSharedPreferenece(usernametec.text);
        HelpFunction.saveUserEmailSharedPreferenece(emailtec.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 200.0,
                            width: 250.0,
                            padding: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Center(child: Image.asset("assets/images/at.png"))),
                        SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  return val.isEmpty || val.length < 3
                                      ? "Enter a username of atleast 3 characters"
                                      : null;
                                },
                                controller: usernametec,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("Username"),
                              ),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Enter a correct email";
                                },
                                controller: emailtec,
                                style: simpleTextStyle(),
                                decoration: textFieldInputDecoration("Email"),
                              ),
                              TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    return val.length > 5
                                        ? null
                                        : "Enter a password of atleast 6 characters";
                                  },
                                  controller: passtec,
                                  style: simpleTextStyle(),
                                  decoration:
                                      textFieldInputDecoration("Password")),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Forgot Password",
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            signMeUp();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xfffd5e53),
                                    const Color(0xffff4646)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have a account?   ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "SignIn now",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
