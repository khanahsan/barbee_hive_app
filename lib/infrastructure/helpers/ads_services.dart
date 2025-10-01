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
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // test banner
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
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", // test interstitial
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
