import 'package:flutter/material.dart';

Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime,
    Duration step, String breakStart, String breakEnd) sync* {
  var hour = startTime.hour;
  var minute = startTime.minute;
  print("endTime: ${endTime.toString()}");
  do {
    final hourBreakStart = breakStart.split(":")[0];
    final minuteBreakStart = breakStart.split(":")[1];
    final hourEndStart = breakEnd.split(":")[0];
    final minuteEndStart =   breakEnd.split(":")[1];
    
    print("Break time: $hourBreakStart:$minuteBreakStart");
    print("End time: $hourEndStart:$minuteEndStart");
    final convertBreakStart =
        int.parse(hourBreakStart) * 60 + int.parse(minuteBreakStart);
    final convertEndStart =
        int.parse(hourEndStart) * 60 + int.parse(minuteEndStart);
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
