import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  backgroundColor: Colors.amber,
                  child: user.photoURL == null
                      ? Text(user.displayName!.split('').first.toUpperCase())
                      : null,
                ),
                Text(
                  user.displayName!,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  user.email!,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('logged out 1');
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
        print('logged out 2');
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
