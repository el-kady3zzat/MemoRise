import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double fontSize;
  final double height;

  const CustomMaterialButton(
      {super.key,
      required this.text,
      this.onPressed,
      required this.fontSize,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: height == 0 ? 55 : height,
      color: Colors.blue[900],
      textColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );
  }
}
