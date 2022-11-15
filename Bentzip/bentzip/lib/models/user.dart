class User {
  String token;
  int? id;
  String? name;
  String school;
  int role;


  User(this.token, this.id, this.name, this.school, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["token"],json["id"], json["name"], json["school"], json["role"]);
  }
}
