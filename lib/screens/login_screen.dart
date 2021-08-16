import 'package:flash_chat_test/screens/user_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/components/custom_button.dart';
import 'package:flash_chat_test/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat_test/components/validation_error.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  bool _showSpinner = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                height: 60,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              ValidationError(
                errorMessage: 'Email is not found!',
                visible: _showEmailError,
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              ValidationError(
                errorMessage: 'Incorrect password!',
                visible: _showPasswordError,
              ),
              SizedBox(height: 30),
              CustomButton(
                btnColor: Colors.lightBlueAccent,
                btnText: 'Login',
                btnOnPressed: () async {
                  setState(() {
                    _showSpinner = true;
                    _showEmailError = false;
                    _showPasswordError = false;
                  });
                  try {
                    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    // UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    //   email: 'b@gmail.com',
                    //   password: '123456',
                    // );
                    if (userCredential.credential == null) {
                      Navigator.pushNamed(context, UserChatsScreen.id);
                      // emailController.clear();
                      // passwordController.clear();
                      setState(() {
                        _showSpinner = false;
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    await Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _showSpinner = false;
                      });
                    });

                    if (e.code == 'user-not-found') {
                      //No user found for that email.
                      setState(() {
                        _showEmailError = true;
                        _showPasswordError = false;
                      });
                    } else if (e.code == 'wrong-password') {
                      //Wrong password provided for that user.
                      setState(() {
                        _showEmailError = false;
                        _showPasswordError = true;
                      });
                    } else {
                      setState(() {
                        _showEmailError = true;
                        _showPasswordError = true;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
