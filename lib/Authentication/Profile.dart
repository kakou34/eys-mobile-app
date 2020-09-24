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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                              child: Text('Profile Of ' + userDetails.username,
                                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.blue))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                              child: Text('First Name: ' + userDetails.firstname ,
                                  style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                              child: Text('Last Name: ' + userDetails.lastname ,
                                  style: TextStyle(fontSize: 16))),
                          Divider(),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                              child: Text('Email: ' + userDetails.email ,
                                  style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                              child: Text('TC : ' + userDetails.turkishID ,
                                  style: TextStyle(fontSize: 16))),
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
