import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/holidays_api.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Meeting> holidayMeetings = <Meeting>[];
    HolidayApi.readJson().then((value) {
      for (var item in value) {
        Color color = calendarColorCheck(item["type"]);
        holidayMeetings.add(Meeting(
            item["holiday"],
            DateTime.parse('${item["date"]} 00:00:00'),
            DateTime.parse('${item["date"]} 23:59:00'),
            color,
            false));
      }
      setState(() {
        meetings.addAll(holidayMeetings);
      });
    });
    getDataSource();
  }

  List<Meeting> meetings = <Meeting>[];

  Future<void> getDataSource() async {
    List<Meeting> calMeetings = <Meeting>[];
    final calData = await FirebaseFirestore.instance.collection('events').get();

    calData.docs.forEach((doc) {
      String title = doc["title"];

      Color color = checkColor(doc["color"]);
      Timestamp sTime = doc["stime"];
      Timestamp eTime = doc["etime"];

      calMeetings
          .add(Meeting(title, sTime.toDate(), eTime.toDate(), color, false));
    });

    setState(() {
      meetings.addAll(calMeetings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
            view: CalendarView.month,
            showNavigationArrow: true,
            initialDisplayDate: DateTime.now(),
            dataSource: MeetingDataSource(meetings),
            monthViewSettings: MonthViewSettings(showAgenda: true)));
  }

  Color checkColor(int colorIndex) {
    if (colorIndex == 1) {
      return Colors.greenAccent;
    } else if (colorIndex == 2) {
      return Colors.blueAccent;
    } else if (colorIndex == 3) {
      return Colors.amber;
    }
    return Colors.redAccent;
  }

  Color calendarColorCheck(int colorIndex) {
    if (colorIndex == 1) {
      return poyaDay;
    } else if (colorIndex == 2) {
      return bankHoliday;
    } else if (colorIndex == 3) {
      return merchHoliday;
    } else if (colorIndex == 4) {
      return specialDay;
    }
    return Colors.white;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
