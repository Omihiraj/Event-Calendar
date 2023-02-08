import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  Map<DateTime, List<Event>> selectedEvents = {};

  @override
  void initState() {
    super.initState();
    super.initState();

    setList();
  }

  void setList() {
    selectedEvents[DateTime.utc(2023, 02, 11)] = [
      Event(
          title: 'Super',
          note: 'Super Note',
          stime: Timestamp.fromDate(DateTime(2023, 02, 08, 11, 30)),
          etime: Timestamp.fromDate(DateTime(2023, 02, 08, 11, 30)),
          color: 2,
          date: '')
    ];
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        selectedEvents[doc["stime"].toDate()]!.add(Event(
            title: doc["title"],
            note: doc["note"],
            stime: doc["stime"],
            etime: doc["etime"],
            color: doc["color"],
            date: doc["date"]));
      }
      // querySnapshot.docs.map((item) => )
    });
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 01, 01),
            lastDay: DateTime.utc(2050, 01, 01),
            focusedDay: DateTime.now(),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat fmt) {
              setState(() {
                format = fmt;
              });
            },
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            eventLoader: _getEventsfromDay,
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
