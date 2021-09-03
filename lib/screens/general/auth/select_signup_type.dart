import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/trucker/auth/trucker_signup_screen.dart';
import 'package:mms_app/screens/user/auth/user_signup_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({Key key}) : super(key: key);

  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      bottomNavigationBar: index == null
          ? null
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
              child: SafeArea(
                child: buttonWithBorder('Continue',
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    height: 50.h,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w600, onTap: () {
                  if (index == 1) {
                    routeTo(context, TruckerSignupScreen());
                  } else {
                    routeTo(context, UserSignupScreen());
                  }
                }),
              ),
            ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Choose\nAccount Type',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          regularText(
            'Please select one option below to\ncontinue with account creation',
            fontSize: 17.sp,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 100.h),
          item(0),
          item(1),
        ],
      ),
    );
  }

  Widget item(int i) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: InkWell(
        onTap: () {
          index = i;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                  width: 1.h,
                  color:
                      i != index ? AppColors.white : AppColors.primaryColor)),
          child: Row(
            children: [
              Icon(
                i != index ? Icons.adjust : Icons.radio_button_checked_outlined,
                size: 24.h,
                color: i != index
                    ? AppColors.primaryColor.withOpacity(.6)
                    : AppColors.primaryColor,
              ),
              SizedBox(width: 15.h),
              regularText(
                i == 0 ? 'Post Truck Loads' : 'Find Truck Loads',
                fontSize: 17.sp,
                fontWeight: i != index ? FontWeight.w400 : FontWeight.w700,
                color: i != index
                    ? AppColors.primaryColor.withOpacity(.6)
                    : AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
