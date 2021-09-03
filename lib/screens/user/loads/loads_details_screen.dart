import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class LoadsDetailsScreen extends StatefulWidget {
  const LoadsDetailsScreen({Key key, this.isTruck = false}) : super(key: key);

  final bool isTruck;

  @override
  _LoadsDetailsScreenState createState() => _LoadsDetailsScreenState();
}

class _LoadsDetailsScreenState extends State<LoadsDetailsScreen> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          children: [
            Row(
              children: [
                regularText(
                  'Load Info',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                AppNotificationsWidget()

              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                regularText(
                  'Post ID',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                ),
                Spacer(),
                if (widget.isTruck)
                  InkWell(
                    onTap: () {
                      favorite = !favorite;
                      setState(() {});
                    },
                    child: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      size: 30.h,
                      color: AppColors.primaryColor,
                    ),
                  )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.grey.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.h)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      regularText(
                        'Washing Machine',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                      Spacer(),
                      regularText(
                        'Mon, Apr 1',
                        fontSize: 15.sp,
                        color: AppColors.grey,
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
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.grey.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.h)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: regularText(
                          'Item',
                          fontSize: 17.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: regularText(
                          ': Washing Machine',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: regularText(
                          'Weight',
                          fontSize: 17.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: regularText(
                          ': 5000 kg',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: regularText(
                          'Skids',
                          fontSize: 17.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: regularText(
                          ': Skids',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: regularText(
                          'Price',
                          fontSize: 17.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: regularText(
                          ': \$130',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            !widget.isTruck
                ? Center(
                    child: regularText(
                      'Edit',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                            size: 24.h,
                          ),
                          SizedBox(width: 8.h),
                          regularText(
                            'Share',
                            fontSize: 17.sp,
                            color: AppColors.primaryColor,
                          ),
                          Spacer(),
                          regularText(
                            'Posted by :',
                            fontSize: 17.sp,
                            color: AppColors.grey,
                          ),
                          SizedBox(width: 8.h),
                          regularText(
                            'Jack',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Color(0xffFFEBA3),
                              borderRadius: BorderRadius.circular(10.h)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              regularText('Click here ',
                                  fontSize: 17.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600),
                              regularText(
                                'if you have booked this load',
                                fontSize: 17.sp,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          )),
                      SizedBox(height: 30.h),
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
                  )
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
}
