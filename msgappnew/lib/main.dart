import 'package:flutter/material.dart';
import 'package:msgappnew/helper/authenticate.dart';
import 'package:msgappnew/views/chatroomscreen.dart';
import 'package:msgappnew/views/signIn.dart';
import 'package:msgappnew/views/signUp.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helper/helpfunction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool isLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelpFunction.getUserLoggedInSharedPreferenece().then((value) {
      setState(() {
        print(value);
        if (value != null)
          isLoggedIn = value;
        else
          isLoggedIn = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MsgApp',
            theme: ThemeData(
              primaryColor: Color(0xff145C9E),
              scaffoldBackgroundColor: Color(0xfffdfaf6),
              primarySwatch: Colors.blue,
            ),
            home: isLoggedIn ? ChatRoom() : Authenticate(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}





