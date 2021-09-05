import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/auth/login_screen.dart';
import 'package:mms_app/screens/general/auth/signup_layout.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class LoginLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCache.haveFirstView();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50.h),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Image.asset(
                  'images/logo-bg.png',
                  color: AppColors.primaryColor,
                  height: 170.h,
                  width: 170.h,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  regularText(
                    'Sign In',
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 12.h),
                  regularText(
                    'Sign in by email or continue with google',
                    fontSize: 17.sp,
                    color: AppColors.primaryColor,
                  ),
                  Spacer(),
                  buttonWithBorder('Continue with Mail',
                      borderColor: AppColors.primaryColor,
                      buttonColor: AppColors.white,
                      textColor: AppColors.primaryColor,
                      fontSize: 17.sp,
                      height: 50.h,
                      fontWeight: FontWeight.w600, onTap: () {
                    navigateTo(context, LoginScreen());
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: regularText(
                          'OR',
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textGrey.withOpacity(.8),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffF82A2A),
                        borderRadius: BorderRadius.circular(8.h),
                        border: Border.all(color: Color(0xffF82A2A))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/google.png',
                            height: 20.h, width: 20.h),
                        SizedBox(width: 10.h),
                        regularText(
                          'Continue with Google',
                          fontSize: 17.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Don’t have an account? ',
                          style: GoogleFonts.inter(
                            color: AppColors.textGrey,
                            fontSize: 17.sp,
                          ),
                          children: [
                            TextSpan(
                                text: 'Sign Up',
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navigateTo(context, SignupLayout());
                                  })
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
