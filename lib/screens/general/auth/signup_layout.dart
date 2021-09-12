import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/general/auth/select_signup_type.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class SignupLayout extends StatefulWidget {
  const SignupLayout({Key key}) : super(key: key);

  @override
  _SignupLayoutState createState() => _SignupLayoutState();
}

class _SignupLayoutState extends State<SignupLayout> {
  @override
  Widget build(BuildContext context) {
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
                    'Sign up',
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 12.h),
                  regularText(
                    'Sign up by email or continue with google',
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
                    navigateTo(context, SelectUserType());
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(9.h),
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
                  InkWell(
                    onTap: () {
                      signInWithGoogle(context);
                    },
                    child: Container(
                      height: 50.h,
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          color: Color(0xffF82A2A),
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(color: Color(0xffF82A2A))),
                      child: isLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              height: 20.h,
                              width: 20.h,
                            )
                          : Row(
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
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Have an account? ',
                          style: GoogleFonts.inter(
                            color: AppColors.textGrey,
                            fontSize: 17.sp,
                          ),
                          children: [
                            TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
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

  bool isLoading = false;

  Future signInWithGoogle(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential value =
              await _firebaseAuth.signInWithCredential(credential);

          if (value.user != null) {
            setState(() {
              isLoading = false;
            });
            navigateTo(context, SelectUserType());
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            showExceptionAlertDialog(
              context: context,
              exception: 'Account exist with different credential',
              title: "Error",
            );
          } else if (e.code == 'invalid-credential') {
            showExceptionAlertDialog(
              context: context,
              exception: 'Invalid credential',
              title: "Error",
            );
          }
        } catch (e) {
          showExceptionAlertDialog(
            context: context,
            exception: e,
            title: "Error",
          );
        }
      }
    } catch (e) {
      showExceptionAlertDialog(
        context: context,
        exception: e,
        title: "Error",
      );
    }
  }
}
