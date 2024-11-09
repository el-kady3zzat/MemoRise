import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const CustomBackButton(
      {super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: Card(
            color: Colors.blue[900],
            elevation: 3,
            shadowColor: Colors.white,
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
