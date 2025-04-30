import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;

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
    this.enabledBorderColor,
    this.focusedBorderColor,
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

          style:
          TextStyle(color: widget.fontColor ?? Colors.black, fontSize: 14),
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
            hintStyle: TextStyle(
              color: widget.fontColor ?? Colors.grey,
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
}