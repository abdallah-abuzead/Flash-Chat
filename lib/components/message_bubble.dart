import 'package:flash_chat_test/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/models/user_model.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({required this.message, required this.isMe});
  final Map message;
  final bool isMe;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String userName = '';

  void updateUI() async {
    final sender = await UserModel.getUserById(widget.message['sender_id']);
    if (mounted)
      setState(() {
        userName = sender['name'];
      });
  }

  @override
  Widget build(BuildContext context) {
    updateUI();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(userName, style: TextStyle(color: Colors.black54, fontSize: 12)),
          GestureDetector(
            child: Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  widget.message['text'],
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isMe ? Colors.white : Colors.black54,
                  ),
                ),
              ),
              elevation: 5,
              color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
              borderRadius: widget.isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
            ),
            onLongPress: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true, // remove the dialog when click in the screen
                transitionDuration: Duration(milliseconds: 500),
                barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                barrierColor: Colors.black.withOpacity(0.5),
                pageBuilder: (context, _, __) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                              Icon(
                                Icons.reply,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                              Icon(
                                Icons.star,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Delete message from everyone?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('CANCEL'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('DELETE'),
                                              onPressed: () {
                                                MessageModel.deleteMessage(widget.message['message_id']);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              Icon(
                                Icons.copy,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                              Icon(
                                Icons.redo,
                                size: 30,
                                color: Colors.grey.shade800,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ).drive(Tween<Offset>(
                      begin: Offset(0, -1.0),
                      end: Offset.zero,
                    )),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
