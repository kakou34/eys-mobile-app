import 'dart:developer';
import 'package:eys/Authentication/Profile.dart';
import 'package:eys/Authentication/UserDetails.dart';
import 'package:eys/Globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

final storage = FlutterSecureStorage();
const SERVER_IP = Globals.SERVER_IP;

class LoginPage extends StatelessWidget {
  static const String routeName = '/signIn';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String> attemptLogIn(String username, String password) async {
    try {
      final credentials = json.encode({
        "username": username,
        "password": password,
      });
      var res = await http.post(
        "$SERVER_IP/api/auth/signin",
        headers: {'content-type': 'application/json'},
        body: credentials,
      );
      if (res.statusCode == 200) {
        return res.body;
      }
      return null;
    } catch (e) {
      log("EXCEPTIONNNN" + e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Sign In"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var userDetails = await attemptLogIn(username, password);
                    if (userDetails != null) {
                      storage.write(key: "userDetails", value: userDetails);
                      UserDetails user =
                          UserDetails.fromJson(json.decode(userDetails));
                      Globals.currentUser = user;
                      Globals.isLoggedIn = true;
                      Globals.token = user.token;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    } else {
                      displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password");
                    }
                  },
                  child:
                      Text("Sign In", style: TextStyle(color: Colors.white))),
            ],
          ),
        ));
  }
}
