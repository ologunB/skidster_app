import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/utils/show_alert_dialog.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/general/auth/login_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key key}) : super(key: key);

  @override
  _UserSignupScreenState createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder('Sign Up',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              busy: isLoading,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            autoValidate = true;
            setState(() {});
            if (formKey.currentState.validate()) {
              verifyNumber(context);
            }
          }),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          children: [
            regularText(
              'Create Account',
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 40.h),
            item('Name'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Name',
              validator: Utils.isValidName,
              obscureText: false,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: name,
            ),
            SizedBox(height: 16.h),
            item('Phone'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Enter Phone number',
              obscureText: false,
              maxLength: 15,
              validator: Utils.isValidName,
              textInputAction: TextInputAction.next,
              controller: phone,
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
              controller: email,
            ),
            SizedBox(height: 16.h),
            item('Password'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Enter password',
              validator: Utils.isValidPassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              controller: password,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget item(String a) {
    return regularText(
      a,
      fontSize: 13.sp,
      color: AppColors.primaryColor,
    );
  }

   bool autoValidate = false;
   GlobalKey<FormState> formKey = GlobalKey<FormState>();
   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   bool isLoading = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController code = TextEditingController();

  Future<void> verifyNumber(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone.text,
          timeout: Duration(minutes: 2),
          verificationCompleted: (PhoneAuthCredential _credential) async {
            code.text = _credential.smsCode;
            _firebaseAuth
                .signInWithCredential(_credential)
                .then((UserCredential result) {
              _firebaseAuth.signOut();
              signup(context);
              print(result.user.uid);
            }).catchError((e) {
              setState(() {
                isLoading = false;
              });
              showExceptionAlertDialog(
                  context: scaffoldKey.currentContext,
                  exception: e,
                  title: "Error");
            });
            print('automatically verified');
          },
          verificationFailed: (a) {
            setState(() {
              isLoading = false;
            });
            showExceptionAlertDialog(
                context: scaffoldKey.currentContext,
                exception: a.message,
                title: "Error");
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            setState(() {
              isLoading = false;
            });
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.h)),
                      title: regularText('Enter SMS Code',
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black),
                      content: CustomTextField(
                        hintText: 'Enter OTP',
                        obscureText: false,
                        maxLength: 6,
                        controller: code,
                        textAlign: TextAlign.center,
                        textInputType: TextInputType.number,
                      ),
                      actions: <Widget>[
                        InkWell(
                          onTap: () async {
                            if(code.text.length < 6){
                              showSnackBar(context, null, 'Enter complete OTP');
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            Navigator.pop(context);
                            String smsCode = code.text.trim();
                            PhoneAuthCredential _credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                            code.text = '';

                            _firebaseAuth
                                .signInWithCredential(_credential)
                                .then((UserCredential result) {
                              _firebaseAuth.signOut();
                              signup(context);
                              print(result.user.uid);
                            }).catchError((e) {
                              print(e);
                              setState(() {
                                isLoading = false;
                              });
                              showExceptionAlertDialog(
                                  context: scaffoldKey.currentContext,
                                  exception: e,
                                  title: "Error");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 16.h),
                            margin: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.grey),
                            child: regularText('DONE',
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ));
          },
          codeAutoRetrievalTimeout: (e) {
            setState(() {
              isLoading = false;
            });
            showExceptionAlertDialog(
                context: scaffoldKey.currentContext,
                exception: e,
                title: "Error");
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
    }
  }

  void signup(context) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((value) {
      User user = value.user;

      Logger().d(user.uid);
      if (user != null) {
        user.sendEmailVerification().then((verify) {
          Map<String, dynamic> mData = Map();
          mData.putIfAbsent("name", () => name.text);
          mData.putIfAbsent("phone", () => phone.text);
          mData.putIfAbsent("email", () => email.text);
          mData.putIfAbsent("type", () => "customer");
          mData.putIfAbsent("uid", () => user.uid);
          mData.putIfAbsent("plan", () => "free");
          mData.putIfAbsent(
              "updated_at", () => DateTime.now().millisecondsSinceEpoch);

          FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .set(mData)
              .then((value) {
            setState(() {
              isLoading = false;
            });
            showAlertDialog(
              context: context,
              title: 'Alert',
              content: "Verify your email in your inbox and login again!",
              defaultActionText: 'OKAY',
            );
            _firebaseAuth.signOut();

            routeToReplace(context, LoginLayout());
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            showExceptionAlertDialog(
                context: context, exception: e, title: "Error");
            return;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      return;
    });
  }
}
