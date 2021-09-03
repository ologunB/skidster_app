import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import '../user_main_layout.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key key}) : super(key: key);

  @override
  _UserSignupScreenState createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
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
          child: buttonWithBorder('Sign Up',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            routeTo(context, UserMainLayout());
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
          item('Email'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Your Email',
            validator: Utils.validateEmail,
            obscureText: false,
            textInputType: TextInputType.emailAddress,
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
