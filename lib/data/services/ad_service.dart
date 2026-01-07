import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  // TODO: Replace with your actual Ad Unit IDs from AdMob
  // These are TEST IDs - safe for development
  static String get bannerAdUnitId {
    if (kDebugMode) {
      // Test ad unit IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9214589741'; // Android test banner
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2435281174'; // iOS test banner
      }
    }
    // TODO: Replace with your production Ad Unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-6272394019031240/7506271065'; // Your Android banner ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6272394019031240/1514867349'; // Your iOS banner ID
    }
    return '';
  }

  bool get isBannerAdLoaded => _isBannerAdLoaded;
  BannerAd? get bannerAd => _bannerAd;

  /// Request App Tracking Transparency permission (iOS 14+)
  /// Must be called BEFORE initializing ads
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) return;

    try {
      // Check current status first
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('📢 ATT current status: $status');

      // Only request if not determined yet
      if (status == TrackingStatus.notDetermined) {
        // Small delay to ensure app is fully loaded (Apple requirement)
        await Future.delayed(const Duration(milliseconds: 500));

        // Request permission - this shows the iOS dialog
        final result =
            await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('📢 ATT permission result: $result');
      }
    } catch (e) {
      debugPrint('📢 ATT request error: $e');
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Request ATT permission BEFORE initializing ads (iOS requirement)
    await requestTrackingPermission();

    await MobileAds.instance.initialize();
    _isInitialized = true;
    debugPrint('📢 AdMob initialized');
  }

  void loadBannerAd({
    required Function() onAdLoaded,
    required Function(String error) onAdFailed,
  }) {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('📢 Banner ad loaded');
          _isBannerAdLoaded = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('📢 Banner ad failed to load: ${error.message}');
          ad.dispose();
          _isBannerAdLoaded = false;
          onAdFailed(error.message);
        },
        onAdOpened: (ad) => debugPrint('📢 Banner ad opened'),
        onAdClosed: (ad) => debugPrint('📢 Banner ad closed'),
      ),
    );

    _bannerAd!.load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }
}
