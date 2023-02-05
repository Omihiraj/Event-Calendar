import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class FireService {
  static Stream<List<Event>> getEvents() => FirebaseFirestore.instance
      .collection('events')
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
  }) async {
    final String eventDocId =
        FirebaseFirestore.instance.collection("events").doc().id;
    final eventDoc =
        FirebaseFirestore.instance.collection("events").doc(eventDocId);
    final eventItem = Event(
      title: title,
      note: note,
      color: colorIndex,
      stime: stime,
      etime: etime,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.warning, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text(
                        "Success",
                        style: TextStyle(color: Colors.redAccent),
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
                        child: Text("Ok")),
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
}
