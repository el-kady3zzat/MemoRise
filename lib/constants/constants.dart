import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  static final String uId = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.uid
      : '';
}
