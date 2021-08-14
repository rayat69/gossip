import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late StreamSubscription<User?> _state;
  @override
  void initState() {
    _state = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
    })
      ..onError((e) {
        print(e);
      });
    super.initState();
  }

  @override
  void dispose() {
    _state.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (FirebaseAuth.instance.currentUser != null)
              CircleAvatar(
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              ),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final cred = await signInWithGoogle();
                  print(cred.user?.displayName);
                  print(cred.user?.email);
                  print(cred.user?.photoURL);
                  print(cred.user?.phoneNumber);
                  print(cred.user?.emailVerified);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.login),
              label: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('something 1');

      if (googleUser == null) {
        throw FirebaseAuthException(code: 'dunno');
      }
      print('something 2');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('something 3');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('something 4');

      // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, s) {
      print(e);
      print(s);
      throw e;
    }
  }
}
