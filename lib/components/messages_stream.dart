import 'package:flash_chat_test/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';
import 'package:flash_chat_test/models/user_model.dart';

class MessagesStream extends StatefulWidget {
  MessagesStream({required this.chatId});
  final String chatId;
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  Map currentUser = {};

  void getCurrentUser() async {
    final user = await UserModel.getCurrentUserData();
    setState(() {
      currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: MessageModel.getChatMessages(widget.chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }
        if (snapshot.hasError)
          return Text('Something went wrong!');
        // if (snapshot.connectionState == ConnectionState.waiting)
        //   return Expanded(
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         backgroundColor: Colors.lightBlueAccent,
        //       ),
        //     ),
        //   );
        else {
          var messages = snapshot.data?.docs.reversed;
          List<MessageBubble> messagesBubbles = [];
          messages?.forEach((message) async {
            final messageData = {'message_id': message.id, ...(message.data() as Map)};
            messagesBubbles.add(
              MessageBubble(
                message: messageData,
                isMe: messageData['sender_id'] == currentUser['user_id'],
              ),
            );
          });
          return Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              reverse: true,
              children: messagesBubbles,
            ),
          );
        }
      },
    );
  }
}
