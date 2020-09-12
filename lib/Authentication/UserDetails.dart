class UserDetails {
  final String token;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String turkishID;
  final List<dynamic> authorities;

  UserDetails({this.token,
                this.username,
                this.firstname,
                this.lastname,
                this.email,
                this.turkishID,
                this.authorities});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      token: json['token'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      turkishID: json['turkishID'],
      authorities: json['authorities'],
    );
  }
}
