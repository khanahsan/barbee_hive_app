import 'dart:io';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';

class CustomResumeWidget extends StatefulWidget {
  final Function(File file)? onFileSelected;
  final String? initialFileName;

  const CustomResumeWidget({
    super.key,
    this.onFileSelected,
    this.initialFileName,
  });

  @override
  State<CustomResumeWidget> createState() => _CustomResumeWidgetState();
}

class _CustomResumeWidgetState extends State<CustomResumeWidget> {
  late ValueNotifier<String?> fileName;

  @override
  void initState() {
    super.initState();

    fileName = ValueNotifier(widget.initialFileName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _pickFile,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(13.r),
          dashPattern: const [6, 3],
          strokeWidth: 1.5,
          color: AppColors.color4C4C4C,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          alignment: Alignment.center,
          width: double.infinity,
          height: 60.h,
          decoration: BoxDecoration(
            color: AppColors.textFieldBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ValueListenableBuilder(
            valueListenable: fileName,
            builder: (_, value, __) {
              final displayText =
                  (value == null || value.isEmpty)
                      ? "Upload Resume/Certification"
                      : value;

              return CustomText(
                title: displayText,
                fontSize: 16,
                color: AppColors.color4C4C4C,
                textOverflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      File pickedFile = File(result.files.single.path!);

      // Update widget display
      fileName.value = pickedFile.path.split('/').last;

      // Send back the file
      if (widget.onFileSelected != null) {
        widget.onFileSelected!(pickedFile);
      }
    }
  }
}
