extension Formatter on DateTime {
  String convertDateTimeToString() {
    return '$year-$month-${day}T$hour:$minute:$second+$timeZoneOffset';
  }
}
