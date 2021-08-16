import 'package:flash_chat_test/models/user_model.dart';
import 'package:flash_chat_test/screens/user_chats_screen.dart';
import 'package:flash_chat_test/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/screens/add_friend_screen.dart';
import 'package:flash_chat_test/services/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuButton extends StatefulWidget {
  static final String addFriend = 'Add Friend';
  static final String signOut = 'Sign Out';
  static final List<String> choices = [addFriend, signOut];

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  Icon getChoiceIcon(String choice) {
    if (choice == MenuButton.addFriend)
      return Icon(Icons.person_add);
    else
      return Icon(Icons.logout);
  }

  void getChoiceAction(BuildContext context, String choice) {
    if (choice == MenuButton.addFriend)
      Navigator.pushNamed(context, AddFriendScreen.id);
    else if (choice == MenuButton.signOut) {
      UserModel.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.list, color: Colors.white),
      onSelected: (choice) {
        getChoiceAction(context, choice.toString());
      },
      itemBuilder: (context) {
        return MenuButton.choices.map((choice) {
          return PopupMenuItem(
            padding: choice == MenuButton.choices[MenuButton.choices.length - 1]
                ? EdgeInsets.only(bottom: 5, left: 15, right: 15)
                : EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            height: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(choice),
                    getChoiceIcon(choice),
                  ],
                ),
                choice == MenuButton.choices[MenuButton.choices.length - 1]
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Divider(thickness: 2, height: 10),
                      ),
              ],
            ),
            value: choice,
          );
        }).toList();
      },
    );
  }

  void resetDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(''),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text('RESET'),
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text(''),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('CANCEL'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil(UserChatsScreen.id, (route) => false);
                          },
                          child: Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
