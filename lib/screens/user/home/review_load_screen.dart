import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';

import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class ReviewLoadScreen extends StatefulWidget {
  const ReviewLoadScreen({Key key}) : super(key: key);

  @override
  _ReviewLoadScreenState createState() => _ReviewLoadScreenState();
}

class _ReviewLoadScreenState extends State<ReviewLoadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder('Submit',
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
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 24.h,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })),
                    regularText(
                      'Submitted',
                      fontSize: 18.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h)
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            );
          }),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                regularText(
                  'Review Post Load',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                Icon(
                  Icons.notifications,
                  size: 30.h,
                  color: AppColors.primaryColor,
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
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
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                  children: [
                    regularText(
                      'Review Post Load',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 9.h,
                          width: 9.h,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.h, color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10.h)),
                        ),
                        SizedBox(width: 10.h),
                        regularText(
                          'Mississauga',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          height: 9.h,
                          width: 9.h,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              border: Border.all(
                                  width: 1.h, color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10.h)),
                        ),
                        SizedBox(width: 10.h),
                        regularText(
                          'Anywhere',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Date & Time',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      'Monday, April 1 ',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    regularText(
                      '10.00 am',
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Item Name',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      'Washing Machine',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Skids',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '10 Skids',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Weight',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '1000KG',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Price',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '\$139',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
