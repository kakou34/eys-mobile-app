import 'dart:convert';
import 'dart:developer';

import 'package:eys/Authentication/LoginPage.dart';
import 'package:eys/Authentication/UserDetails.dart';
import 'package:eys/Commun/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class Profile extends StatelessWidget {
  static const String routeName = '/profile';
  Future<String> get userOrEmpty async {
    var user = await storage.read(key: "userDetails");
    if (user == null) return "";
    return user;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Profile")),
        drawer: AppDrawer(),
        body: Center(
          child: FutureBuilder(
              future: userOrEmpty,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data != "") {
                  UserDetails userDetails =
                      UserDetails.fromJson(json.decode(snapshot.data));
                  var token = userDetails.token;
                  var jwt = token.split(".");
                  if (jwt.length != 3) {
                    return LoginPage();
                  } else {
                    var payload = json.decode(
                        ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                    if (DateTime.fromMillisecondsSinceEpoch(
                            payload["exp"] * 1000)
                        .isAfter(DateTime.now())) {
                      return Column(
                        children: <Widget>[
                          Text(userDetails.username + "Profile"),
                          Text("Firstname: " + userDetails.firstname),
                          Text("Lastname: " + userDetails.lastname),
                          Text("Email: " + userDetails.email),
                          Text("TC: " + userDetails.turkishID),
                        ],
                      );
                    } else {
                      return LoginPage();
                    }
                  }
                } else {
                  return LoginPage();
                }
              }),
        ),
      );
}
