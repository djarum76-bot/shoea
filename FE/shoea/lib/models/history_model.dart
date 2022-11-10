import 'package:shoea/utils/constants.dart';

class HistoryModel{
  final String uuid;
  final String name;
  final String accessAt;

  HistoryModel({required this.uuid, required this.name, required this.accessAt});

  HistoryModel.fromMap(Map<String, dynamic> item):
      uuid = item[Constants.uuid],
      name = item[Constants.name],
      accessAt = item[Constants.accessAt];

  Map<String, dynamic> toMap(){
    return {
      Constants.uuid : uuid,
      Constants.name : name,
      Constants.accessAt : accessAt
    };
  }

  @override
  String toString() {
    return 'History{uuid: $uuid, name: $name, access_at: $accessAt}';
  }
}