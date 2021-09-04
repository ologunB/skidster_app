import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class LoadsStatusScreen extends StatefulWidget {
  @override
  _LoadsStatusScreenState createState() => _LoadsStatusScreenState();
}

class _LoadsStatusScreenState extends State<LoadsStatusScreen> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder('I have booked the load',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            showDialog<AlertDialog>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    regularText(
                      'Are you sure you have\nbooked this load?',
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
                              Navigator.pop(context);
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
          }),
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 26.h),
          children: [
            Row(
              children: [
                regularText(
                  'Load Status',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.info_outline,
                    size: 24.h,
                    color: AppColors.grey,
                  ),
                )
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.grey.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.h)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 18.h,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 2.h,
                    color: AppColors.primaryColor,
                  )),
                  Container(
                      height: 30.h,
                      width: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color: AppColors.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/profile1.png',
                            height: 18.h,
                            width: 18.h,
                            color: AppColors.white,
                          )
                        ],
                      )),
                  Expanded(
                      child: Container(
                    height: 2.h,
                    color: AppColors.primaryColor,
                  )),
                  Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.check_circle_outline_outlined,
                      size: 18.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            regularText(
              'Booked by: Trucker',
              fontSize: 17.sp,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                regularText(
                  'Post ID',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                ),
                SizedBox(width: 10.h),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.info_outline,
                    size: 18.h,
                    color: AppColors.grey,
                  ),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                regularText(
                  'Load Info',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item2('Item', ': Washing Machine'),
                  item2('Weight', ': 5000 kg'),
                  item2('Skids', ': Skids'),
                  item2('Price', ': \$130'),
                  item2('Pickup Address', ': Mississauga'),
                  item2('DropOff Address', ': Ontario'),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget item1(String a) {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
      decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(6.h)),
      child: regularText(
        a,
        fontSize: 11.sp,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget item2(String a, String b) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: regularText(
              a,
              fontSize: 17.sp,
              color: AppColors.grey,
            ),
          ),
          Expanded(
            child: regularText(
              b,
              fontSize: 17.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
