import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';

void showSnackBar(BuildContext context, String title, String msg,
    {int duration = 6, Color color = Colors.grey}) {
  final Flushbar<void> flushBar = Flushbar<void>(
    title: title,
    message: msg,
    margin:   EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.h),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration),
    borderRadius: BorderRadius.circular(8.h),
    backgroundColor: title == 'Error' ? Colors.red : color,
  );

  if (!flushBar.isShowing()) {
    flushBar.show(context);
  }
}
