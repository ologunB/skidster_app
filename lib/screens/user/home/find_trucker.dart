import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class FIndTruckerWidget extends StatefulWidget {
  const FIndTruckerWidget({Key key}) : super(key: key);

  @override
  _FIndTruckerWidgetState createState() => _FIndTruckerWidgetState();
}

class _FIndTruckerWidgetState extends State<FIndTruckerWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
                  hintText: 'Find your trucker...',
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
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 12.h),
            InkWell(
              onTap: () {},
              highlightColor: AppColors.white,
              child:
                  Image.asset('images/filter.png', height: 50.h, width: 50.h),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.separated(
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Divider(
                  height: 0,
                  thickness: 1.h,
                  color: AppColors.grey.withOpacity(.2),
                ),
              );
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 3,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  //  routeTo(context, LoadsDetailsScreen());
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          regularText(
                            'Jack Bauer | Jack Logistic',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              regularText(
                                'Ontario, CA',
                                fontSize: 17.sp,
                                color: AppColors.primaryColor,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.h),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primaryColor,
                                  size: 16.h,
                                ),
                              ),
                              regularText(
                                'Ontario, CA',
                                fontSize: 17.sp,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 30.h,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                item1('100 Skids'),
                                item1('Truck Type'),
                                item1('3years experience'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/message_circle_icon.png',
                          height: 33.h,
                          width: 33.h,
                        ),
                        SizedBox(width: 6.h),
                        Image.asset(
                          'images/message_circle_icon.png',
                          height: 33.h,
                          width: 33.h,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

  Widget item1(String a) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
          decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(6.h)),
          child: regularText(
            a,
            fontSize: 11.sp,
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }
}
