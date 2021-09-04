import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_alert_dialog.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              controller: email,
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
              obscureText: true,
              controller: password,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
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

  bool isLoading = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
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
          AppCache.setUser(document.data());

          UserData userData = UserData.fromJson(document.data());
          if (userData.type == 'customer') {
            routeToReplace(context, UserMainLayout());
          } else {
            routeToReplace(context, TruckerMainLayout());
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
}
