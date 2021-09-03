import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class FinderDetails extends StatefulWidget {
  const FinderDetails({Key key}) : super(key: key);

  @override
  _FinderDetailsState createState() => _FinderDetailsState();
}

class _FinderDetailsState extends State<FinderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications,
                size: 24.h,
                color: AppColors.white,
              )
            ],
          ),
          SizedBox(width: 12.h)
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 10.h),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buttonWithBorder('Call',
                  borderColor: AppColors.primaryColor,
                  buttonColor: AppColors.primaryColor,
                  textColor: AppColors.white,
                  fontSize: 17.sp,
                  height: 50.h,
                  fontWeight: FontWeight.w600,
                  onTap: () {}),
              SizedBox(height: 8.h),
              buttonWithBorder('Message',
                  borderColor: AppColors.primaryColor,
                  buttonColor: AppColors.white,
                  textColor: AppColors.primaryColor,
                  fontSize: 17.sp,
                  height: 50.h,
                  fontWeight: FontWeight.w600,
                  onTap: () {}),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.h),
                child: Image.asset(
                  'images/placeholder.png',
                  width: 100.h,
                  height: 100.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          regularText(
            'Jack Bauer | Jack Logistic',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          SizedBox(height: 12.h),
          regularText(
            'Ontario, CA',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: AppColors.white,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 24.h,
              ),
              SizedBox(width: 12.h),
              Icon(
                Icons.share,
                color: Colors.white,
                size: 24.h,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.h),
                  topRight: Radius.circular(16.h),
                ),
              ),
              child: Column(
                children: [
                  item('Truck Type', ': type'),
                  item('Skids Capacity', ': 100'),
                  item('Truck trips ', ': Lorem'),
                  item('Truck Driving Experience', ': 3 years'),
                  item('Truck Insurance', ': YES'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget item(String a, String b) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
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
