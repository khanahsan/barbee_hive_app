import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  static final AdsHelper _instance = AdsHelper._internal();

  factory AdsHelper() => _instance;

  AdsHelper._internal();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  int _profileViewCount = 0;

  /// ✅ Initialize SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// ✅ Banner Ad
  void loadBannerAd({
    required Function(BannerAd) onAdLoaded,
    required Function onAdFailed,
  }) {
    final bannerID = dotenv.env['BANNER_AD_UNIT_ID'];

    log('BANNER ID: $bannerID');

    _bannerAd = BannerAd(
      adUnitId: bannerID ?? '', // test banner
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(ad as BannerAd),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailed();
        },
      ),
    )..load();
  }

  BannerAd? get bannerAd => _bannerAd;

  /// ✅ Interstitial Ad
  void loadInterstitialAd() {
    final interstitialID = dotenv.env['INTERSTITIAL_AD_UNIT_ID'];

    log('Interstitial ID: $interstitialID');

    InterstitialAd.load(
      adUnitId: interstitialID ?? '', // test interstitial
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // prevent reuse
      loadInterstitialAd(); // preload next
    }
  }

  /// ✅ Profile view tracking
  void trackProfileView() {
    _profileViewCount++;
    if (_profileViewCount >= 6) {
      showInterstitialAd();
      _profileViewCount = 0;
    }
  }

  /// ✅ Dispose
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
