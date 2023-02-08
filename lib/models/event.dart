import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event(
      {this.id,
      required this.title,
      required this.note,
      required this.color,
      required this.stime,
      required this.etime,
      required this.date});
  String? id;
  String title;
  String note;
  int color;
  Timestamp stime;
  Timestamp etime;
  String date;

  static Event fromJson(Map<String, dynamic> json) => Event(
      id: json["id"],
      title: json["title"],
      note: json["note"],
      color: json["color"],
      stime: json["stime"],
      etime: json["etime"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "note": note,
        "color": color,
        "stime": stime,
        "etime": etime,
        "date": date,
      };
}
