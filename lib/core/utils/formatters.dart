/// Formateadores simples, sin depender de `intl`.
abstract final class Fmt {
  static const List<String> _months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic', //
  ];

  /// 21 oct 2026
  static String date(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// 18 oct 25
  static String dateShort(DateTime d) {
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '${d.day} ${_months[d.month - 1]} $yy';
  }

  /// 5.2 km
  static String km(double v) => '${v.toStringAsFixed(1)} km';

  /// 8 min
  static String minutes(int v) => '$v min';

  /// $1,280.87
  static String money(double v, {bool sign = false}) {
    final neg = v < 0;
    final abs = v.abs();
    final fixed = abs.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    final body = '\$$whole.${parts[1]}';
    if (neg) return '−$body';
    return sign ? '+$body' : body;
  }
}
