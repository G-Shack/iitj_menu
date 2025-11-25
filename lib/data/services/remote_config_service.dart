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
        'start_time': '08:00',
        'end_time': '10:30',
        'veg': [
          'Poha (Aloo/Sev)',
          'Sambhar',
          'Banana (2)',
          'Bread',
          'Butter',
          'Milk',
          'Tea',
          'Coffee'
        ],
        'non_veg': [
          'Idli & Medu Vada',
          'Sambhar',
          'Coconut Chutney',
          'Boiled egg (2)',
          'Toasted bread',
          'Butter',
          'Milk',
          'Tea',
          'Coffee'
        ],
        'jain': ['Banana (2)'],
        'special_note_veg': '',
        'special_note_non_veg': '',
      },
      'lunch': {
        'name': 'Lunch',
        'icon': 'restaurant',
        'start_time': '12:30',
        'end_time': '15:00',
        'veg': [
          'Plain Rice',
          'Dal',
          'Sabzi',
          'Roti',
          'Curd',
          'Salad',
          'Pickle'
        ],
        'non_veg': [
          'Plain Rice',
          'Dal',
          'Sabzi',
          'Roti',
          'Curd',
          'Salad',
          'Pickle'
        ],
        'jain': [],
        'special_note_veg': '',
        'special_note_non_veg': '',
      },
      'snacks': {
        'name': 'Snacks',
        'icon': 'local_cafe',
        'start_time': '17:30',
        'end_time': '18:30',
        'veg': ['Samosa', 'Chutney', 'Tea', 'Coffee'],
        'non_veg': ['Samosa', 'Chutney', 'Tea', 'Coffee'],
        'jain': [],
        'special_note_veg': '',
        'special_note_non_veg': '',
      },
      'dinner': {
        'name': 'Dinner',
        'icon': 'dinner_dining',
        'start_time': '19:45',
        'end_time': '22:30',
        'veg': [
          'Plain Rice',
          'Dal',
          'Sabzi',
          'Roti',
          'Curd',
          'Salad',
          'Pickle'
        ],
        'non_veg': [
          'Plain Rice',
          'Dal',
          'Sabzi',
          'Roti',
          'Curd',
          'Salad',
          'Pickle'
        ],
        'jain': [],
        'special_note_veg': '',
        'special_note_non_veg': '',
      },
    };
  }
}
