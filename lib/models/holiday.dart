import 'dart:convert';

List<Holiday> holidayFromJson(String str) =>
    List<Holiday>.from(json.decode(str).map((x) => Holiday.fromJson(x)));

String holidayToJson(List<Holiday> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Holiday {
  Holiday({
    required this.date,
    required this.holiday,
  });

  String date;
  String holiday;

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
        date: json["date"],
        holiday: json["holiday"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "holiday": holiday,
      };
}
