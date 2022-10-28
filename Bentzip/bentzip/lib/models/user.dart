class User {
  String token;
  String school;
  int role;

  User(this.token, this.school, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["token"], json["school"], json["role"]);
  }
}
