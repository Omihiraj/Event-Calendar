import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/event.dart';

class FireService {
  static Stream<List<Event>> getEvents(String date) =>
      FirebaseFirestore.instance
          .collection('events')
          .where('date', isEqualTo: date)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

  static Future addEvent({
    required context,
    required String title,
    required String note,
    required int colorIndex,
    required Timestamp stime,
    required Timestamp etime,
    required String date,
  }) async {
    final String eventDocId =
        FirebaseFirestore.instance.collection("events").doc().id;
    final eventDoc =
        FirebaseFirestore.instance.collection("events").doc(eventDocId);
    final eventItem = Event(
      id: eventDocId,
      title: title,
      note: note,
      color: colorIndex,
      stime: stime,
      etime: etime,
      date: date,
    );

    final json = eventItem.toJson();
    await eventDoc.set(json).then((value) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content: SizedBox(
              height: 300,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Success",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 300,
                          child: Lottie.asset('assets/success.json',
                              repeat: false),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
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
    }).catchError((error) {
      print("Some Error Occured");
    });
  }

  static saveToken(String token) async {
    final tokenDoc =
        FirebaseFirestore.instance.collection("tokens").doc('user1');

    await tokenDoc.set({'token': token});
  }

  static Future<String> getToken() async {
    final tokenDoc =
        FirebaseFirestore.instance.collection("tokens").doc('user1');
    DocumentSnapshot snap = await tokenDoc.get();
    return snap['token'];
  }

  static Future<void> deleteEvent(String docId) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return events
        .doc(docId)
        .delete()
        .then((value) => print("Event Deleted Sucessfull"))
        .catchError((error) => print("Failed to delete event: $error"));
  }
}
