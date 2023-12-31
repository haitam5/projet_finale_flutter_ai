// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_finale_mathieu/Dashboard/ListeActivite.dart';
//import 'package:projet_finale_mathieu/Dashboard/ListeActivite.dart';
import 'package:projet_finale_mathieu/Dashboard/dashboard.dart';
import 'firebase_auth.dart';
import 'dart:developer' as devLog;

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'My App',
      messages: LoginMessages(
        userHint: 'Login',
        passwordHint: 'password',
        loginButton: 'Se connecter',
        flushbarTitleError: 'Erreur',
        flushbarTitleSuccess: 'Succès',
      ),
      theme: LoginTheme(
        primaryColor: Color.fromARGB(255, 1, 29, 52),
        accentColor: Colors.amber,
        titleStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: const Color.fromARGB(255, 82, 64, 1),
          backgroundColor: Color.fromARGB(255, 1, 29, 52),
          highlightColor: Colors.tealAccent,
          elevation: 8.0,
          highlightElevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textFieldStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5.0,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      onLogin: (loginData) => _handleLogin(context, loginData),
      onSubmitAnimationCompleted: () {
        // Handle after login animation completion if needed
      },
      // Partie "Forgot Password" retirée
      onSignup: null,
      onRecoverPassword: (String email) async {
        // Implement password recovery logic here
        return null;
      },
    );
  }

  Future<String?> _handleLogin(
      BuildContext context, LoginData loginData) async {
    FirebaseAuthHelper _authHelper = FirebaseAuthHelper();

    UserCredential? userCredential =
        await _authHelper.signIn(loginData.name, loginData.password);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );

    // If login fails, return an error message
    return "Login failed";
  }
}
