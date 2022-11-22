class SchoolTeacher {
  int id;
  String name;
  String email;
  String address;
  String dob;
  List<dynamic> contact;
  List<dynamic> education;
  bool selected = false;

  SchoolTeacher(this.id, this.name, this.email, this.address, this.dob,
      this.contact, this.education);

  factory SchoolTeacher.fromJson(Map<String, dynamic> json) {
    return SchoolTeacher(json["_id"], json["name"], json["email"],
        json["address"], json["dob"], json["contact"], json["education"]);
  }
}
