import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/day_menu_model.dart';
import '../models/app_config_model.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  static const String _weeklyMenuKey = 'weekly_menu';
  static const String _menuVersionKey = 'menu_version';
  static const String _appConfigKey = 'app_config';

  bool _isInitialized = false;
  StreamSubscription<RemoteConfigUpdate>? _configSubscription;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    // Prevent multiple initializations
    if (_isInitialized) {
      print('🔥 Remote Config already initialized, skipping...');
      return;
    }

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        // Reduced timeout for better UX on slow networks
        fetchTimeout: const Duration(seconds: 10),
        // For production: use 1 hour interval
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Set default values
    await _remoteConfig.setDefaults({
      _weeklyMenuKey: _getDefaultMenu(),
      _menuVersionKey: '1.0.0',
      _appConfigKey: _getDefaultAppConfig(),
    });

    _isInitialized = true;
    print('🔥 Remote Config initialized');

    // Start listening for real-time updates
    _startRealTimeListener();
  }

  /// Listens for real-time Remote Config changes from the Firebase console.
  /// When a change is detected, it auto-activates and notifies all registered callbacks.
  void _startRealTimeListener() {
    _configSubscription?.cancel();
    _configSubscription = _remoteConfig.onConfigUpdated.listen(
      (RemoteConfigUpdate event) async {
        print(
            '🔥 Real-time config update received! Keys: ${event.updatedKeys}');
        try {
          // Activate the fetched values immediately
          await _remoteConfig.activate();
          print('🔥 Real-time config activated');

          // Notify all registered listeners
          for (final callback in _onUpdateCallbacks) {
            callback(event.updatedKeys);
          }
        } catch (e) {
          print('❌ Error activating real-time config: $e');
        }
      },
      onError: (Object error) {
        print('❌ Real-time config listener error: $error');
      },
    );
    print('🔥 Real-time config listener started');
  }

  // Callbacks registered by providers to react to real-time updates
  final List<void Function(Set<String> updatedKeys)> _onUpdateCallbacks = [];

  /// Register a callback to be invoked when Remote Config values change in real-time.
  void addOnUpdateListener(void Function(Set<String> updatedKeys) callback) {
    _onUpdateCallbacks.add(callback);
  }

  /// Remove a previously registered callback.
  void removeOnUpdateListener(void Function(Set<String> updatedKeys) callback) {
    _onUpdateCallbacks.remove(callback);
  }

  /// Clean up the real-time listener.
  void dispose() {
    _configSubscription?.cancel();
    _onUpdateCallbacks.clear();
  }

  Future<bool> fetchAndActivate() async {
    try {
      // Ensure initialized before fetching
      if (!_isInitialized) {
        await initialize();
      }

      final result = await _remoteConfig.fetchAndActivate();
      print('🔥 Remote Config fetchAndActivate result: $result');
      print('🔥 Last fetch status: ${_remoteConfig.lastFetchStatus}');
      print('🔥 Last fetch time: ${_remoteConfig.lastFetchTime}');

      // Check if we actually got data from server
      if (_remoteConfig.lastFetchStatus != RemoteConfigFetchStatus.success) {
        print('⚠️ Remote Config fetch was not successful');
      }

      return result;
    } catch (e) {
      print('❌ Error fetching remote config: $e');
      rethrow; // Rethrow to let providers handle the error
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
    // Return empty menu - don't show default data if remote config fails
    return json.encode({});
  }

  String _getDefaultAppConfig() {
    // Default config: skip hub screen and show empty data if remote config fails
    return json.encode({
      'show_options_screen': false,
      'more_screen_message': 'Unable to load data',
      'timetable_message': 'Unable to load data',
      'events': [],
    });
  }
}
