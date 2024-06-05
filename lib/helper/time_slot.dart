import 'package:flutter/material.dart';

Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime,
    Duration step, String breakStart, String breakEnd) sync* {
  var hour = startTime.hour;
  var minute = startTime.minute;

  do {
    final hourBreakStart = breakStart.split(":")[0];
    final minuteBreakStart = breakStart.split(":")[1];
    final hourEndStart = breakEnd.split(":")[0];
    final minuteEndStart = breakEnd.split(":")[1];

    final convertBreakStart =
        int.parse(hourBreakStart) * 60 + int.parse(minuteBreakStart);
    final convertEndStart =
        int.parse(hourEndStart) * 60 + int.parse(minuteEndStart);
    print(TimeOfDay(hour: hour, minute: minute).toString());
    final currentTime = hour * 60 + minute;

    if (currentTime >= convertBreakStart && currentTime < convertEndStart) {
    } else {
      yield TimeOfDay(hour: hour, minute: minute);
    }

    minute += step.inMinutes;
    while (minute >= 60) {
      minute -= 60;
      hour++;
    }
  } while (hour < endTime.hour ||
      (hour == endTime.hour && minute <= endTime.minute));
}
