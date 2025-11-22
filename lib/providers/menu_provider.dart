import 'package:flutter/foundation.dart';
import '../data/models/day_menu_model.dart';
import '../data/models/meal_model.dart';
import '../data/services/remote_config_service.dart';
import '../data/services/cache_service.dart';

class MenuProvider extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService;
  final CacheService _cacheService;

  Map<String, DayMenu> _weeklyMenu = {};
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  MenuProvider(this._remoteConfigService, this._cacheService);

  Map<String, DayMenu> get weeklyMenu => _weeklyMenu;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;

  DayMenu? getDayMenu(int dayIndex) {
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    if (dayIndex < 0 || dayIndex >= days.length) return null;
    return _weeklyMenu[days[dayIndex]];
  }

  DayMenu? get todayMenu {
    final today = DateTime.now().weekday - 1;
    return getDayMenu(today);
  }

  Meal? get currentMeal {
    return todayMenu?.currentMeal;
  }

  Meal? get nextMeal {
    return todayMenu?.nextMeal;
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load from cache first
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null && _cacheService.isCacheValid()) {
        _weeklyMenu = cachedMenu;
        _lastUpdated = _cacheService.getLastUpdated();
        _isLoading = false;
        notifyListeners();

        // Fetch updates in background
        _fetchMenuInBackground();
        return;
      }

      // No valid cache, fetch from remote
      await fetchMenu();
    } catch (e) {
      _error = 'Failed to load menu: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _remoteConfigService.initialize();
      await _remoteConfigService.fetchAndActivate();

      _weeklyMenu = _remoteConfigService.getWeeklyMenu();
      _lastUpdated = DateTime.now();

      // Cache the menu
      await _cacheService.cacheMenu(
        _weeklyMenu,
        _remoteConfigService.menuVersion,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch menu: $e';
      _isLoading = false;
      notifyListeners();

      // Try to load from cache as fallback
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null) {
        _weeklyMenu = cachedMenu;
        _lastUpdated = _cacheService.getLastUpdated();
        notifyListeners();
      }
    }
  }

  Future<void> _fetchMenuInBackground() async {
    try {
      await _remoteConfigService.fetchAndActivate();
      final newMenu = _remoteConfigService.getWeeklyMenu();
      final newVersion = _remoteConfigService.menuVersion;
      final cachedVersion = _cacheService.getCachedVersion();

      // Only update if version changed
      if (newVersion != cachedVersion) {
        _weeklyMenu = newMenu;
        _lastUpdated = DateTime.now();
        await _cacheService.cacheMenu(newMenu, newVersion);
        notifyListeners();
      }
    } catch (e) {
      print('Background fetch failed: $e');
    }
  }

  Future<void> refresh() async {
    await fetchMenu();
  }
}
