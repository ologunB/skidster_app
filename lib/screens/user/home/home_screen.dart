import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/user/home/post_load_widget.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import 'find_trucker.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool isPostLoad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          children: [
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              children: [
                Row(
                  children: [
                    regularText(
                      'Welcome John',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    Spacer(),
                    AppNotificationsWidget()
                  ],
                ),
                regularText(
                  'What would you like to do?',
                  fontSize: 17.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        isPostLoad = true;
                        setState(() {});
                      },
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 12.h),
                        decoration: BoxDecoration(
                            color:
                                isPostLoad ? Color(0xffCDD3EA) : Colors.white,
                            borderRadius: BorderRadius.circular(10.h)),
                        child: regularText(
                          'Post Load',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isPostLoad
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        isPostLoad = false;
                        setState(() {});
                      },
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 12.h),
                        decoration: BoxDecoration(
                            color:
                                !isPostLoad ? Color(0xffCDD3EA) : Colors.white,
                            borderRadius: BorderRadius.circular(10.h)),
                        child: regularText(
                          'Find Trucker',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: !isPostLoad
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.h),
                      topRight: Radius.circular(20.h)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -15),
                        blurRadius: 20,
                        spreadRadius: 1,
                        color: AppColors.grey.withOpacity(.2))
                  ]),
              child: isPostLoad ? PostLoadWidget() : FindTruckerWidget(),
            )
          ],
        ),
      ),
    );
  }
}
