import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FireService {
  static Stream<List<Event>> getEvents() => FirebaseFirestore.instance
      .collection('events')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}
