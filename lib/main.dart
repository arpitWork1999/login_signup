import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:lognsignup/home.dart';
//import 'package:lognsignup/sign_up.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCTVzZIccpIu8k7RrtTZ60nu_4R-Qi-vuU",
          appId: "1:463330443273:android:825da4143d200c5559b8d8",
          messagingSenderId: "463330443273",
          projectId: "authfirebase-898cc"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (_, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sign up',
        home: HomePage(),
        //home: SignUp(),
      ),
    );
  }
}
