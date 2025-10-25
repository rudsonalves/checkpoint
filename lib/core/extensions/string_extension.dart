extension StringExtension on String {
  String onlyNumbers() => replaceAll(RegExp(r'\D'), '');

  DateTime? parseBrDateString() {
    final parts = trim().split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;

    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
