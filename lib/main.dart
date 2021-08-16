import 'package:flash_chat_test/models/user_model.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/user_chats_screen.dart';
import 'screens/add_friend_screen.dart';

late bool isLoggedIn;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //check if the user is logged in
  isLoggedIn = UserModel.currentUser != null ? true : false;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flash Chat',
      initialRoute: isLoggedIn ? UserChatsScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        UserChatsScreen.id: (context) => UserChatsScreen(),
        AddFriendScreen.id: (context) => AddFriendScreen(),
      },
    );
  }
}
