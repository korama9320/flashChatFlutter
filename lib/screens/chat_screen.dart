import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedin;

class ChatScreen extends StatefulWidget {
  static String chat = "chat";

  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgController = TextEditingController();
  late String msg;
  final _auth = FirebaseAuth.instance;
  void getUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MainStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (msg.trim() != "") {
                        await _firestore.collection("massages").add({
                          "sender": loggedin.email,
                          "text": msg,
                          "date": DateTime.now()
                        });
                        msgController.clear();
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainStream extends StatelessWidget {
  const MainStream({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection("massages").orderBy("date").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("massage now"),
              );
            } else {
              final massage = snapshot.data!.docs.reversed.toList();
              return ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                itemBuilder: ((context, index) {
                  final text = massage[index]['text'];
                  final sender = massage[index]['sender'];
                  final cUser = loggedin.email == sender;
                  return BubbleText(text: text, sender: sender, me: cUser);
                }),
                itemCount: massage.length,
              );
            }
          }),
    );
  }
}

class BubbleText extends StatelessWidget {
  const BubbleText({
    Key? key,
    required this.text,
    required this.sender,
    required this.me,
  }) : super(key: key);

  final String text;
  final String sender;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Color.fromARGB(162, 255, 255, 255)),
          ),
          Material(
              borderRadius: me
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              elevation: 10,
              color:
                  me ? Colors.lightBlue : const Color.fromARGB(255, 58, 56, 56),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(text),
              )),
        ],
      ),
    );
  }
}
