/// Short unique ids for records created on the device.
String newId(String prefix) =>
    '$prefix-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
