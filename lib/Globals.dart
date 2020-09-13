library eys.globals;

import 'package:eys/Authentication/UserDetails.dart';



class Globals {
  static const SERVER_IP = 'http://713a25c1206d.ngrok.io';
  static String token = "";
  static UserDetails currentUser = null;
  static bool isLoggedIn = false;

}