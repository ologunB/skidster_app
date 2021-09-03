import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class SavedLoadsScreen extends StatefulWidget {
  const SavedLoadsScreen({Key key, this.isTruck = false}) : super(key: key);

  final bool isTruck;

  @override
  _SavedLoadsScreenState createState() => _SavedLoadsScreenState();
}

class _SavedLoadsScreenState extends State<SavedLoadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                children: [
                  regularText(
                    'Saved Loads',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),SizedBox(height: 15.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                shrinkWrap: true,
                itemCount: 2,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.grey.withOpacity(.3),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.h)),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.h, vertical: 6.h),
                          decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(.5),
                              borderRadius: BorderRadius.circular(6.h)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              regularText(
                                'APR',
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 6.h),
                              regularText(
                                '01',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 6.h),
                              regularText(
                                'MON',
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              regularText(
                                'Washing Machine',
                                fontSize: 13.sp,
                                color: AppColors.grey,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Container(
                                    height: 9.h,
                                    width: 9.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.h,
                                            color: AppColors.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10.h)),
                                  ),
                                  SizedBox(width: 10.h),
                                  regularText(
                                    'Mississauga',
                                    fontSize: 15.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 9.h,
                                    width: 9.h,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        border: Border.all(
                                            width: 1.h,
                                            color: AppColors.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10.h)),
                                  ),
                                  SizedBox(width: 10.h),
                                  regularText(
                                    'Anywhere',
                                    fontSize: 15.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  item1('5000kg'),
                                  item1('Lorem'),
                                  item1('10 Skids'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
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
