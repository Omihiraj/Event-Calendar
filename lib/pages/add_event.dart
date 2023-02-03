import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String startTime = "hh:mm";
  String endTime = "hh:mm";
  String startDate = "yyyy/mm/dd";

  TimeOfDay sTime = TimeOfDay.now();
  TimeOfDay eTime = TimeOfDay.now();
  DateTime sDate = DateTime.now();
  String dropdownValue = "15 minutes early";
  int statusNo = 0;
  List<String> list = <String>[
    '15 minutes early',
    '01 hour early',
    '01 day early',
  ];
  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Event Calendar")),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                            border: Border.all(color: Colors.amber)),
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
                                    border: Border.all(color: Colors.amber)),
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
                                    border: Border.all(color: Colors.amber)),
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
                    colorSelecter(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Status", style: TextStyle(color: primaryColor)),
                    DropdownButton<String>(
                      underline: Container(),
                      value: dropdownValue,
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          if (dropdownValue == "15 minutes early") {
                            statusNo = 0;
                          } else if (dropdownValue == "01 hour early") {
                            statusNo = 1;
                          } else if (dropdownValue == "01 day early") {
                            statusNo = 2;
                          }
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Add Event',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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
