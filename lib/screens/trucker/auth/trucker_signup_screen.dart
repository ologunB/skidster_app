import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:logger/logger.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_alert_dialog.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/general/auth/login_layout.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/user/home/get_address_view.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class TruckerSignupScreen extends StatefulWidget {
  const TruckerSignupScreen({Key key}) : super(key: key);

  @override
  _TruckerSignupScreenState createState() => _TruckerSignupScreenState();
}

class _TruckerSignupScreenState extends State<TruckerSignupScreen> {
  bool fromGoogle = false;

  String _uid, _email;

  @override
  void initState() {
    fromGoogle = FirebaseAuth.instance?.currentUser != null;
    if (fromGoogle) {
      _uid = FirebaseAuth.instance?.currentUser?.uid;
      _email = FirebaseAuth.instance?.currentUser?.email;
      name.text = FirebaseAuth.instance?.currentUser?.displayName ?? '';
    }
    super.initState();
  }

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
          child: buttonWithBorder('Next',
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
            SizedBox(height: 30.h),
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
            item('Company Name'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Your Company Name',
              validator: Utils.isValidName,
              obscureText: false,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: companyName,
            ),
            SizedBox(height: 16.h),
            item('Business Number(Optional)'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: '123...ABC ',
              obscureText: false,
              textInputType: TextInputType.text,
              controller: companyPhone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            item('Address'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Your Address',
              validator: Utils.isValidName,
              obscureText: false,
              controller: address,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              readOnly: true,
              onTap: () {
                navigateTo(
                    context,
                    GetAddressView(
                      title: 'Select Address',
                      selectPrediction: (a) {
                        addressData = a;
                        address.text = a.description;
                        setState(() {});
                      },
                    ));
              },
            ),
            SizedBox(height: 16.h),
            item('Phone Number'),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: 'Phone Number',
              validator: Utils.isValidName,
              obscureText: false,
              controller: phone,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            if (!fromGoogle)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  item('Email'),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: 'your@email.com',
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
                    controller: password,
                    validator: Utils.isValidPassword,
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
                  SizedBox(height: 16.h),
                ],
              ),
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

  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController phone = TextEditingController(text: '+1');
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController code = TextEditingController();
  Prediction addressData;

  double toLat, toLong;

  Future<void> verifyNumber(context) async {
    setState(() {
      isLoading = true;
    });

    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Utils.googleMapKey);

    PlacesDetailsResponse detail;
    try {
      detail = await _places.getDetailsByPlaceId(addressData.placeId);
      Logger().d(detail.result.geometry.location.lat);
      Logger().d(detail.result.geometry.location.lng);
      toLat = detail.result.geometry.location.lat;
      toLong = detail.result.geometry.location.lng;
    } catch (e) {
      print(e);
      showSnackBar(context, 'Error', e);
      isLoading = false;
      setState(() {});
      return;
    }

    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone.text,
          timeout: Duration(minutes: 2),
          verificationCompleted: (PhoneAuthCredential _credential) async {
            code.text = _credential.smsCode;
            Navigator.pop(context);
            _firebaseAuth
                .signInWithCredential(_credential)
                .then((UserCredential result) {
              if (result.additionalUserInfo.isNewUser) {
                _firebaseAuth.signOut();
                signup(scaffoldKey.currentContext);
                print(result.user.uid);
              } else {
                setState(() {
                  isLoading = false;
                });
                _firebaseAuth.signOut();
                showAlertDialog(
                  context: scaffoldKey.currentContext,
                  title: 'Error',
                  content: "Phone number has been used for another account",
                  defaultActionText: 'OKAY',
                );
                return;
              }
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
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
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
                      onChanged: (a) {
                        if (a.length == 6) {
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
                            if (result.additionalUserInfo.isNewUser) {
                              _firebaseAuth.signOut();
                              signup(scaffoldKey.currentContext);
                              print(result.user.uid);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              _firebaseAuth.signOut();
                              showAlertDialog(
                                context: scaffoldKey.currentContext,
                                title: 'Error',
                                content:
                                    "Phone number has been used for another account",
                                defaultActionText: 'OKAY',
                              );
                              return;
                            }
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
                        }
                      },
                    ),
                    actions: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.h),
                        child: InkWell(
                          onTap: () async {
                            if (code.text.length < 6) {
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
                              if (result.additionalUserInfo.isNewUser) {
                                _firebaseAuth.signOut();
                                signup(scaffoldKey.currentContext);
                                print(result.user.uid);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                _firebaseAuth.signOut();
                                showAlertDialog(
                                  context: scaffoldKey.currentContext,
                                  title: 'Error',
                                  content:
                                      "Phone number has been used for another account",
                                  defaultActionText: 'OKAY',
                                );
                                return;
                              }
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.grey),
                            child: regularText('DONE',
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: (e) {
            setState(() {
              isLoading = false;
            });
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
    }
  }

  void signup(buildContext) async {
    if (fromGoogle) {
      Map<String, dynamic> mData = Map();
      mData.putIfAbsent("name", () => name.text?.trim());
      mData.putIfAbsent("phone", () => phone.text?.trim());
      mData.putIfAbsent("email", () => _email);
      mData.putIfAbsent("status", () => 'active');
      mData.putIfAbsent("company_name", () => companyName.text?.trim());
      mData.putIfAbsent("company_phone", () => companyPhone.text?.trim());
      mData.putIfAbsent("company_address", () => address.text?.trim());
      mData.putIfAbsent("type", () => "trucker");
      mData.putIfAbsent("uid", () => _uid);
      mData.putIfAbsent('_geoloc', () => {'lat': toLat, 'lng': toLong});
      mData.putIfAbsent("plan", () => "free");
      mData.putIfAbsent(
          "updated_at", () => DateTime.now().millisecondsSinceEpoch);

      FirebaseFirestore.instance
          .collection("Users")
          .doc(_uid)
          .set(mData)
          .then((value) {
        AppCache.setUser(mData);
        routeToReplace(scaffoldKey.currentContext, TruckerMainLayout());
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        showExceptionAlertDialog(
            context: scaffoldKey.currentContext, exception: e, title: "Error");
        return;
      });
      return;
    } else {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        User user = value.user;

        Logger().d(user.uid);
        if (user != null) {
          user.sendEmailVerification().then((verify) {
            Map<String, dynamic> mData = Map();
            mData.putIfAbsent("name", () => name.text?.trim());
            mData.putIfAbsent("company_name", () => companyName.text?.trim());
            mData.putIfAbsent("company_phone", () => companyPhone.text?.trim());
            mData.putIfAbsent("company_address", () => address.text?.trim());
            mData.putIfAbsent("phone", () => phone.text?.trim());
            mData.putIfAbsent("email", () => email.text?.trim());
            mData.putIfAbsent("type", () => "trucker");
            mData.putIfAbsent("uid", () => user.uid);
            mData.putIfAbsent('_geoloc', () => {'lat': toLat, 'lng': toLong});
            mData.putIfAbsent("plan", () => "free");
            mData.putIfAbsent("status", () => 'active');
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

              routeToReplace(buildContext, LoginLayout());
            }).catchError((e) {
              setState(() {
                isLoading = false;
              });
              showExceptionAlertDialog(
                  context: buildContext, exception: e, title: "Error");
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
        showExceptionAlertDialog(
            context: buildContext, exception: e, title: "Error");
        return;
      });
    }
  }
}
