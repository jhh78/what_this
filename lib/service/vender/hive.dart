import 'package:hive/hive.dart';
import 'package:whats_this/util/constants.dart';

class HiveService {
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(SYSTEM_CONFIG);
  }

  static dynamic getBoxValue(String name) {
    if (_box == null) {
      throw HiveError('Box has not been initialized.');
    }

    return _box!.get(name);
  }

  static Future<void> putBoxValue(String name, dynamic value) async {
    if (_box == null) {
      throw HiveError('Box has not been initialized.');
    }
    await _box!.put(name, value);
  }

  static Future<void> closeBox() async {
    if (_box != null) {
      await _box!.close();
      _box = null;
    }
  }

  static Future<void> deleteBoxValue(String name) async {
    if (_box == null) {
      throw HiveError('Box has not been initialized.');
    }
    await _box!.delete(name);
  }

  static Future<void> clearBox() async {
    if (_box == null) {
      throw HiveError('Box has not been initialized.');
    }
    await _box!.clear();
  }
}
