import 'package:hive/hive.dart';
import 'package:whats_this/util/util.dart';

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

  void showData() => showLog({
        'blockList': blockList,
        'isInit': isInit,
        'userId': userId,
      }, runtimeType);
}
