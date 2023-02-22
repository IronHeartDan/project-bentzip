class User {
  String token;
  int? id;
  String? name;
  String school;
  String? assignedClass;
  int role;

  User(this.token, this.id, this.name, this.school, this.assignedClass,
      this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["token"], json["id"], json["name"], json["school"],
        json["class"], json["role"]);
  }
}
