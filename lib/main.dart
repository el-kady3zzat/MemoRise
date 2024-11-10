import 'package:get/get.dart';
import 'package:memorise/theme/colors.dart';
import 'package:memorise/view/auth/login.dart';
import 'package:memorise/view/auth/register.dart';
import 'package:memorise/view/category/category.dart';
import 'package:memorise/locale/locale.dart';
import 'package:memorise/view/note/all_notes.dart';
import 'package:memorise/view/note/new_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memorise/view/note/view_note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp();
  //
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fireAuth.authStateChanges().listen((User? user) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          elevation: 10,
          shadowColor: Colors.yellow,
          centerTitle: true,
          backgroundColor: MemoRiseColors().mainBlue,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      //
      debugShowCheckedModeBanner: false,
      //
      locale: Get.deviceLocale,
      translations: MyLocale(),
      defaultTransition: Transition.zoom,
      //
      initialRoute:
          (fireAuth.currentUser != null && fireAuth.currentUser!.emailVerified)
              ? '/home'
              : '/login',
      //
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/home', page: () => Category()),
        GetPage(name: '/note', page: () => AllNotes()),
        GetPage(name: '/add_note', page: () => NewNote()),
        GetPage(name: '/view_edit_note', page: () => ViewNote()),
      ],
    );
  }

  // String initialRoute() {
  //   if (fireAuth.currentUser != null && fireAuth.currentUser!.emailVerified) {
  //     Constants.uId = fireAuth.currentUser!.uid;
  //     return '/home';
  //   } else {
  //     return '/login';
  //   }
  // }
}
