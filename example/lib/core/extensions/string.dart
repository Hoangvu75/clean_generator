extension StringExtension on String {
  String toCapitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  int? toInt() {
    return int.tryParse(this);
  }
}
