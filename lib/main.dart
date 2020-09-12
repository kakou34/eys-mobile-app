import 'package:eys/Authentication/LoginPage.dart';
import 'package:eys/Authentication/UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = ' http://f76090d92ea4.ngrok.io';
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
              var token = userDetails.token;
              var jwt = token.split(".");

              if(jwt.length !=3) {
                return LoginPage();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return MyHomePage("Welcome " + userDetails.username);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
              builder: (context, snapshot) =>
              snapshot.hasData ?
              Column(children: <Widget>[
                Text(title),
              ],)
                  :
              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
          ),
        ),
      );

}


