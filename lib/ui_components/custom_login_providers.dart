import 'package:flutter/material.dart';

class CustomLoginMethods extends StatelessWidget {
  final void Function()? onFacebookPressed;
  final void Function()? onGooglePressed;
  final void Function()? onApplePressed;

  const CustomLoginMethods(
      {super.key,
      this.onFacebookPressed,
      this.onGooglePressed,
      this.onApplePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: MaterialButton(
            onPressed: onFacebookPressed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.grey[200],
            child: Image.asset('assets/images/facebook.png'),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        SizedBox(
          width: 60,
          height: 60,
          child: MaterialButton(
            onPressed: onGooglePressed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.grey[200],
            child: Image.asset('assets/images/google.png'),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        SizedBox(
          width: 60,
          height: 60,
          child: MaterialButton(
            onPressed: onApplePressed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.grey[200],
            child: Image.asset('assets/images/apple.png'),
          ),
        ),
      ],
    );
  }
}
