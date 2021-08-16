import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:flash_chat_test/components/custom_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      // upperBound: 60,
    );
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = ColorTween(begin: Colors.blueAccent, end: Colors.white).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value * 60,
                  ),
                ),
                Expanded(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        textStyle: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: Duration(milliseconds: 300),
                      ),
                    ],
                    totalRepeatCount: 5,
                    pause: Duration(milliseconds: 100),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            CustomButton(
              btnColor: Colors.lightBlueAccent,
              btnText: 'Login',
              btnOnPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            CustomButton(
              btnColor: Colors.blueAccent,
              btnText: 'Register',
              btnOnPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
