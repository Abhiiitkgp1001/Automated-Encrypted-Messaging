import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgappnew/helper/helpfunction.dart';
import 'package:msgappnew/services/auth.dart';
import 'package:msgappnew/services/database.dart';
import 'package:msgappnew/widgets/widget.dart';

import 'chatroomscreen.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  final formkey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailtec = new TextEditingController();
  TextEditingController passtec = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(emailtec.text, passtec.text)
          .then((value) {
        if (value != null) {
          // print("signned In");
          databaseMethods.getUserByEmail(emailtec.text).then((val) {
            snapshotUserInfo = val;
            HelpFunction.saveUserNameSharedPreferenece(
                    snapshotUserInfo.docs[0].get("name"))
                .then((value) {
              print(value);
            });
            //print("${snapshotUserInfo.docs[0].get("name")}");
          });
          HelpFunction.saveUserLoggedInSharedPreferenece(true);
          HelpFunction.saveUserEmailSharedPreferenece(emailtec.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
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
                        decoration: textFieldInputDecoration("Password")),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
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
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have a account?   ",
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
                        "Register now",
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
