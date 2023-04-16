import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTextFieldComponent extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? obsecureText;
  final String hintText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  const InputTextFieldComponent({
    Key? key,
    this.textEditingController,
    this.focusNode,
    this.suffixIcon,
    this.inputDecoration,
    this.textInputFormatter,
    this.textInputAction,
    this.onChanged,
    this.textInputType,
    required this.hintText,
    this.obsecureText,
    this.prefixIcon,
    this.hintStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      onChanged: onChanged,
      style: GoogleFonts.outfit(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
      ),
      inputFormatters: textInputFormatter,
      keyboardType: textInputType,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obsecureText ?? false,
      textInputAction: textInputAction,
    );
  }
}
