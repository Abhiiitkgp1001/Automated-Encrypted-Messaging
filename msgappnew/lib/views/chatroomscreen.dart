import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgappnew/helper/authenticate.dart';
import 'package:msgappnew/helper/const.dart';
import 'package:msgappnew/helper/helpfunction.dart';
import 'package:msgappnew/services/auth.dart';
import 'package:msgappnew/services/database.dart';
import 'package:msgappnew/views/conversation.dart';
import 'package:msgappnew/views/search.dart';
import 'package:msgappnew/widgets/widget.dart';
import 'package:msgappnew/helper/helpfunction.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream<QuerySnapshot> chatRoomStream;

  // ignore: non_constant_identifier_names
  Widget ChatRoomList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                // ignore: missing_required_param
                return ChatRoomsTile(
                    userName: snapshot.data.docs[index]
                        .get("chatroomId")
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].get("chatroomId"));
              });
        });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelpFunction.getUserNameSharedPreferenece();
    print(Constants.myName);
    databaseMethods.getChatRoom(Constants.myName).then((snapshots) {
      setState(() {
        chatRoomStream = snapshots;
        print(
            "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/at.png",
          height: 40,
          width: 40,
        ),
        backgroundColor: const Color(0xffff4646),
        actions: [
          GestureDetector(
            onTap: () {
              HelpFunction.saveUserLoggedInSharedPreferenece(false);
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.cancel),
            ),
          )
        ],
      ),
      body: ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: const Color(0xffff4646),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: const Color(0xffff4646),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
