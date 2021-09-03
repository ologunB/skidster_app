import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import 'text_widgets.dart';

Widget buttonWithBorder(
  String text, {
  Color buttonColor,
  Color textColor,
  Function onTap,
  Color borderColor,
  FontWeight fontWeight,
  double fontSize,
  double horiMargin,
  double borderRadius,
  double height,
  double width,
  bool busy = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: horiMargin ?? 0),
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 10.h),
          border: Border.all(color: borderColor ?? Colors.transparent)),
      child: Center(
        child: busy
            ? SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                height: 20.h,
                width: 20.h,
              )
            : regularText(
                text,
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
      ),
    ),
  );
}
