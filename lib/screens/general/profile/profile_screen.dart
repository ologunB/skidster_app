import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/auth/login_layout.dart';
import 'package:mms_app/screens/general/profile/privacy_policy_screen.dart';
import 'package:mms_app/screens/general/profile/saved_loads.dart';
import 'package:mms_app/screens/general/profile/saved_profiles.dart';
import 'package:mms_app/screens/general/profile/support_screen.dart';
import 'package:mms_app/screens/general/profile/terms_service_screen.dart';
import 'package:mms_app/screens/general/profile/trucks_screen.dart';
import 'package:mms_app/screens/trucker/auth/upload_carierdocs_screen.dart';
import 'package:mms_app/screens/trucker/auth/upload_driverlicense_screen.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_profile_screen.dart';
import 'go_premium_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          children: [
            SizedBox(height: 30.h),
            Row(
              children: [
                regularText(
                  'My Account',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      height: 30.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.h)),
                      child: regularText(
                        'Free',
                        fontSize: 13.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, GoPremiumScreen());
                  },
                  child: regularText('Upgrade Plan',
                      fontSize: 13.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (AppCache.userType == UserType.TRUCKER)
              if (!hasLicense || !hasCarrierDoc)
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!hasLicense) {
                          navigateTo(context, UploadDriverLicenceScreen());
                        } else if (!hasCarrierDoc) {
                          navigateTo(context, UploadCareerDocumentScreen());
                        }
                      },
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        decoration: BoxDecoration(
                            color: Color(0xffFFEBA3),
                            borderRadius: BorderRadius.circular(10.h)),
                        child: regularText(
                          'Please verify your profile',
                          fontSize: 15.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
            ListView.separated(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data().length,
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 36.h),
                  child: Divider(
                    height: 0,
                    thickness: 1.h,
                    color: AppColors.grey.withOpacity(.2),
                  ),
                );
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    int lag = AppCache.userType == UserType.TRUCKER ? 1 : 2;
                    if (index == 8 - lag) {
                      Share.share('text', subject: 'Share App');
                      return;
                    }
                    if (index == 9 - lag) {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              regularText(
                                'Are you sure you want\nto logout?',
                                fontSize: 17.sp,
                                textAlign: TextAlign.center,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: buttonWithBorder(
                                      'YES',
                                      buttonColor: AppColors.primaryColor,
                                      fontSize: 17.sp,
                                      height: 40.h,
                                      textColor: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      onTap: () {
                                        AppCache.clear();
                                        GoogleSignIn().signOut();
                                        FirebaseAuth.instance.signOut();
                                        routeToReplace(context, LoginLayout());
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Expanded(
                                    child: buttonWithBorder(
                                      'NO',
                                      buttonColor: AppColors.white,
                                      fontSize: 17.sp,
                                      borderColor: AppColors.primaryColor,
                                      height: 40.h,
                                      textColor: AppColors.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                      return;
                    }
                    if (index == 7 - lag) {
                      launch(
                          'https://play.google.com/store/apps/details?id=com.autoserveng.autoserve&hl=en');
                      return;
                    }
                    navigateTo(context, gotos(data()[index])[index]);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    child: Row(
                      children: [
                        Image.asset(
                          images()[index],
                          height: 24.h,
                          width: 24.h,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 12.h),
                        regularText(
                          data()[index],
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.h,
                          color: AppColors.grey,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 36.h),
              child: Divider(
                height: 0,
                thickness: 1.h,
                color: AppColors.grey.withOpacity(.2),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> data() => [
        'Edit My Profile',
        if (AppCache.userType == UserType.TRUCKER) 'My Truck',
        'Terms of Service',
        'Privacy Policy',
        'Contact Support',
        if (AppCache.userType == UserType.USER) 'Saved Profiles',
        if (AppCache.userType == UserType.TRUCKER) 'Saved Loads',
        'Rate App',
        'Invite others',
        'Logout',
      ];

  List<Widget> gotos(String a) => [
        EditProfileScreen(),
        if (AppCache.userType == UserType.TRUCKER) MyTrucksScreen(),
        TermsServiceScreen(),
        PrivacyPolicyScreen(),
        SupportScreen(),
        if (AppCache.userType == UserType.USER) SavedProfilesScreen(),
        if (AppCache.userType == UserType.TRUCKER) SavedLoadsScreen(),
      ];

  List<String> images() => [
        'images/profile0.png',
        if (AppCache.userType == UserType.TRUCKER) 'images/profile1.png',
        'images/profile2.png',
        'images/profile3.png',
        'images/profile4.png',
        if (AppCache.userType == UserType.USER) 'images/profile5.png',
        if (AppCache.userType == UserType.TRUCKER) 'images/profile6.png',
        'images/profile7.png',
        'images/profile8.png',
        'images/profile9.png',
      ];
}
