

class SchoolStudent {
  String id;
  String name;
  String email;
  Map<String, dynamic> schoolClass;
  String address;
  String dob;
  List<dynamic> contact;
  List<dynamic> guardian;

  SchoolStudent(this.id, this.name, this.email, this.schoolClass, this.address,
      this.dob, this.contact, this.guardian);

  factory SchoolStudent.fromJson(Map<String, dynamic> json) {
    return SchoolStudent(
        json["_id"].toString(),
        json["name"],
        json["email"],
        json["class"],
        json["address"],
        json["dob"],
        json["contact"],
        json["guardian"]);
  }
}
