import 'package:intl/intl.dart';

class Money {
  Money._();
  static final _usd = NumberFormat.simpleCurrency(name: 'USD');
  static String format(double value, {String currency = 'USD'}) {
    if (currency == 'USD') return _usd.format(value);
    return NumberFormat.simpleCurrency(name: currency).format(value);
  }
}
