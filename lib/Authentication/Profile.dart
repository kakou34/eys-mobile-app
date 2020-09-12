import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
class Profile extends StatelessWidget {
  Profile({this.username, this.email, this.turkishID,this.lastname,this.firstname, this.authorities});
  final String username;
  final String email;
  final String turkishID;
  final String firstname;
  final String lastname;
  final List<dynamic> authorities;


  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      turkishID: json['turkishID'],
      authorities: json['authorities'],
    );
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(
          child: FutureBuilder(
              builder: (context, snapshot) =>
              Column(children: <Widget>[
                Text( username + "Profile"),
                Text("Firstname: " + firstname),
                Text( "Lastname: " + lastname),
                Text( "Email: " + email),
                Text( "TC: " + turkishID),
              ],)
          ),
        ),
      );

}