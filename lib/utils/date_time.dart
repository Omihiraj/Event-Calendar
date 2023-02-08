class DateCalendar {
  static DateTime now = DateTime.now();
  static DateTime thisMonth = DateTime(now.year, now.month + 1, 0);
  static DateTime nextMonth = DateTime(now.year, now.month + 1 + 1, 0);

  static final day = <int>[];
  static final dayName = <String>[];
  static final monthNo = <int>[];
  static final monthName = <String>[];

  static final holidayType = <int>[];
  static final holidayName = <String>[];

  static const List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  static const List months = [
    'Jan',
    'Feb',
    'March',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static getDate(List holidayList) {
    int today = now.day;
    int i = today;
    int j = 0;

    while (day.length < 30) {
      day.add(i);
      dayName.add(weekdays[checkWeekDay(now.year, now.month + j, i) - 1]);
      monthName.add(months[checkMonth(now.year, now.month + j, i) - 1]);
      monthNo.add(now.month + j);
      int monthVal = now.month + j;

      if (holidayCheck(holidayList, monthVal, i).isNotEmpty) {
        holidayType.add(holidayCheck(holidayList, monthVal, i)[0]);
        holidayName.add(holidayCheck(holidayList, monthVal, i)[1]);
      } else {
        holidayType.add(0);
        holidayName.add('');
      }
      if (thisMonth.day == i) {
        i = 0;
        j = 1;
      }

      i++;
    }
    // for (int p = 0; p < holidayType.length; p++) {
    //   print('$p - ${holidayType[p]}');
    // }
    return [day, dayName, monthName, monthNo, holidayType, holidayName];
  }

  static int checkWeekDay(int year, int month, int day) {
    return DateTime(year, month, day).weekday;
  }

  static int checkMonth(int year, int month, int day) {
    return DateTime(year, month, day).month;
  }

  static List holidayCheck(List holidayList, int monthVal, int i) {
    for (int k = 0; k < holidayList.length; k++) {
      if (DateTime.parse(
                  '${now.year}-${monthVal.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}')
              .compareTo((DateTime.parse(holidayList[k]['date']))) ==
          0) {
        return [holidayList[k]['type'], holidayList[k]['holiday']];
      }
    }
    return [];
  }
}
