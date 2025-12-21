import 'package:flutter/foundation.dart';
import '../data/models/app_config_model.dart';
import '../data/services/remote_config_service.dart';

class AppConfigProvider extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService;

  AppConfigModel _config = const AppConfigModel();
  bool _isLoading = true;

  AppConfigProvider(this._remoteConfigService);

  AppConfigModel get config => _config;
  bool get isLoading => _isLoading;
  bool get showOptionsScreen => _config.showOptionsScreen;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Remote config should already be initialized in main.dart
      // Just get the config (no need to re-fetch)
      _config = _remoteConfigService.getAppConfig();
      print(
          '✅ AppConfigProvider loaded config: showOptionsScreen=${_config.showOptionsScreen}');
    } catch (e) {
      print('❌ Error loading app config: $e');
      // Keep default config on error
    }

    _isLoading = false;
    notifyListeners();
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
}
