import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static sendPushMessage({
    required String token,
    required String title,
    required String note,
    required String date,
  }) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAxJoEEnQ:APA91bFc8u4dDI-kKx8cDdofsIL8bbiZ4w1eZrqaRNyCUKz6bDWXnV_ZwfqLQobk8bwxA6L5QidDwmJVp4ncLH1Bx75lddE1-z430x2S4LtqBtyywfA1OAyRG2581AFmhjuvHDzkvq_0'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': note,
              'title': title,
              "isScheduled": true,
              "scheduledTime": date
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': note,
              'android_channel_id': 'dbfood'
            },
            'to': token,
          }));
    } catch (e) {
      if (kDebugMode) {
        print('Error push notification : ${e}');
      }
    }
  }
}
