import 'package:intl/intl.dart';

class EstimatedTime{
  static String estimatedTime(String etd){
    int first =int.parse(etd.split('-').first);
    int last =int.parse(etd.split('-').last);

    DateTime dt1 = DateTime.now().add(Duration(days: first));
    DateTime dt2 = DateTime.now().add(Duration(days: last));

    if(dt1.month == dt2.month){
      return "Estimated ${DateFormat('MMM').format(dt1)} ${dt1.day}-${dt2.day}";
    }else{
      return "Estimated ${DateFormat('MMM').format(dt1)} ${dt1.day} - ${DateFormat('MMM').format(dt2)} ${dt2.day}";
    }
  }
}