import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with WidgetsBindingObserver {
  final AdService _adService = AdService();
  bool _isAdLoaded = false;
  bool _adFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App came back to foreground - try to load ad if failed
        _adService.onAppResumed();
        if (_adFailed && !_isAdLoaded) {
          _loadAd();
        }
        break;
      case AppLifecycleState.paused:
        _adService.onAppPaused();
        break;
      default:
        break;
    }
  }

  void _loadAd() {
    _adService.loadBannerAd(
      onAdLoaded: () {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
            _adFailed = false;
          });
        }
      },
      onAdFailed: (error) {
        debugPrint('Ad failed: $error');
        if (mounted) {
          setState(() {
            _isAdLoaded = false;
            _adFailed = true;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _adService.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If ad failed to load or hasn't loaded yet, don't show anything
    if (_adFailed || !_isAdLoaded || _adService.bannerAd == null) {
      return const SizedBox.shrink();
    }

    // Only show the AdWidget without any wrapper Container to avoid gray backgrounds
    return SizedBox(
      width: _adService.bannerAd!.size.width.toDouble(),
      height: _adService.bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _adService.bannerAd!),
    );
  }
}
