class SchoolClass {
  String standard;
  List<dynamic> classes;

  SchoolClass(this.standard, this.classes);

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(json["standard"], json["classes"]);
  }
}
