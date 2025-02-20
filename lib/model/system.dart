import 'package:hive/hive.dart';

part 'system.g.dart';

@HiveType(typeId: 0)
class SystemConfigModel extends HiveObject {
  @HiveField(0)
  List<String> blockList = [];

  @HiveField(1)
  bool isInit = false;

  @HiveField(2)
  String userId = '';

  SystemConfigModel();

  Map<String, dynamic> debug() {
    return {
      "blockList": blockList,
      "isInit": isInit,
    };
  }
}
