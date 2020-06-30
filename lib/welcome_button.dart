import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Function onPressed;

  const WelcomeButton(
      {Key key, this.buttonText, this.buttonColor, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
