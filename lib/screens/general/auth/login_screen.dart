import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_alert_dialog.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/general/auth/select_signup_type.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'package:mms_app/core/models/login_response.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          children: [
            regularText(
              'Sign In',
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 50.h),
            item('Email'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Your Email',
              validator: Utils.validateEmail,
              obscureText: false,
              controller: email,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            item('Password'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Enter password',
              validator: Utils.isValidPassword,
              controller: password,
              textInputType: TextInputType.text,
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              suffixIcon: InkWell(
                  onTap: () {
                    obscureText = !obscureText;
                    setState(() {});
                  },
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  )),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.h)),
                                title: regularText('Enter Email address',
                                    fontSize: 14.sp,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black),
                                content: CustomTextField(
                                  hintText: 'Enter Email',
                                  controller: passEmail,
                                  textAlign: TextAlign.center,
                                  textInputType: TextInputType.emailAddress,
                                ),
                                actions: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10.h),
                                    child: InkWell(
                                      onTap: () async {
                                        if (passEmail.text.isEmpty) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                        forgotPassword(
                                            scaffoldKey.currentContext);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 16.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.grey),
                                        child: regularText('RESET',
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                    },
                    child: item('Forgot Password?')),
              ],
            ),
            SizedBox(height: 40.h),
            buttonWithBorder('Sign In',
                buttonColor: AppColors.primaryColor,
                fontSize: 17.sp,
                busy: isLoading,
                height: 50.h,
                textColor: AppColors.white,
                fontWeight: FontWeight.w600, onTap: () {
              autoValidate = true;
              setState(() {});
              if (formKey.currentState.validate()) {
                signIn();
              }
            })
          ],
        ),
      ),
    );
  }

  bool obscureText = true;

  Widget item(String a) {
    return regularText(
      a,
      fontSize: 13.sp,
      color: AppColors.primaryColor,
    );
  }

  bool isLoading = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController passEmail = TextEditingController();
  TextEditingController password = TextEditingController();

  Future signIn() async {
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((value) {
      User user = value.user;

      if (value.user != null) {
        if (!value.user.emailVerified) {
          setState(() {
            isLoading = false;
          });

          showAlertDialog(
            context: context,
            title: 'Alert',
            content: "Email not verified!",
            defaultActionText: 'OKAY',
          );

          _firebaseAuth.signOut();
          return;
        }
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get()
            .then((document) {
              if(document.exists){
                AppCache.setUser(document.data());

                UserData userData = UserData.fromJson(document.data());
                if (userData.type == 'customer') {
                  routeToReplace(context, UserMainLayout());
                } else {
                  routeToReplace(context, TruckerMainLayout());
                }
              }else{
                setState(() {
                  isLoading = false;
                });

                navigateTo(context, SelectUserType());
                showAlertDialog(
                  context: context,
                  title: 'Alert',
                  content: "Account does not exist, create an account",
                  defaultActionText: 'OKAY',
                );
                return;
              }

        }).catchError((e) {
          setState(() {
            isLoading = false;
          });

          showExceptionAlertDialog(
              context: context, exception: e, title: "Error");
          setState(() {
            isLoading = false;
          });
          return;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  Future forgotPassword(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _firebaseAuth.sendPasswordResetEmail(email: passEmail.text);
      setState(() {
        isLoading = false;
      });
      passEmail.clear();
      showAlertDialog(
        context: context,
        title: 'Alert',
        content: "Reset Email has been sent!",
        defaultActionText: 'OKAY',
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Error', e.message);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Error', e.message);
    }
  }
}
