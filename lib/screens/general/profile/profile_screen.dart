import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/profile/saved_loads.dart';
import 'package:mms_app/screens/general/profile/saved_profiles.dart';
import 'package:mms_app/screens/general/profile/util_screen.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
          shrinkWrap: true,
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
                    routeTo(context, GoPremiumScreen());
                  },
                  child: regularText('Upgrade Plan',
                      fontSize: 13.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
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
              ],
            ),
            ListView.separated(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data().length,
              padding: EdgeInsets.symmetric(vertical: 10.h),
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
                    if (index == 8) {
                      Share.share('text', subject: 'Share App');
                      return;
                    }
                    if (index == 7) {
                      launch(
                          'https://play.google.com/store/apps/details?id=com.autoserveng.autoserve&hl=en');
                      return;
                    }
                    routeTo(context, gotos(data()[index])[index]);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/profile$index.png',
                          height: 24.h,
                          width: 24.h,
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
        'My Truck',
        'Terms of Service',
        'Privacy Policy',
        'Contact Support',
        'Saved Profiles',
        'Saved Loads',
        'Rate App',
        'Invite others',
        // 'Logout'
      ];

  List<Widget> gotos(String a) => [
        UtilScreen(title: a),
        UtilScreen(title: a),
        UtilScreen(title: a),
        UtilScreen(title: a),
        UtilScreen(title: a),
        SavedProfilesScreen(),
        SavedLoadsScreen(),
      ];
}
