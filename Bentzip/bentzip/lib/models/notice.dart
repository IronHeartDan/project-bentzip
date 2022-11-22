class Notice {
  String id;
  String title;
  String description;
  String date;

  Notice(this.id, this.title, this.description, this.date);

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        json["_id"], json["title"], json["description"], json["date"]);
  }
}
