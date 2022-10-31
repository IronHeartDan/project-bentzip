class User {
  String token;
  String? name;
  String school;
  int role;

  User(this.token, this.name, this.school, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["token"], json["name"], json["school"], json["role"]);
  }
}
