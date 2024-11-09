import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey[200],
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(150))),
        child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(18),
            child: Image.asset('assets/images/notes_logo.png')),
      ),
    );
  }
}
