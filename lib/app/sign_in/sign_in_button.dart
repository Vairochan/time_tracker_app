import 'package:flutter/material.dart';
import 'package:time_tracker/app/common_widgets/coustom_raised_button.dart';

class SignInButton extends CoustomRaisedButton{
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
}) : super(
    child: Text(
      text,
      style: TextStyle(color: textColor,  fontSize: 15.0),
    ),
    color: color,
    onPressed: onPressed,
  );

}