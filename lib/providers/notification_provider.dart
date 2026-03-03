import 'package:flutter/foundation.dart';
import '../data/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  bool _isEnabled = false;
  bool _isLoading = true; // Start as true to ensure we wait for initialization
  bool _hasAskedPermission = false;
  bool _isInitialized = false;

  NotificationProvider(this._notificationService);

  bool get isEnabled => _isEnabled;
  bool get isLoading => _isLoading;
  bool get hasAskedPermission => _hasAskedPermission;
  bool get isInitialized => _isInitialized;

  /// Initialize the provider and load saved state
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    // CRITICAL: Read SharedPreferences flags FIRST, independently of
    // notification service initialization. These only need SharedPreferences
    // and must not be gated behind the notification plugin init, which can
    // throw in Android release builds (AOT/timezone/platform channel issues).
    try {
      _hasAskedPermission = await _notificationService.hasAskedPermission();
      _isEnabled = await _notificationService.areNotificationsEnabled();
      debugPrint(
          '🔔 Prefs loaded - enabled: $_isEnabled, asked: $_hasAskedPermission');
    } catch (e) {
      debugPrint('❌ Error reading notification prefs: $e');
    }

    // Now initialize the notification plugin (may fail in release builds)
    try {
      await _notificationService.initialize();

      debugPrint('🔔 NotificationService initialized successfully');

      // Reschedule notifications if enabled
      if (_isEnabled) {
        await _notificationService.rescheduleIfNeeded();
      }
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
    }

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Mark that the permission dialog has been shown.
  /// Call this BEFORE showing the dialog to guarantee persistence.
  Future<void> markAskedPermission() async {
    try {
      await _notificationService.markPermissionAsked();
      _hasAskedPermission = true;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error marking permission asked: $e');
    }
  }

  /// Request permission and enable notifications if granted
  Future<bool> requestPermissionAndEnable() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationService.markPermissionAsked();
      _hasAskedPermission = true;

      final granted = await _notificationService.requestPermission();

      if (granted) {
        await _notificationService.enableNotifications();
        _isEnabled = true;

        // Show a welcome notification
        await _notificationService.showTestNotification();
      }

      _isLoading = false;
      notifyListeners();
      return granted;
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle notifications on/off
  Future<void> toggleNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isEnabled) {
        // Disable
        await _notificationService.disableNotifications();
        _isEnabled = false;
      } else {
        // Enable - request permission if not already granted
        final granted = await _notificationService.requestPermission();
        if (granted) {
          await _notificationService.enableNotifications();
          _isEnabled = true;
        }
      }
    } catch (e) {
      debugPrint('❌ Error toggling notifications: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Enable notifications (assumes permission already granted)
  Future<void> enableNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationService.enableNotifications();
      _isEnabled = true;
    } catch (e) {
      debugPrint('❌ Error enabling notifications: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Disable notifications and mark as asked (for skip/decline)
  Future<void> disableNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mark permission as asked so dialog won't show again
      await _notificationService.markPermissionAsked();
      _hasAskedPermission = true;

      await _notificationService.disableNotifications();
      _isEnabled = false;
    } catch (e) {
      debugPrint('❌ Error disabling notifications: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
