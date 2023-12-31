import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Auth/login.dart';
import 'Auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'; // Add this line

Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDcVXPgwowWQNu7v66Zw9Gxel-G2UMFkGc",
      authDomain: "projet-master-ab1f4.firebaseapp.com",
      projectId: "projet-master-ab1f4",
      storageBucket: "projet-master-ab1f4.appspot.com",
      messagingSenderId: "96046876444",
      appId: "1:96046876444:android:bf77b1a868a18c87845cd9", // Remplacez par la valeur réelle de votre appId
    ),
  );

  runApp(
      MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define your app theme here
      ),
      home: LoginScreen(), // Set the initial route to LoginScreen
    );
  }
}