import 'package:intl/intl.dart';

class TimeRelatedFunction {
  // This is to return Round Down Time Example (9.59am = 9:00)
  String getCurrentHour() {
    DateTime currentDate = DateTime.now();
    DateTime timeNor = DateTime(
        currentDate.year, currentDate.month, currentDate.day, currentDate.hour);
    timeNor = timeNor.subtract(Duration(
        minutes: timeNor.minute,
        seconds: timeNor.second,
        milliseconds: timeNor.millisecond));
    String currentHour = DateFormat('HH:mm:ss')
        .format(timeNor.toUtc().add(const Duration(hours: 8)));
    return currentHour;
  }

  String getCurrentDate() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yyyy').format(currentDate);
    return formattedDate;
  }

  String getCurrentTime() {
    DateTime currentDate = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(currentDate);
    return formattedTime;
  }
}
