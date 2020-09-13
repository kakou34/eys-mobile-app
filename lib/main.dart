import 'package:eys/Authentication/LoginPage.dart';
import 'package:eys/Authentication/Profile.dart';
import 'package:eys/Authentication/UserDetails.dart';
import 'package:eys/Events/AvailableEvents.dart';
import 'package:eys/Events/EventListItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'Commun/Drawer.dart';
import 'Globals.dart';
import 'Routes/Routes.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  Future<String> get userOrEmpty async {
    var user = await storage.read(key: "userDetails");
    if(user == null) return "";
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EYS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: userOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              UserDetails userDetails = UserDetails.fromJson(json.decode(snapshot.data));
              Globals.currentUser = userDetails;
              Globals.isLoggedIn = true;
              Globals.token = userDetails.token;
              var jwt = userDetails.token.split(".");
              if(jwt.length !=3) {
                return LoginPage();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  storage.delete(key: "user");
                  return MyHomePage(title: "EYS");
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }
      ),
      routes:  {
        Routes.profile: (context) => Profile(),
        Routes.home: (context) => MyHomePage(),
        Routes.login: (context) => LoginPage(),
        Routes.availableEvents: (context) => AvailableEvents(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  static const String routeName = '/home';

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EYS")),
      body: Center(child: Text("Welcome to EYS")),



      drawer: AppDrawer(),
    );
  }
}


