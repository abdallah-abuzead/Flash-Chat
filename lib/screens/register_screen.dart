import 'package:flash_chat_test/screens/user_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_test/components/custom_button.dart';
import 'package:flash_chat_test/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat_test/components/validation_error.dart';
import 'package:flash_chat_test/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String email = '';
  String password = '';
  String name = '';
  String phone = '';
  bool _showSpinner = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  bool _showPhoneError = false;
  bool _showFillAllFieldsError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 150,
                ),
              ),
              SizedBox(
                height: 40,
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
                errorMessage: emailErrorMessage,
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
                errorMessage: passwordErrorMessage,
                visible: _showPasswordError,
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Full Name'),
                onChanged: (value) {
                  name = value.trim();
                },
              ),
              SizedBox(height: 10),
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
                errorMessage: 'Phone number is already exist.',
                visible: _showPhoneError,
              ),
              ValidationError(
                errorMessage: 'Please fill all the fields.',
                visible: _showFillAllFieldsError,
              ),
              SizedBox(height: 30),
              CustomButton(
                btnColor: Colors.blueAccent,
                btnText: 'Register',
                btnOnPressed: () async {
                  setState(() {
                    _showSpinner = true;
                    _showEmailError = false;
                    _showPasswordError = false;
                    _showFillAllFieldsError = false;
                    _showPhoneError = false;
                  });
                  if (name == '' || phone == '') {
                    await Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _showSpinner = false;
                        _showFillAllFieldsError = true;
                      });
                    });
                  } else {
                    //start check the phone exist
                    if (await UserModel.isUserPhoneExist(phone)) {
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          _showSpinner = false;
                          _showPhoneError = true;
                        });
                      });
                    }
                    //end check the phone exist

                    else {
                      try {
                        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if (userCredential.credential == null) {
                          //Add the user in table users
                          var user = {
                            'name': name,
                            'email': email,
                            'phone': phone,
                            'password': password,
                            'created_at': DateTime.now().millisecondsSinceEpoch,
                            'updated_at': DateTime.now().millisecondsSinceEpoch
                          };
                          UserModel.addUser(user);

                          setState(() {
                            _showSpinner = false;
                          });

                          //Go to the chat screen
                          Navigator.pushNamed(context, UserChatsScreen.id);
                          emailController.clear();
                          passwordController.clear();
                          nameController.clear();
                          phoneController.clear();
                        }
                      } on FirebaseAuthException catch (e) {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _showSpinner = false;
                          });
                        });

                        if (e.code == 'email-already-in-use') {
                          //The account already exists for that email.
                          setState(() {
                            _showEmailError = true;
                            _showPasswordError = false;
                            emailErrorMessage = 'Email is already exists!';
                          });
                        } else if (e.code == 'weak-password') {
                          //The password provided is too weak.
                          setState(() {
                            _showEmailError = false;
                            _showPasswordError = true;
                            passwordErrorMessage = 'Password is too weak!';
                          });
                        } else {
                          //Invalid email format, or null email or password!
                          if (email == '' && password == '') {
                            setState(() {
                              _showEmailError = true;
                              _showPasswordError = true;
                              emailErrorMessage = 'Enter your email.';
                              passwordErrorMessage = 'Enter your password.';
                            });
                          } else if (email != '' && password == '') {
                            setState(() {
                              _showEmailError = false;
                              _showPasswordError = true;
                              passwordErrorMessage = 'Enter your password.';
                            });
                          } else {
                            setState(() {
                              _showEmailError = true;
                              _showPasswordError = false;
                              emailErrorMessage = 'Invalid email format!';
                            });
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
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
