import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event(
      {required this.title,
      required this.note,
      required this.color,
      required this.stime,
      required this.etime});
  String title;
  String note;
  int color;
  Timestamp stime;
  Timestamp etime;

  static Event fromJson(Map<String, dynamic> json) => Event(
        title: json["title"],
        note: json["note"],
        color: json["color"],
        stime: json["stime"],
        etime: json["etime"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "note": note,
        "color": color,
        "stime": stime,
        "etime": etime
      };
}
