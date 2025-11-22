import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/day_menu_model.dart';

class CacheService {
  static const String _menuBoxName = 'menu_cache';
  static const String _menuKey = 'weekly_menu';
  static const String _versionKey = 'menu_version';
  static const String _timestampKey = 'last_updated';

  late Box _box;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_menuBoxName);
  }

  Future<void> cacheMenu(
    Map<String, DayMenu> weeklyMenu,
    String version,
  ) async {
    final menuJson = weeklyMenu.map(
      (key, value) => MapEntry(key, value.toJson()),
    );

    await _box.put(_menuKey, json.encode(menuJson));
    await _box.put(_versionKey, version);
    await _box.put(_timestampKey, DateTime.now().toIso8601String());
  }

  Map<String, DayMenu>? getCachedMenu() {
    try {
      final menuString = _box.get(_menuKey) as String?;
      if (menuString == null) return null;

      final menuData = json.decode(menuString) as Map<String, dynamic>;
      return menuData.map(
        (key, value) => MapEntry(
          key,
          DayMenu.fromJson(key, value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      print('Error retrieving cached menu: $e');
      return null;
    }
  }

  String? getCachedVersion() {
    return _box.get(_versionKey) as String?;
  }

  DateTime? getLastUpdated() {
    final timestamp = _box.get(_timestampKey) as String?;
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  bool isCacheValid({Duration maxAge = const Duration(days: 7)}) {
    final lastUpdated = getLastUpdated();
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated) < maxAge;
  }

  Future<void> clearCache() async {
    await _box.clear();
  }
}
