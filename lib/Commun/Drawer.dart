import 'package:eys/Globals.dart';
import 'package:eys/Routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('EYS'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.home),
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.account_box),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.profile)
          ),
          ListTile(
            title: Text('Available Events'),
            leading: Icon(Icons.format_list_bulleted),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.availableEvents),
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.call_missed_outgoing),
            onTap: () => {
              attemptLogOut(),

              Globals.isLoggedIn = false,
              Globals.token ="",
              Globals.currentUser = null,
              Navigator.pushReplacementNamed(context, Routes.login),
            },
          ),
        ],
      ),

    );
  }

  void attemptLogOut() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}