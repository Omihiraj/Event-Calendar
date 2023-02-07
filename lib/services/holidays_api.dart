import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class HolidayApi {
  static Future<List> readJson() async {
    final String response = await rootBundle.loadString('assets/holidays.json');
    final data = await json.decode(response);
    final holidays = data['holidays'];
    return holidays;
  }
}
