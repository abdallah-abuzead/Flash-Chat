import 'package:flash_chat_test/models/chat_model.dart';
import 'package:flash_chat_test/screens/user_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/models/user_model.dart';
import 'package:flash_chat_test/services/constants.dart';
import 'package:flash_chat_test/components/validation_error.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat_test/components/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);
  static String id = 'add_friend_screen';
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  TextEditingController phoneController = TextEditingController();
  String phone = '';
  bool _showPhoneError = false;
  bool _showSpinner = false;
  String phoneErrorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Add Friend',
                    style: GoogleFonts.actor(
                      textStyle: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phoneController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Phone Number'),
                  onChanged: (value) {
                    phone = value.trim();
                  },
                ),
                ValidationError(
                  errorMessage: phoneErrorMessage,
                  visible: _showPhoneError,
                ),
                SizedBox(height: 20),
                CustomButton(
                  btnColor: Colors.green.shade600,
                  btnText: 'Add',
                  btnOnPressed: () async {
                    if (phone == '') {
                    } else {
                      setState(() {
                        _showSpinner = true;
                        _showPhoneError = false;
                      });

                      var currentUser = await UserModel.getCurrentUserData();
                      final otherUser = await UserModel.getUserByPhone(phone);

                      //check if is my phone
                      if (currentUser['phone'] == phone) {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _showSpinner = false;
                            _showPhoneError = true;
                            phoneErrorMessage = 'The is your phone number!.';
                          });
                        });
                      }
                      //check if the user is registered
                      else if (otherUser.length == 0) {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _showSpinner = false;
                            _showPhoneError = true;
                            phoneErrorMessage = 'There is no user with such phone number!.';
                          });
                        });
                      } else {
                        //check if there is a chat between these two users or no
                        if (await ChatModel.isChatExist(
                          currentUserId: currentUser['user_id'],
                          otherUserId: otherUser['user_id'],
                        )) {
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _showSpinner = false;
                              _showPhoneError = true;
                              phoneErrorMessage = 'This user is already exists in your friends list.';
                            });
                          });
                        } else {
                          //create chat
                          ChatModel chat = ChatModel();
                          chat.firstUserId = currentUser['user_id'];
                          chat.secondUserId = otherUser['user_id'];
                          chat.createdAt = DateTime.now().millisecondsSinceEpoch;
                          chat.updatedAt = DateTime.now().millisecondsSinceEpoch;
                          chat.create();
                          Navigator.pushReplacementNamed(context, UserChatsScreen.id);
                        }
                        phoneController.clear();
                        phone = '';
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
