import 'package:eys/Routes/Routes.dart';
import 'package:flutter/material.dart';

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
            onTap: () => Navigator.pushReplacementNamed(context, Routes.home),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.profile)
          ),
          ListTile(
            title: Text('Available Events'),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.availableEvents),
          ),
        ],
      ),

    );
  }
}