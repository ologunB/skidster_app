import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
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
                'Contact Support',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
              CustomTextField(
                hintText: 'Enter Feedback...',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 6,
              ),
              SizedBox(height: 40.h),
              buttonWithBorder('Send feedback',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  height: 50.h,
                  onTap: () {})
            ]));
  }
}
