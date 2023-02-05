import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/event.dart';
import '../services/firebase_service.dart';
import '../utils/date_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();
  DateTime currentDate = DateTime.now();
  String selectDate = "";
  String time = "";
  List<int> datesNo = getDate()[0];
  List<String> datesName = getDate()[1];
  List<String> monthNames = getDate()[2];

  String slotDay = getDate()[1][0];
  String monthName = getDate()[2][0];
  List<int> monthNo = getDate()[3];
  String timeSlot = "";
  int dateItemIndex = 0;
  int? slotItemIndex;
  int? timeItemIndex;

  DateTime? nowDate;
  int dateNo = DateTime.now().weekday;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  holidayView('Poya Day', Colors.greenAccent),
                  holidayView('Bank Holiday', Colors.amberAccent),
                  holidayView('Merchantile Day', Colors.redAccent),
                  holidayView('Poya Day', Colors.blueAccent)
                ],
              )),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: datesNo.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    highlightColor: Colors.amber.withOpacity(0.3),
                    splashColor: Colors.amber.withOpacity(0.3),
                    onTap: () {
                      setState(() {
                        nowDate = DateTime.utc(
                            currentDate.year, monthNo[index], datesNo[index]);
                        slotDay = datesName[index];
                        dateItemIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: dateItemIndex == index
                              ? Colors.amber
                              : Colors.white),
                      margin: const EdgeInsets.only(left: 10.0),
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            "${datesNo[index]}",
                            style: TextStyle(
                                fontSize: 24,
                                color: dateItemIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          )),
                          Center(
                              child: Text(datesName[index],
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: dateItemIndex == index
                                          ? Colors.white
                                          : Colors.grey))),
                          Center(
                              child: Text(
                                  '${currentDate.year}|${monthNames[index]}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: dateItemIndex == index
                                          ? Colors.white
                                          : Colors.grey))),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 300,
            width: double.infinity,
            child: StreamBuilder<List<Event>>(
              stream: FireService.getEvents(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.data == null) {
                        return const Text('No data to show');
                      } else {
                        final events = snapshot.data!;

                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (BuildContext context, int index) {
                            return builtEvent(events[index]);
                          },
                        );
                      }
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget builtEvent(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: checkColor(event.color)),
      child: Column(children: [
        Text(event.title),
        Text(event.note),
        Text(
            '${event.stime.toDate().year}-${event.stime.toDate().month.toString().padLeft(2, '0')}-${event.stime.toDate().day.toString().padLeft(2, '0')}'),
        Text(
            'Start time : ${event.stime.toDate().hour.toString().padLeft(2, '0')} : ${event.stime.toDate().minute.toString().padLeft(2, '0')}'),
        Text(
            'End time : ${event.etime.toDate().hour.toString().padLeft(2, '0')} : ${event.etime.toDate().minute.toString().padLeft(2, '0')}')
      ]),
    );
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

  Widget holidayView(String holiday, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(20)),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(holiday)
        ],
      ),
    );
  }
}
