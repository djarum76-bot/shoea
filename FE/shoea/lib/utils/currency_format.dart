import 'package:intl/intl.dart';

class CurrencyFormat{
  static String convertToIdr(int number){
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0
    );
    return currencyFormatter.format(number);
  }
}