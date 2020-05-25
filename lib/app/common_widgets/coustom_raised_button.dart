import 'package:flutter/material.dart';



class CoustomRaisedButton extends StatelessWidget {

  CoustomRaisedButton({
    this.child,
    this.color,
    this.borderRadius: 15,
    this.onPressed,
    this.height: 50,
    this.elevation: 20,
  });
  final Widget child;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double elevation;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        elevation: 40,
        onPressed:onPressed,
        child:child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius)
          ),
        ),
        disabledColor: color,
        color:color,

      ),
    );
  }
}
