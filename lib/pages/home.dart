import 'package:event_calendar/constants/constants.dart';
import 'package:event_calendar/services/holidays_api.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/event.dart';
import '../models/holiday.dart';
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

  List<int> datesNo = [];
  List<String> datesName = [];
  List<String> monthNames = [];

  List<int> holidayType = [];
  List<String> holidayName = [];

  String slotDay = "";
  String monthName = "";
  List<int> monthNo = [];
  String timeSlot = "";
  int dateItemIndex = 0;
  int? slotItemIndex;
  int? timeItemIndex;

  DateTime nowDate = DateTime.now();
  int dateNo = DateTime.now().weekday;
  bool isChecked = false;
  List<Holiday>? holidays;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    HolidayApi.readJson().then((value) {
      return value;
    }).then((value) {
      setState(() {
        List fullCalendar = DateCalendar.getDate(value);
        datesNo = fullCalendar[0];
        datesName = fullCalendar[1];
        monthNames = fullCalendar[2];
        slotDay = fullCalendar[1][0];
        monthName = fullCalendar[2][0];
        monthNo = fullCalendar[3];

        holidayType = fullCalendar[4];
        holidayName = fullCalendar[5];
      });
    });
  }

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
                  holidayView('Poya Day', poyaDay),
                  holidayView('Bank Holiday', bankHoliday),
                  holidayView('Merchantile Day', merchHoliday),
                  holidayView('Special Day', specialDay)
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
                              ? secondaryColor
                              : calendarColorCheck(holidayType[index])),
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
                                    : holidayType[index] > 0
                                        ? Colors.white
                                        : Colors.grey),
                          )),
                          Center(
                              child: Text(datesName[index],
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: dateItemIndex == index
                                          ? Colors.white
                                          : holidayType[index] > 0
                                              ? Colors.white
                                              : Colors.grey))),
                          Center(
                              child: holidayType[index] > 0
                                  ? Text(holidayName[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: dateItemIndex == index
                                              ? Colors.white
                                              : holidayType[index] > 0
                                                  ? Colors.white
                                                  : Colors.grey))
                                  : Text(
                                      '${currentDate.year}|${monthNames[index]}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: dateItemIndex == index
                                              ? Colors.white
                                              : holidayType[index] > 0
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
              stream: FireService.getEvents(
                  '${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}'),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Lottie.asset('assets/no-event.json',
                            repeat: false);
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
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: checkColor(event.color)),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.75,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                event.title,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 5),
              Text(
                event.note,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${event.stime.toDate().year}-${event.stime.toDate().month.toString().padLeft(2, '0')}-${event.stime.toDate().day.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined, color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${event.stime.toDate().hour.toString().padLeft(2, '0')} : ${event.stime.toDate().minute.toString().padLeft(2, '0')} ${event.stime.toDate().hour > 12 ? 'PM' : 'AM'}   to  ${event.etime.toDate().hour.toString().padLeft(2, '0')} : ${event.etime.toDate().minute.toString().padLeft(2, '0')} ${event.etime.toDate().hour > 12 ? 'PM' : 'AM'}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      FireService.deleteEvent(event.id!);
                    },
                    icon: const Icon(Icons.delete, color: Colors.black54))
              ],
            ),
          )
        ],
      ),
    );
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
