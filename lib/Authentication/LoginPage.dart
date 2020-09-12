import 'dart:developer';

import 'package:eys/Authentication/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;


const SERVER_IP = 'http://f76090d92ea4.ngrok.io';
final storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    try {
      final credentials = json.encode({"username":username ,"password":password,});

      var res = await http.post(
          "$SERVER_IP/api/auth/signin",
          headers: {'content-type': 'application/json'},
          body: credentials,

      );
      if(res.statusCode == 200) return res.body;
      return null;
    } catch (e) {
      log("EXCEPTIONNNN" + e.toString() );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign In"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var userDetails = await attemptLogIn(username, password);
                    if(userDetails != null) {
                      storage.write(key: "userDetails", value: userDetails);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile.fromJson(json.decode(userDetails))
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Sign In")
              ),
            ],
          ),
        )
    );
  }
}