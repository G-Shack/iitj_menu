import 'package:flutter/foundation.dart';
import '../data/models/app_config_model.dart';
import '../data/services/remote_config_service.dart';

class AppConfigProvider extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService;

  AppConfigModel _config = const AppConfigModel();
  bool _isLoading = true;

  AppConfigProvider(this._remoteConfigService) {
    _remoteConfigService.addOnUpdateListener(_onRemoteConfigUpdated);
  }

  AppConfigModel get config => _config;
  bool get isLoading => _isLoading;
  bool get showOptionsScreen => _config.showOptionsScreen;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load config from current remote config values (may be defaults if no fetch yet)
      _config = _remoteConfigService.getAppConfig();
      print(
          '✅ AppConfigProvider loaded config: showOptionsScreen=${_config.showOptionsScreen}');
    } catch (e) {
      print('❌ Error loading app config: $e');
      // Keep default config on error
    }

    _isLoading = false;
    notifyListeners();

    // Trigger background fetch to get latest config (non-blocking)
    _fetchInBackground();
  }

  Future<void> _fetchInBackground() async {
    try {
      await _remoteConfigService.fetchAndActivate();
      final newConfig = _remoteConfigService.getAppConfig();
      if (newConfig != _config) {
        _config = newConfig;
        print('✅ AppConfigProvider updated from background fetch');
        notifyListeners();
      }
    } catch (e) {
      print('⚠️ Background config fetch failed: $e');
      // Silent fail - we already have defaults/cached config
    }
  }

  void _onRemoteConfigUpdated(Set<String> updatedKeys) {
    if (updatedKeys.contains('app_config')) {
      try {
        final newConfig = _remoteConfigService.getAppConfig();
        if (newConfig != _config) {
          _config = newConfig;
          notifyListeners();
          print('\u2705 AppConfig auto-updated from real-time Remote Config');
        }
      } catch (e) {
        print('\u274c Error applying real-time app config update: $e');
      }
    }
  }

  Future<void> refresh() async {
    try {
      await _remoteConfigService.fetchAndActivate();
      _config = _remoteConfigService.getAppConfig();
      notifyListeners();
    } catch (e) {
      print('Error refreshing app config: $e');
    }
  }

  @override
  void dispose() {
    _remoteConfigService.removeOnUpdateListener(_onRemoteConfigUpdated);
    super.dispose();
  }
}
