import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  BannerAd? _bannerAd;
  BannerAd? _preloadedBannerAd; // Pre-cached ad for instant display
  bool _isBannerAdLoaded = false;
  bool _isPreloadedAdReady = false;

  // Retry configuration
  int _retryCount = 0;
  static const int _maxRetries = 5;
  Timer? _retryTimer;

  // Auto-refresh configuration (minimum 60 seconds per AdMob policy)
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 75);

  // Network monitoring
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isNetworkAvailable = true;
  bool _pendingAdLoad = false;

  // Callbacks for current load request
  Function()? _onAdLoadedCallback;
  Function(String)? _onAdFailedCallback;

  // Track if ad is currently visible (for refresh logic)
  bool _isAdVisible = false;
  DateTime? _lastAdLoadTime;

  static String get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9214589741';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2435281174';
      }
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-6272394019031240/7506271065';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6272394019031240/1514867349';
    }
    return '';
  }

  bool get isBannerAdLoaded => _isBannerAdLoaded;
  BannerAd? get bannerAd => _bannerAd;

  /// Request App Tracking Transparency permission (iOS 14+)
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) return;

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('📢 ATT current status: $status');

      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 500));
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

    await requestTrackingPermission();
    await MobileAds.instance.initialize();

    // Configure ad request settings for better fill rate
    await _configureAdSettings();

    _isInitialized = true;
    debugPrint('📢 AdMob initialized');

    // Start monitoring network connectivity
    _startNetworkMonitoring();

    // Preload an ad immediately for faster display later
    _preloadBannerAd();
  }

  /// Configure mobile ads SDK for better performance
  Future<void> _configureAdSettings() async {
    // Set app volume (helps with video ads fill rate)
    await MobileAds.instance.setAppVolume(1.0);
    await MobileAds.instance.setAppMuted(false);

    debugPrint('📢 Ad settings configured');
  }

  /// Start monitoring network connectivity for smart ad loading
  void _startNetworkMonitoring() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasConnection =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      debugPrint(
          '📢 Network status: $hasConnection (was: $_isNetworkAvailable)');

      // Network just became available
      if (hasConnection && !_isNetworkAvailable) {
        _isNetworkAvailable = true;
        debugPrint('📢 Network restored - attempting ad loads');

        // Try to load pending ad
        if (_pendingAdLoad) {
          _pendingAdLoad = false;
          _attemptAdLoad();
        }

        // Also preload for future use
        if (!_isPreloadedAdReady) {
          _preloadBannerAd();
        }
      } else if (!hasConnection) {
        _isNetworkAvailable = false;
      }
    });

    // Check initial connectivity
    Connectivity().checkConnectivity().then((results) {
      _isNetworkAvailable =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });
  }

  /// Preload a banner ad in the background for instant display later
  void _preloadBannerAd() {
    if (_isPreloadedAdReady || _preloadedBannerAd != null) return;

    debugPrint('📢 Preloading banner ad...');

    _preloadedBannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: _createOptimizedAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('📢 Preloaded banner ad ready');
          _isPreloadedAdReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('📢 Preload failed: ${error.message}');
          ad.dispose();
          _preloadedBannerAd = null;
          _isPreloadedAdReady = false;

          // Retry preload after delay
          Future.delayed(const Duration(seconds: 30), () {
            if (!_isPreloadedAdReady) {
              _preloadBannerAd();
            }
          });
        },
      ),
    );

    _preloadedBannerAd!.load();
  }

  /// Create an optimized AdRequest for better fill rates
  AdRequest _createOptimizedAdRequest() {
    return const AdRequest(
      // Keywords help with ad targeting and can improve fill rates
      keywords: ['food', 'menu', 'college', 'campus', 'student', 'dining'],
      // Content URL helps with contextual targeting
      contentUrl: 'https://iitj.ac.in',
      // Non-personalized ads can have higher fill rates in some regions
      nonPersonalizedAds: false,
    );
  }

  /// Load banner ad with smart retry and caching
  void loadBannerAd({
    required Function() onAdLoaded,
    required Function(String error) onAdFailed,
  }) {
    _onAdLoadedCallback = onAdLoaded;
    _onAdFailedCallback = onAdFailed;
    _isAdVisible = true;

    // If we have a preloaded ad ready, use it immediately
    if (_isPreloadedAdReady && _preloadedBannerAd != null) {
      debugPrint('📢 Using preloaded ad for instant display');
      _bannerAd = _preloadedBannerAd;
      _preloadedBannerAd = null;
      _isPreloadedAdReady = false;
      _isBannerAdLoaded = true;
      _lastAdLoadTime = DateTime.now();
      onAdLoaded();

      // Start preloading next ad
      Future.delayed(const Duration(seconds: 5), () {
        _preloadBannerAd();
      });

      // Start auto-refresh timer
      _startRefreshTimer();
      return;
    }

    // Otherwise load a new ad
    _attemptAdLoad();
  }

  /// Internal method to attempt ad loading with retry logic
  void _attemptAdLoad() {
    // Cancel any existing retry timer
    _retryTimer?.cancel();

    // Check network availability
    if (!_isNetworkAvailable) {
      debugPrint('📢 No network - marking ad load as pending');
      _pendingAdLoad = true;
      return;
    }

    debugPrint(
        '📢 Loading banner ad (attempt ${_retryCount + 1}/$_maxRetries)');

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: _createOptimizedAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('📢 Banner ad loaded successfully');
          _isBannerAdLoaded = true;
          _retryCount = 0;
          _lastAdLoadTime = DateTime.now();
          _onAdLoadedCallback?.call();

          // Start auto-refresh timer
          _startRefreshTimer();

          // Preload next ad for future use
          Future.delayed(const Duration(seconds: 10), () {
            _preloadBannerAd();
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
              '📢 Banner ad failed: ${error.message} (code: ${error.code})');
          ad.dispose();
          _isBannerAdLoaded = false;
          _bannerAd = null;

          // Smart retry with exponential backoff
          if (_retryCount < _maxRetries && _isAdVisible) {
            _retryCount++;
            final delay = _getRetryDelay(_retryCount);
            debugPrint('📢 Will retry in ${delay.inSeconds}s');

            _retryTimer = Timer(delay, () {
              if (_isAdVisible) {
                _attemptAdLoad();
              }
            });
          } else {
            debugPrint('📢 Max retries reached or ad not visible');
            _retryCount = 0;
            _onAdFailedCallback?.call(error.message);
          }
        },
        onAdOpened: (ad) {
          debugPrint('📢 Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('📢 Banner ad closed');
        },
        onAdImpression: (ad) {
          debugPrint('📢 Banner ad impression recorded');
        },
        onAdClicked: (ad) {
          debugPrint('📢 Banner ad clicked');
        },
      ),
    );

    _bannerAd!.load();
  }

  /// Calculate retry delay with exponential backoff
  Duration _getRetryDelay(int attempt) {
    // Exponential backoff: 3s, 6s, 12s, 24s, 48s
    final seconds = 3 * (1 << (attempt - 1));
    // Cap at 60 seconds
    return Duration(seconds: seconds.clamp(3, 60));
  }

  /// Start auto-refresh timer for visible ads
  void _startRefreshTimer() {
    _refreshTimer?.cancel();

    if (!_isAdVisible) return;

    _refreshTimer = Timer(_refreshInterval, () {
      if (_isAdVisible && _isBannerAdLoaded) {
        debugPrint('📢 Auto-refreshing banner ad');
        _refreshBannerAd();
      }
    });
  }

  /// Refresh the currently displayed banner ad
  void _refreshBannerAd() {
    if (!_isAdVisible) return;

    // Check if minimum time has passed (AdMob requires 60+ seconds between refreshes)
    if (_lastAdLoadTime != null) {
      final timeSinceLastLoad = DateTime.now().difference(_lastAdLoadTime!);
      if (timeSinceLastLoad.inSeconds < 60) {
        debugPrint('📢 Skipping refresh - minimum interval not reached');
        _startRefreshTimer();
        return;
      }
    }

    // If we have a preloaded ad, swap it in
    if (_isPreloadedAdReady && _preloadedBannerAd != null) {
      debugPrint('📢 Swapping in preloaded ad for refresh');
      final oldAd = _bannerAd;

      _bannerAd = _preloadedBannerAd;
      _preloadedBannerAd = null;
      _isPreloadedAdReady = false;
      _lastAdLoadTime = DateTime.now();
      _onAdLoadedCallback?.call();

      // Dispose old ad after short delay to prevent flicker
      Future.delayed(const Duration(milliseconds: 100), () {
        oldAd?.dispose();
      });

      // Preload next ad
      Future.delayed(const Duration(seconds: 5), () {
        _preloadBannerAd();
      });

      _startRefreshTimer();
    } else {
      // Load a new ad
      _retryCount = 0;
      _attemptAdLoad();
    }
  }

  /// Call this when the app comes back to foreground
  void onAppResumed() {
    debugPrint('📢 App resumed - checking ad status');

    // If ad failed to load before, try again
    if (_isAdVisible && !_isBannerAdLoaded) {
      _retryCount = 0;
      _pendingAdLoad = false;
      _attemptAdLoad();
    }

    // Try to preload if needed
    if (!_isPreloadedAdReady) {
      _preloadBannerAd();
    }
  }

  /// Call this when app goes to background
  void onAppPaused() {
    debugPrint('📢 App paused - stopping timers');
    _refreshTimer?.cancel();
    _retryTimer?.cancel();
  }

  void disposeBannerAd() {
    _isAdVisible = false;
    _refreshTimer?.cancel();
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
    _onAdLoadedCallback = null;
    _onAdFailedCallback = null;
  }

  /// Dispose all resources
  void dispose() {
    disposeBannerAd();
    _preloadedBannerAd?.dispose();
    _preloadedBannerAd = null;
    _isPreloadedAdReady = false;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
