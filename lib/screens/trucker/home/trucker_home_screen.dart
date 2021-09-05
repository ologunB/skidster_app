import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/filter_screen.dart';
import 'package:mms_app/screens/user/loads/loads_details_screen.dart';
import 'package:mms_app/screens/user/loads/loads_status_screen.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class TruckerHomeScreen extends StatefulWidget {
  const TruckerHomeScreen({Key key}) : super(key: key);

  @override
  _TruckerHomeScreenState createState() => _TruckerHomeScreenState();
}

class _TruckerHomeScreenState extends State<TruckerHomeScreen> {
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
                          'Find Load',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isPostLoad
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
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(20.h),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            cursorHeight: 15.h,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              color: AppColors.primaryColor,
                              fontSize: 17.sp,
                              letterSpacing: 0.4,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.all(15.h),
                              hintText: 'Find your Load...',
                              hintStyle: GoogleFonts.inter(
                                color: AppColors.textGrey,
                                fontSize: 17.sp,
                              ),
                              fillColor: AppColors.grey.withOpacity(.2),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(width: 12.h),
                        InkWell(
                          onTap: () {
                            navigateTo(context, FilterScreen());
                          },
                          highlightColor: AppColors.white,
                          child: Image.asset('images/filter.png',
                              height: 50.h, width: 50.h),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    regularText(
                      'Recently Added Loads',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      height: 150.h,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.h, vertical: 5.h),
                        shrinkWrap: true,
                        itemCount: 2,
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              navigateTo(
                                  context, LoadsDetailsScreen(isTruck: true));
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.h, vertical: 10.h),
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
                                        borderRadius:
                                            BorderRadius.circular(6.h)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    color:
                                                        AppColors.primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.h)),
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
                                                    color:
                                                        AppColors.primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.h)),
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
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.h),
                    regularText(
                      'My Loads',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.h)),
                          child: regularText(
                            'In Progress',
                            fontSize: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    InkWell(
                      onTap: () {
                        navigateTo(context, LoadsStatusScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.h),
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
                            regularText(
                              'Refrigerator',
                              fontSize: 15.sp,
                              color: AppColors.primaryColor,
                            ),
                            Row(
                              children: [
                                regularText(
                                  'Citywhere > Knowhere',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                                Spacer(),
                                regularText(
                                  '30 Mar 2021',
                                  fontSize: 11.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10.h)),
                          child: regularText(
                            'Completed',
                            fontSize: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    InkWell(
                      onTap: () {
                        navigateTo(context, LoadsStatusScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.h),
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
                            regularText(
                              'Refrigerator',
                              fontSize: 15.sp,
                              color: AppColors.primaryColor,
                            ),
                            Row(
                              children: [
                                regularText(
                                  'Citywhere > Knowhere',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                                Spacer(),
                                regularText(
                                  'Completed',
                                  fontSize: 11.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ))
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
