import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/pages/main/index_page.dart';
import 'package:khetmti/pages/authentication/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for connection
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // If user is logged in
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;

            // Reload user data to check if the account still exists
            user?.reload().then((_) {
              // If the user's reload fails (account might be deleted), redirect to LoginPage
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            }).catchError((error) {
              print("Error reloading user: $error");
              // Error during reload - could be user deletion. Redirect to LoginPage
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });

            // If the user is still valid, show the home page
            return IndexPage();
          }

          // If the user is not logged in (null snapshot), show the login page
          return LoginPage();
        },
      ),
    );
  }
}
