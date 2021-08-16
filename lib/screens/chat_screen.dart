import 'package:flash_chat_test/models/chat_model.dart';
import 'package:flash_chat_test/screens/user_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/components/messages_stream.dart';
import 'package:flash_chat_test/models/message_model.dart';
import 'package:flash_chat_test/services/chat_screen_args.dart';
import 'package:flash_chat_test/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController inputTextController = TextEditingController();
  String inputText = '';

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, UserChatsScreen.id);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatScreenArgs;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('⚡ ${args.chatName}'),
          backgroundColor: Colors.lightBlue,
          leading: TextButton(
            child: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, UserChatsScreen.id);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(chatId: args.chatId),
            Column(
              children: [
                Divider(
                  color: Colors.blue,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputTextController,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                          ),
                          onChanged: (value) {
                            inputText = value.trim();
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (inputText != '') {
                            final currentUserData = await UserModel.getCurrentUserData();
                            final currentChat = await ChatModel.getChatById(args.chatId);
                            String senderId = currentUserData['user_id'];
                            String receiverId = currentChat['first_user_id'] == senderId
                                ? currentChat['second_user_id']
                                : currentChat['first_user_id'];

                            MessageModel.addMessage({
                              'sender_id': senderId,
                              'receiver_id': receiverId,
                              'chat_id': args.chatId,
                              'text': inputText,
                              'created_at': DateTime.now().millisecondsSinceEpoch
                            });
                            inputText = '';
                            inputTextController.clear();
                          }
                        },
                        child: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
