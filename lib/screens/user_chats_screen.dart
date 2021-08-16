import 'package:flash_chat_test/components/loading.dart';
import 'package:flash_chat_test/models/message_model.dart';
import 'package:flash_chat_test/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/services/constants.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';
import 'package:flash_chat_test/services/chat_screen_args.dart';
import 'package:flash_chat_test/models/user_model.dart';
import 'package:flash_chat_test/models/chat_model.dart';
import 'add_friend_screen.dart';
import 'package:flash_chat_test/components/menu_button.dart';

class UserChatsScreen extends StatefulWidget {
  const UserChatsScreen({Key? key}) : super(key: key);
  static String id = 'user_chats_screen';

  @override
  _UserChatsScreenState createState() => _UserChatsScreenState();
}

class _UserChatsScreenState extends State<UserChatsScreen> {
  TextEditingController searchTextController = TextEditingController();
  String searchText = '';
  bool hasChats = true;
  List<Map<String, dynamic>> chatsData = [];

  void getChats() async {
    String currentUserId = (await UserModel.getCurrentUserData())['user_id'];
    var chats = await ChatModel.getAllUserChats(currentUserId);
    setState(() {
      hasChats = chats.length > 0 ? true : false;
    });
    chats.forEach((chat) async {
      String lastMessage =
          await MessageModel.getLastChatMessage(chatId: chat.chatId, chatUpdatedAt: chat.updatedAt);
      String otherUserId = chat.firstUserId == currentUserId ? chat.secondUserId : chat.firstUserId;
      final otherUser = await UserModel.getUserById(otherUserId);

      setState(() {
        chatsData.add({
          'chat_id': chat.chatId,
          'last_message': lastMessage,
          'chat_name': otherUser['name'],
          'last_timestamp': chat.updatedAt
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getChats();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.teal.shade700,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                color: Colors.black87, //Color(0xff111823)
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: searchTextController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: kSearchTextFieldDecoration,
                        onChanged: (value) {
                          searchText = value.trim();
                        },
                      ),
                    ),
                    MenuButton(),
                  ],
                ),
              ),
              chatsData.isEmpty
                  ? !hasChats
                      ? Expanded(child: Container())
                      : Expanded(child: loading())
                  : Expanded(
                      child: RawScrollbar(
                        thickness: 3,
                        thumbColor: Colors.black,
                        child: ListView.builder(
                          padding: EdgeInsets.all(2),
                          itemCount: chatsData.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            DateTime lastUpdateTime =
                                DateTime.fromMillisecondsSinceEpoch(chatsData[i]['last_timestamp']);
                            return GestureDetector(
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
                                                  Icons.print,
                                                  size: 30,
                                                  color: Colors.grey.shade800,
                                                ),
                                                Icon(
                                                  Icons.share,
                                                  size: 30,
                                                  color: Colors.grey.shade800,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Delete chat with "' +
                                                                chatsData[i]['chat_name'] +
                                                                '"?'),
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
                                                                  //delete chat with id chatsData[index]['chat_id']
                                                                  ChatModel.deleteChat(
                                                                      chatsData[i]['chat_id']);
                                                                  Navigator.of(context).pop();
                                                                  Navigator.popAndPushNamed(
                                                                      context, UserChatsScreen.id);
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
                                                  Icons.more_vert,
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
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ChatScreen.id,
                                  arguments: ChatScreenArgs(
                                    chatId: chatsData[i]['chat_id'],
                                    chatName: chatsData[i]['chat_name'],
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                child: ListTile(
                                  leading: CircleAvatar(
                                      radius: 28, backgroundImage: AssetImage('images/avatar.png')),
                                  title: Text(chatsData[i]['chat_name'], style: TextStyle(fontSize: 18)),
                                  subtitle: Text('${chatsData[i]['last_message']}'),
                                  trailing: Text(
                                    chatsData[i]['last_message'] == ''
                                        ? ''
                                        : '${DateFormat(' hh:mm a').format(lastUpdateTime)}',
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
