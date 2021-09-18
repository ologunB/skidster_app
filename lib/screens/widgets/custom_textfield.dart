import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class CustomTextField extends StatelessWidget {
  final Widget prefixIcon;
  final Widget suffixIcon;
  final Function(String) validator;
  final Function(String) onSaved;
  final String hintText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final Function(String) onChanged;
  final Function() onTap;
  final TextEditingController controller;
  final int maxLines;
  final int maxLength;
  final bool readOnly;
  final bool obscureText;
  final bool autoFocus;
  final FocusNode focusNode;
  final String obscuringCharacter;

  CustomTextField({
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSaved,
    this.hintText,
    this.textInputAction,
    this.textInputType,
    this.textAlign,
    this.onChanged,
    this.controller,
    this.readOnly,
    this.obscureText = false,
    this.obscuringCharacter,
    this.maxLines = 1,
    this.onTap,
    this.autoFocus = false,
    this.focusNode, this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.black.withOpacity(0.4),
      cursorWidth: 1.w,
      focusNode: focusNode,
      cursorHeight: 15.h,
      autofocus: autoFocus,
      maxLines: maxLines,maxLength: maxLength,
      textInputAction: textInputAction,
      style: GoogleFonts.inter(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 17.sp,
        letterSpacing: 0.4,
      ),
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.all(15.h),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: AppColors.textGrey,
          fontSize: 17.sp,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 1.h),
          borderRadius: BorderRadius.circular(10.h),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 1.h),
          borderRadius: BorderRadius.circular(10.h),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 1.h),
          borderRadius: BorderRadius.circular(10.h),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 1.h),
          borderRadius: BorderRadius.circular(10.h),
        ),
      ),
      obscureText: obscureText,
      onTap: onTap,
      obscuringCharacter: '●',
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: textInputType,
      onFieldSubmitted: onSaved,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
