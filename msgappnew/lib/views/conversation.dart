import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgappnew/helper/const.dart';
import 'package:msgappnew/services/database.dart';
import 'package:msgappnew/widgets/widget.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messagetec = new TextEditingController();
  int cnt = 0;
  Stream<QuerySnapshot> chatMessageStream;

  // ignore: non_constant_identifier_names
  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    snapshot.data.docs[index].get("message"),
                    snapshot.data.docs[index].get("sendby") ==
                        Constants.myName);
              });
        });
  }

  Widget ChatMessageListDecrypt() {
    // print("hi");
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    decryptmsg(snapshot.data.docs[index].get("message")),
                    snapshot.data.docs[index].get("sendby") ==
                        Constants.myName);
              });
        });
  }

  encryptmsg(String msg) {
    final plainText = msg;
    final key = encrypt.Key.fromUtf8('encrypt_int_64_args.takeOf.abhi@');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(encrypted.base64);
    return encrypted.base64;
  }

  decryptmsg(final msg) {
    final key = encrypt.Key.fromUtf8('encrypt_int_64_args.takeOf.abhi@');
    final iv = encrypt.IV.fromLength(16);
    //print(msg);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    //final encrypted = encrypter.encrypt(msg, iv: iv);
    final decrypted = encrypter.decrypt64(msg, iv: iv);
    print("Decrypted:--->");
    print(decrypted);
    return decrypted;
  }

  sendMessage() {
    if (messagetec.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": encryptmsg(messagetec.text),
        "sendby": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      //decryptmsg(encryptmsg(messagetec.text));
      messagetec.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
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
              setState(() {
                cnt++;
                // print(cnt);
              });
              //ChatMessageListDecrypt();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.charging_station_sharp),
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            (cnt % 2 == 0) ? ChatMessageList() : ChatMessageListDecrypt(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                decoration: BoxDecoration(color: Colors.black45),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messagetec,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffe3f6f5),
                                    const Color(0xffbae8e8)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: appBarmain(context),
  //     body: Container(
  //       child: Container(
  //         child: Stack(
  //           children: [
  //             ChatMessageList(),
  //             Container(
  //               alignment: Alignment.bottomCenter,
  //               color: Color(0x54FFFFFF),
  //               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                       child: TextField(
  //                     controller: messagetec,
  //                     style: TextStyle(color: Colors.white),
  //                     decoration: InputDecoration(
  //                         hintText: "Message",
  //                         hintStyle: TextStyle(color: Colors.white54),
  //                         border: InputBorder.none),
  //                   )),
  //                   GestureDetector(
  //                     onTap: () {
  //                       sendMessage();
  //                     },
  //                     child: Container(
  //                         height: 40,
  //                         width: 40,
  //                         padding: EdgeInsets.all(12),
  //                         decoration: BoxDecoration(
  //                             gradient: LinearGradient(colors: [
  //                               const Color(0x36FFFFFF),
  //                               const Color(0x0FFFFFFF)
  //                             ]),
  //                             borderRadius: BorderRadius.circular(40)),
  //                         child: Image.asset("assets/images/Send.png")),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            isSendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: isSendByMe ? Color(0xff706c61) : Color(0xff29a19c),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
