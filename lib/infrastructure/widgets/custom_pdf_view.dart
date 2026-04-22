import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomPdfView extends StatefulWidget {
  final String pdfUrl;
  final bool showBannerAd;

  const CustomPdfView({
    super.key,
    required this.pdfUrl,
    this.showBannerAd = false,
  });

  @override
  State<CustomPdfView> createState() => _CustomPdfViewState();
}

class _CustomPdfViewState extends State<CustomPdfView> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.showBannerAd) {
      AdsHelper().loadBannerAd(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad;
            _isBannerLoaded = true;
          });
        },
        onAdFailed: () {
          if (!mounted) return;
          setState(() {
            _isBannerLoaded = false;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color101010,
      appBar: AppBar(title: const Text('Resume'), centerTitle: true),
      body: Column(
        children: [
          Expanded(child: SfPdfViewer.network(widget.pdfUrl)),
          if (widget.showBannerAd && _isBannerLoaded && _bannerAd != null)
            SafeArea(
              top: false,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
