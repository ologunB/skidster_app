import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_alert_dialog.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/general/auth/login_screen.dart';
import 'package:mms_app/screens/general/auth/select_signup_type.dart';
import 'package:mms_app/screens/general/auth/signup_layout.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'dart:io';
class LoginLayout extends StatefulWidget {
  const LoginLayout({Key key}) : super(key: key);

  @override
  _LoginLayoutState createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AppCache.haveFirstView();
    return Scaffold(
      key: scaffoldKey,
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
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            signInWithGoogle(context);
                          },
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xffF82A2A),
                                borderRadius: BorderRadius.circular(8.h),
                                border: Border.all(color: Color(0xffF82A2A))),
                            child: googleIsLoading
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
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
                                       (Platform.isIOS)  ? 'Google': 'Continue with Google',
                                        fontSize: 17.sp,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                 if(Platform.isIOS)  SizedBox(width: 18.h),
    if(Platform.isIOS)        Expanded(
                        child: InkWell(
                          onTap: () {
                            signInWithApple(context);
                          },
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8.h),
                                border: Border.all(color: Colors.black)),
                            child: appleIsLoading
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                    height: 20.h,
                                    width: 20.h,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/apple.png',
                                        height: 20.h,
                                        width: 20.h,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10.h),
                                      regularText(
                                        'Apple',
                                        fontSize: 17.sp,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
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

  bool googleIsLoading = false;

  Future signInWithGoogle(BuildContext buildContext) async {
    setState(() {
      googleIsLoading = true;
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
            FirebaseFirestore.instance
                .collection('Users')
                .doc(value.user.uid)
                .get()
                .then((document) {
              if (!document.exists) {
                setState(() {
                  googleIsLoading = false;
                });

                navigateTo(buildContext, SelectUserType());
                showAlertDialog(
                  context: context,
                  title: 'Alert',
                  content: "Account does not exist, create an account",
                  defaultActionText: 'OKAY',
                );
                return;
              }
              AppCache.setUser(document.data());

              UserData userData = UserData.fromJson(document.data());
              if (userData.type == 'customer') {
                routeToReplace(buildContext, UserMainLayout());
              } else {
                routeToReplace(buildContext, TruckerMainLayout());
              }
            }).catchError((e) {
              setState(() {
                googleIsLoading = false;
              });

              showExceptionAlertDialog(
                  context: buildContext, exception: e, title: "Error");
              setState(() {
                googleIsLoading = false;
              });
              return;
            });
          } else {
            setState(() {
              googleIsLoading = false;
            });
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            googleIsLoading = false;
          });
          if (e.code == 'account-exists-with-different-credential') {
            showExceptionAlertDialog(
              context: buildContext,
              exception: 'Account exist with different credential',
              title: "Error",
            );
          } else if (e.code == 'invalid-credential') {
            showExceptionAlertDialog(
              context: buildContext,
              exception: 'Invalid credential',
              title: "Error",
            );
          }
        } catch (e) {
          setState(() {
            googleIsLoading = false;
          });
          showExceptionAlertDialog(
            context: buildContext,
            exception: e,
            title: "Error",
          );
        }
      }
    } catch (e) {
      setState(() {
        googleIsLoading = false;
      });
      showExceptionAlertDialog(
        context: buildContext,
        exception: e,
        title: "Error",
      );
    }
  }

  bool appleIsLoading = false;

  Future signInWithApple(BuildContext buildContext) {

  }
}
