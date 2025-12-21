import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      return 'ca-app-pub-6272394019031240/XXXXXXXXXX'; // Your Android banner ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6272394019031240/1514867349'; // Your iOS banner ID
    }
    return '';
  }

  bool get isBannerAdLoaded => _isBannerAdLoaded;
  BannerAd? get bannerAd => _bannerAd;

  Future<void> initialize() async {
    if (_isInitialized) return;

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
