import 'package:flutter/material.dart';
import 'package:time_tracker/app/common_widgets/coustom_raised_button.dart';

class FormSubmitButton extends CoustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
}) : super(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    ),
    height: 44.0,
    color: Colors.indigo,
    borderRadius:4.0,
    onPressed: onPressed,

  );
}