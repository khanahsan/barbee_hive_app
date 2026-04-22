import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
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

  void showInterstitialAd({
    VoidCallback? onDismissed,
    VoidCallback? onFailedToShow,
  }) {
    if (_interstitialAd == null) {
      onFailedToShow?.call();
      loadInterstitialAd();
      return;
    }

    final ad = _interstitialAd!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (identical(_interstitialAd, ad)) {
          _interstitialAd = null;
        }
        loadInterstitialAd();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (identical(_interstitialAd, ad)) {
          _interstitialAd = null;
        }
        loadInterstitialAd();
        onFailedToShow?.call();
      },
    );

    _interstitialAd = null;
    ad.show();
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
