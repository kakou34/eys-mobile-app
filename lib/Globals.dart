library eys.globals;

import 'package:eys/Authentication/UserDetails.dart';



class Globals {
  static const SERVER_IP = 'http://624156ed9df9.ngrok.io';
  static String token = "";
  static UserDetails currentUser = null;
  static bool isLoggedIn = false;

}