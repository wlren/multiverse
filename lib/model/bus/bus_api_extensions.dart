extension ToInt on String {
  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }
}

extension ApiEntries on Map<String, dynamic> {
  String? getStringEntry(String key) {
    final value = this[key]!;
    if (value == '-' || value.toString().isEmpty) {
      return null;
    } else {
      return value.toString();
    }
  }

  int? getIntEntry(String key) {
    return getStringEntry(key)?.toInt();
  }

  double? getDoubleEntry(String key) {
    return getStringEntry(key)?.toDouble();
  }
}
