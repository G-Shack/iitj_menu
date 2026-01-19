import 'package:flutter/foundation.dart';
import '../data/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  bool _isEnabled = false;
  bool _isLoading = false;
  bool _hasAskedPermission = false;

  NotificationProvider(this._notificationService);

  bool get isEnabled => _isEnabled;
  bool get isLoading => _isLoading;
  bool get hasAskedPermission => _hasAskedPermission;

  /// Initialize the provider and load saved state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _notificationService.initialize();
      _isEnabled = await _notificationService.areNotificationsEnabled();
      _hasAskedPermission = await _notificationService.hasAskedPermission();

      // Reschedule notifications if enabled (ensures we have upcoming week scheduled)
      if (_isEnabled) {
        await _notificationService.rescheduleIfNeeded();
      }
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
    }

    _isLoading = false;
    notifyListeners();
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
