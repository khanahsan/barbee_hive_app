import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomPdfView extends StatelessWidget {
  final String pdfUrl;

  const CustomPdfView({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color101010,
      appBar: AppBar(title: const Text('Resume'), centerTitle: true),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
