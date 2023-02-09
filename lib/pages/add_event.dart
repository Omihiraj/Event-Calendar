import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_calendar/services/fcm_service.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/firebase_service.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String token = '';
  String startTime = "hh:mm";
  String endTime = "hh:mm";
  String decShowTime = "hh:mm";
  String startDate = "yyyy/mm/dd";

  TimeOfDay sTime = TimeOfDay.now();
  TimeOfDay eTime = TimeOfDay.now();
  DateTime sDate = DateTime.now();
  TimeOfDay decTime = TimeOfDay.now();

  String dropdownValue = "15 minutes early";
  String notifyTime = '';
  DateTime notifyDTime = DateTime.now();
  List<String> list = <String>[
    '15 minutes early',
    '01 hour early',
    '01 day early',
  ];
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  int colorIndex = 0;
  bool errorOcuur = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Event"),
          backgroundColor: primaryColor,
        ),
        body: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Title'),
                    TextFormField(
                      controller: title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Enter event title',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Note'),
                    TextFormField(
                      controller: note,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Note';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Enter your note',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Date'),
                    InkWell(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: sDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;
                        setState(() {
                          sDate = newDate;
                          startDate =
                              "${sDate.year}/${sDate.month}/${sDate.day}";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            Text(startDate),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.calendar_month,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start time'),
                            InkWell(
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: sTime,
                                );
                                if (newTime == null) return;
                                setState(() {
                                  sTime = newTime;
                                  String hour =
                                      sTime.hour.toString().padLeft(2, "0");
                                  String minute =
                                      sTime.minute.toString().padLeft(2, "0");
                                  startTime = "$hour:$minute";
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  children: [
                                    Text(startTime),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.access_time_outlined,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End time'),
                            InkWell(
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: eTime,
                                );
                                if (newTime == null) return;
                                setState(() {
                                  eTime = newTime;
                                  String hour =
                                      eTime.hour.toString().padLeft(2, "0");
                                  String minute =
                                      eTime.minute.toString().padLeft(2, "0");
                                  endTime = "$hour:$minute";
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  children: [
                                    Text(endTime),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.access_time_outlined),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Event Color"),
                    const SizedBox(
                      height: 5,
                    ),
                    colorSelecter(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Notify Time"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          underline: Container(),
                          value: dropdownValue,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                              if (dropdownValue == "15 minutes early") {
                                DateTime nTime = DateTime(
                                        sDate.year,
                                        sDate.month,
                                        sDate.day,
                                        sTime.hour,
                                        sTime.minute)
                                    .subtract(const Duration(minutes: 15));
                                notifyTime =
                                    '${nTime.year}-${nTime.month.toString().padLeft(2, '0')}-${nTime.day.toString().padLeft(2, '0')} ${nTime.hour.toString().padLeft(2, '0')}:${nTime.minute.toString().padLeft(2, '0')}:${nTime.second.toString().padLeft(2, '0')}';
                                notifyDTime = DateTime(nTime.year, nTime.month,
                                    nTime.day, nTime.hour, nTime.minute);
                              } else if (dropdownValue == "01 hour early") {
                                DateTime nTime = DateTime(
                                        sDate.year,
                                        sDate.month,
                                        sDate.day,
                                        sTime.hour,
                                        sTime.minute)
                                    .subtract(const Duration(hours: 1));
                                notifyTime =
                                    '${nTime.year}-${nTime.month.toString().padLeft(2, '0')}-${nTime.day.toString().padLeft(2, '0')} ${nTime.hour.toString().padLeft(2, '0')}:${nTime.minute.toString().padLeft(2, '0')}:${nTime.second.toString().padLeft(2, '0')}';
                                notifyDTime = DateTime(nTime.year, nTime.month,
                                    nTime.day, nTime.hour, nTime.minute);
                              } else if (dropdownValue == "01 day early") {
                                DateTime nTime = DateTime(
                                        sDate.year,
                                        sDate.month,
                                        sDate.day,
                                        sTime.hour,
                                        sTime.minute)
                                    .subtract(const Duration(days: 1));
                                notifyTime =
                                    '${nTime.year}-${nTime.month.toString().padLeft(2, '0')}-${nTime.day.toString().padLeft(2, '0')} ${nTime.hour.toString().padLeft(2, '0')}:${nTime.minute.toString().padLeft(2, '0')}:${nTime.second.toString().padLeft(2, '0')}';
                                notifyDTime = DateTime(nTime.year, nTime.month,
                                    nTime.day, nTime.hour, nTime.minute);
                              }
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: decTime,
                            );
                            if (newTime == null) return;
                            setState(() {
                              decTime = newTime;
                              String hour =
                                  decTime.hour.toString().padLeft(2, "0");
                              String minute =
                                  decTime.minute.toString().padLeft(2, "0");
                              decShowTime = "$hour:$minute";

                              notifyTime =
                                  '${sDate.year}-${sDate.month.toString().padLeft(2, '0')}-${sDate.day.toString().padLeft(2, '0')} $hour:$minute';
                              notifyDTime = DateTime(sDate.year, sDate.month,
                                  sDate.day, decTime.hour, decTime.minute);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              children: [
                                Text(decShowTime),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.access_time_outlined,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text('Notification Time : ',
                            style: TextStyle(fontSize: 16)),
                        notifyTime.isEmpty
                            ? const Text('yyyy/mm/dd hh:mm:ss')
                            : Text(notifyTime,
                                style:
                                    const TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (DateTime(sDate.year, sDate.month, sDate.day,
                                      sTime.hour, sTime.minute)
                                  .compareTo(DateTime(sDate.year, sDate.month,
                                      sDate.day, eTime.hour, eTime.minute)) >
                              0) {
                            print("Start time must before End Time");
                            showPopup(
                                "Start time must before End Time", context);
                          } else if (DateTime.now().compareTo(DateTime(
                                  notifyDTime.year,
                                  notifyDTime.month,
                                  notifyDTime.day,
                                  notifyDTime.hour,
                                  notifyDTime.minute)) >
                              0) {
                            showPopup(
                                "Please Setup Notify time after the current time",
                                context);
                          } else {
                            FireService.addEvent(
                                context: context,
                                title: title.text,
                                note: note.text,
                                colorIndex: colorIndex,
                                stime: Timestamp.fromDate(DateTime(
                                    sDate.year,
                                    sDate.month,
                                    sDate.day,
                                    sTime.hour,
                                    sTime.minute)),
                                etime: Timestamp.fromDate(DateTime(
                                    sDate.year,
                                    sDate.month,
                                    sDate.day,
                                    eTime.hour,
                                    eTime.minute)),
                                date:
                                    '${sDate.year}-${sDate.month.toString().padLeft(2, '0')}-${sDate.day.toString().padLeft(2, '0')}');

                            FireService.getToken().then((String t) {
                              setState(() {
                                token = t;
                              });
                              FCMService.sendPushMessage(
                                  token: token,
                                  title: title.text,
                                  note: note.text,
                                  date: notifyTime);
                            });
                          }
                        }
                      },
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          width: width * 0.75,
                          height: 60.0,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text('Add Event',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future showPopup(String error, context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Center(
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          ))),
                )
              ],
            ),
          ));
        });
  }

  Widget colorSelecter() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              setState(() {
                colorIndex = 1;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: colorIndex == 1
                      ? Border.all(
                          color: const Color.fromARGB(193, 158, 158, 158),
                          width: 2)
                      : null,
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)),
            )),
        const SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              setState(() {
                colorIndex = 2;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: colorIndex == 2
                      ? Border.all(
                          color: const Color.fromARGB(193, 158, 158, 158),
                          width: 2)
                      : null,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20)),
            )),
        const SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () {
              setState(() {
                colorIndex = 3;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: colorIndex == 3
                      ? Border.all(
                          color: const Color.fromARGB(193, 158, 158, 158),
                          width: 2)
                      : null,
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20)),
            ))
      ],
    );
  }
}
