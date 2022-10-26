class User {
  String token;
  int role;

  User(this.token, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["token"], json["role"]);
  }
}
