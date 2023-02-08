//*******RETURNS TODAY'S DATE AND TIME****************//

String todayDate() {
  //Today: it gets today date time
  var dateTimeObj = DateTime.now();

  //Year
  String year = dateTimeObj.year.toString();

  //Month
  String month = dateTimeObj.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //Day
  String day = dateTimeObj.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //Final Format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

//*******CONVERTING STRING yyymmdd to DATETIME OBJECT**********//

DateTime createDateTimeObj(String yyyymmd) {
  int yyyy = int.parse(yyyymmd.substring(0, 4));
  int mm = int.parse(yyyymmd.substring(4, 6));
  int dd = int.parse(yyyymmd.substring(6, 8));

  DateTime dateTime = DateTime(yyyy, mm, dd);
  return dateTime;
}

//*******CONVERTING DATETIME OBJECT to STRING yyymmdd**********//
String convertDateTime(DateTime dateTime) {
  //year
  String year = dateTime.year.toString();

  //Month
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //Day
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //Final Format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
