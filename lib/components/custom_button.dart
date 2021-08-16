import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.btnColor, this.btnText = '', this.btnOnPressed});

  final Color? btnColor;
  final String btnText;
  final VoidCallback? btnOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 2,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 5,
        color: btnColor,
        child: MaterialButton(
          onPressed: btnOnPressed,
          child: Text(
            btnText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
