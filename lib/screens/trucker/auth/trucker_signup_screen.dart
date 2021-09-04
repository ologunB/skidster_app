import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/trucker/auth/set_profile_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class TruckerSignupScreen extends StatefulWidget {
  const TruckerSignupScreen({Key key}) : super(key: key);

  @override
  _TruckerSignupScreenState createState() => _TruckerSignupScreenState();
}

class _TruckerSignupScreenState extends State<TruckerSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder('Next',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            routeTo(context, SetupProfileScreen());
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Create Account',
            fontSize: 40.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 50.h),
          item('Name'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Name',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Company Name'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Your Company Name',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Business Number'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: '+12 890 ',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Address'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Your Address',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Email'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'your@email.com',
            validator: Utils.validateEmail,
            obscureText: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Phone Number'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Phone Number',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Password'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Enter password',
            validator: Utils.isValidPassword,
            obscureText: false,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget item(String a) {
    return regularText(
      a,
      fontSize: 11.sp,
      color: AppColors.primaryColor,
    );
  }
}
