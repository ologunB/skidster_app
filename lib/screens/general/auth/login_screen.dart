import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            'Sign In',
            fontSize: 40.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 50.h),
          regularText(
            'Email',
            fontSize: 11.sp,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Your Email',
            validator: Utils.validateEmail,
            obscureText: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          regularText(
            'Password',
            fontSize: 11.sp,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Enter password',
            validator: Utils.isValidPassword,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 40.h),
          buttonWithBorder('Sign In',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            routeToReplace(context, UserMainLayout());
          })
        ],
      ),
    );
  }
}
