import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/day_menu_model.dart';
import '../models/app_config_model.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  static const String _weeklyMenuKey = 'weekly_menu';
  static const String _menuVersionKey = 'menu_version';
  static const String _appConfigKey = 'app_config';

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        // For development: set to 0 to always fetch fresh values
        // Change back to Duration(hours: 1) for production!
        minimumFetchInterval: const Duration(hours: 1),
        // minimumFetchInterval: Duration.zero,
      ),
    );

    // Set default values
    await _remoteConfig.setDefaults({
      _weeklyMenuKey: _getDefaultMenu(),
      _menuVersionKey: '1.0.0',
      _appConfigKey: _getDefaultAppConfig(),
    });

    print(
        '🔥 Remote Config initialized with minimumFetchInterval: 0 (dev mode)');
  }

  Future<bool> fetchAndActivate() async {
    try {
      final result = await _remoteConfig.fetchAndActivate();
      print('🔥 Remote Config fetchAndActivate result: $result');
      print('🔥 Last fetch status: ${_remoteConfig.lastFetchStatus}');
      print('🔥 Last fetch time: ${_remoteConfig.lastFetchTime}');
      return result;
    } catch (e) {
      print('❌ Error fetching remote config: $e');
      return false;
    }
  }

  String get menuVersion => _remoteConfig.getString(_menuVersionKey);

  AppConfigModel getAppConfig() {
    try {
      final jsonString = _remoteConfig.getString(_appConfigKey);
      print('🔥 ===== APP CONFIG DEBUG =====');
      print('🔥 Raw app_config JSON: $jsonString');
      print('🔥 JSON length: ${jsonString.length}');
      final configData = json.decode(jsonString) as Map<String, dynamic>;
      print(
          '🔥 Parsed show_options_screen: ${configData['show_options_screen']}');
      print(
          '🔥 Parsed events count: ${(configData['events'] as List?)?.length ?? 0}');
      print('🔥 =============================');
      return AppConfigModel.fromJson(configData);
    } catch (e) {
      print('❌ Error parsing app config: $e');
      return const AppConfigModel();
    }
  }

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

  String _getDefaultAppConfig() {
    return json.encode({
      'show_options_screen': true,
      'more_screen_message': 'No updates currently',
      'timetable_message': 'Coming Soon',
      'events': [
        {
          'name': 'Tech Fest 2025',
          'venue': 'Lecture Hall Complex',
          'time': 'Dec 15, 2025 - 10:00 AM',
          'status': 'upcoming'
        },
        {
          'name': 'Cultural Night',
          'venue': 'Central Auditorium',
          'time': 'Dec 20, 2025 - 6:00 PM',
          'status': 'upcoming'
        },
        {
          'name': 'Hackathon 2024',
          'venue': 'Computer Center',
          'time': 'Nov 10, 2024 - 9:00 AM',
          'status': 'completed'
        },
        {
          'name': 'Sports Meet',
          'venue': 'Stadium',
          'time': 'Nov 25, 2024 - 8:00 AM',
          'status': 'cancelled'
        }
      ],
    });
  }
}
