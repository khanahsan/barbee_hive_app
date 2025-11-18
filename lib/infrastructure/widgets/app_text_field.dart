/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';


class CustomTextField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final String? hintText;
  final Widget? prefixIcon;
  final String? defaultText;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController? controller;
  final Function? functionValidate;
  final String? parametersValidate;
  final TextInputAction? actionKeyboard;
  final int? maxLines;
  final Widget? suffixIcon;
  final Color? iconColor;
  final FormFieldValidator? validate;
  final int? maxlength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final String? label;
  final GestureTapCallback? onTap;
  final bool? readonly;
  final IconData? suffixicon;
  final IconData? suffixIcon2;
  final Color? fillColor;
  final bool? filled;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final TextCapitalization? textCapitalization;
  final Color? cursorColor;
  final Color? fontColor;
  final double? fontSize;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? hintColor;

  // final SpellCheckConfiguration? spellCheckConfiguration;

  const CustomTextField({
    this.hintText,
    this.focusNode,
    this.textInputType,
    this.defaultText,
    this.obscureText = false,
    this.controller,
    this.functionValidate,
    this.parametersValidate,
    this.actionKeyboard = TextInputAction.next,
    this.prefixIcon,
    this.iconColor,
    this.maxLines,
    this.suffixIcon,
    this.validate,
    this.inputFormatters,
    this.maxlength,
    this.maxLengthEnforcement,
    this.label,
    this.onTap,
    this.readonly,
    this.suffixicon,
    this.suffixIcon2,
    this.fillColor,
    this.filled,
    this.onChanged,
    this.prefix,
    this.textCapitalization,
    this.cursorColor,
    this.fontColor,
    this.fontSize,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.hintColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  double bottomPaddingToError = 8;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: themeData.copyWith(
            inputDecorationTheme: themeData.inputDecorationTheme.copyWith(
              prefixIconColor:
              WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.focused)) {
                  return Colors.blue;
                }
                if (states.contains(WidgetState.error)) {
                  return Colors.red;
                }
                return Colors.grey;
              }),
            )),
        child: TextFormField(
          autofocus: false,
          textCapitalization:
          widget.textCapitalization ?? TextCapitalization.none,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLength: widget.maxlength ,
          inputFormatters: widget.inputFormatters,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          validator: widget.validate,
          // spellCheckConfiguration: SpellCheckConfiguration(),
          maxLines: widget.obscureText ? 1 : widget.maxLines,  // Adjust maxLines based on obscureText
          cursorColor: widget.cursorColor ?? Colors.blue,
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          textInputAction: widget.actionKeyboard,
          focusNode: widget.focusNode,
          readOnly: widget.readonly ?? false,

          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: widget.fontColor,
            fontSize: widget.fontSize ?? 16.sp,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            labelText: widget.label,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintText,

            labelStyle: const TextStyle(color: Colors.black),
            fillColor: widget.fillColor ?? Colors.grey.shade100,
            filled: widget.filled,
            prefix: widget.prefix,
            errorMaxLines: 1,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //   borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? Colors.blue,
                  width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: widget.hintColor ?? widget.fontColor,
              fontSize: widget.fontSize ?? 16.sp,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: widget.controller,
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.isTapAble = true,
    this.focusNode,
    this.isObscuredText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.contentPadding,
    this.fillColor = AppColors.colorFFFFFF,
    this.filled = true,
    this.prefixIcon,
    this.prefixIconColor = Colors.grey,
    this.suffixIcon,
    this.suffixIconColor = Colors.grey,
    required this.hintText,
    this.prefixIconConstraints,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.maxLines = 1,
    this.readOnly = false,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.fontColor = AppColors.colorA3A3A3,
    this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.enabledBorderColor,
  });

  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool isTapAble, isObscuredText, filled, readOnly;
  final FocusNode? focusNode;
  final void Function(String)? onChanged, onFieldSubmitted;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets? contentPadding;
  final int maxLines;
  final Color fillColor, prefixIconColor, suffixIconColor;
  final Widget? prefixIcon, suffixIcon;
  final String hintText;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final BoxConstraints? prefixIconConstraints;
  final AutovalidateMode autoValidateMode;
  final Color? fontColor;
  final double? fontSize;
  final Color? enabledBorderColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: fontColor ?? AppColors.color4C4C4C,
      fontSize: fontSize?.sp ?? 16.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
    );

    final borderColor = enabledBorderColor ?? AppColors.textFieldBackground;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: true,
      focusNode: focusNode,
      obscureText: isObscuredText,
      maxLines: maxLines,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      autovalidateMode: autoValidateMode,
      autofillHints: autofillHints,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textInputAction: textInputAction,
      readOnly: readOnly,
      cursorColor: AppColors.colorFFFFFF,
      style: textStyle,

      // ✅ unified text style
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        // fillColor: isTapAble ? fillColor : Colors.grey,
        fillColor: fillColor,
        filled: filled,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        prefixIconConstraints: prefixIconConstraints,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
        hintText: hintText,
        hintStyle: textStyle,
        // ✅ same style
        labelStyle: textStyle,
        // ✅ same style
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
