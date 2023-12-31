import 'package:flutter/material.dart';
import 'package:projet_finale_mathieu/Auth/login.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your profile information widgets can be added here

            ElevatedButton(
              onPressed: () {
                // Navigate to the login screen and close the current one
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
