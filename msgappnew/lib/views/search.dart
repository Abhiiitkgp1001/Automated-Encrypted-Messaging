import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgappnew/helper/const.dart';
import 'package:msgappnew/helper/helpfunction.dart';
import 'package:msgappnew/services/database.dart';
import 'package:msgappnew/views/conversation.dart';
import 'package:msgappnew/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchtec = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSanpshot;
  initiateSearch() {
    databaseMethods.getUserByUsername(searchtec.text).then((val) {
      setState(() {
        searchSanpshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSanpshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSanpshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSanpshot.docs[0].get("name"),
                email: searchSanpshot.docs[0].get("email"),
              );
            })
        : Container();
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String username, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.black87, fontSize: 19),
              ),
              Text(
                email,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConservation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              decoration: BoxDecoration(
                  color: const Color(0xffff4646),
                  borderRadius: BorderRadius.circular(30)),
            ),
          )
        ],
      ),
    );
  }

  createChatRoomAndStartConservation(String username) async {
    if (username != Constants.myName) {
      Constants.myName = await HelpFunction.getUserNameSharedPreferenece();
      print(username);
      print(Constants.myName);
      String chatroomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomId": chatroomId
      };
      databaseMethods.createChatRoom(chatroomId, chatroomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomId)));
    } else {
      print("own msg is not allowed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarmain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchtec,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: "search username",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xfffd5e53),
                              const Color(0xffff4646)
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        child: Image.asset("assets/images/search_white.png")),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
