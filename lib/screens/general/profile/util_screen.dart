import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class UtilScreen extends StatefulWidget {
  const UtilScreen({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _UtilScreenState createState() => _UtilScreenState();
}

class _UtilScreenState extends State<UtilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            children: [
              regularText(
                widget.title,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
            ]));
  }
}
