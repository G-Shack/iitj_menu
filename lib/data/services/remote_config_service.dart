import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/day_menu_model.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  static const String _weeklyMenuKey = 'weekly_menu';
  static const String _menuVersionKey = 'menu_version';

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Set default values
    await _remoteConfig.setDefaults({
      _weeklyMenuKey: _getDefaultMenu(),
      _menuVersionKey: '1.0.0',
    });
  }

  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error fetching remote config: $e');
      return false;
    }
  }

  String get menuVersion => _remoteConfig.getString(_menuVersionKey);

  Map<String, DayMenu> getWeeklyMenu() {
    try {
      final jsonString = _remoteConfig.getString(_weeklyMenuKey);
      final menuData = json.decode(jsonString) as Map<String, dynamic>;

      return {
        'monday': DayMenu.fromJson('monday', menuData['monday']),
        'tuesday': DayMenu.fromJson('tuesday', menuData['tuesday']),
        'wednesday': DayMenu.fromJson('wednesday', menuData['wednesday']),
        'thursday': DayMenu.fromJson('thursday', menuData['thursday']),
        'friday': DayMenu.fromJson('friday', menuData['friday']),
        'saturday': DayMenu.fromJson('saturday', menuData['saturday']),
        'sunday': DayMenu.fromJson('sunday', menuData['sunday']),
      };
    } catch (e) {
      print('Error parsing weekly menu: $e');
      return {};
    }
  }

  String _getDefaultMenu() {
    // Default menu in case Firebase is unavailable
    return json.encode({
      'monday': _getDefaultDayMenu(),
      'tuesday': _getDefaultDayMenu(),
      'wednesday': _getDefaultDayMenu(),
      'thursday': _getDefaultDayMenu(),
      'friday': _getDefaultDayMenu(),
      'saturday': _getDefaultDayMenu(),
      'sunday': _getDefaultDayMenu(),
    });
  }

  Map<String, dynamic> _getDefaultDayMenu() {
    return {
      'breakfast': {
        'name': 'Breakfast',
        'icon': 'sunrise',
        'start_time': '07:00',
        'end_time': '09:30',
        'items': [
          {'name': 'Poha', 'type': 'veg', 'allergens': []},
          {
            'name': 'Bread & Butter',
            'type': 'veg',
            'allergens': ['gluten', 'dairy']
          },
          {
            'name': 'Tea/Coffee',
            'type': 'veg',
            'allergens': ['dairy']
          },
        ],
        'special_note': '',
      },
      'lunch': {
        'name': 'Lunch',
        'icon': 'restaurant',
        'start_time': '11:30',
        'end_time': '14:00',
        'items': [
          {'name': 'Dal', 'type': 'veg', 'allergens': []},
          {'name': 'Sabzi', 'type': 'veg', 'allergens': []},
          {'name': 'Rice', 'type': 'vegan', 'allergens': []},
          {
            'name': 'Roti',
            'type': 'vegan',
            'allergens': ['gluten']
          },
        ],
        'special_note': '',
      },
      'snacks': {
        'name': 'Snacks',
        'icon': 'local_cafe',
        'start_time': '16:30',
        'end_time': '18:00',
        'items': [
          {
            'name': 'Samosa',
            'type': 'veg',
            'allergens': ['gluten']
          },
          {
            'name': 'Tea/Coffee',
            'type': 'veg',
            'allergens': ['dairy']
          },
        ],
        'special_note': '',
      },
      'dinner': {
        'name': 'Dinner',
        'icon': 'dinner_dining',
        'start_time': '19:30',
        'end_time': '22:00',
        'items': [
          {'name': 'Dal', 'type': 'veg', 'allergens': []},
          {'name': 'Sabzi', 'type': 'veg', 'allergens': []},
          {'name': 'Rice', 'type': 'vegan', 'allergens': []},
          {
            'name': 'Roti',
            'type': 'vegan',
            'allergens': ['gluten']
          },
        ],
        'special_note': '',
      },
    };
  }
}
