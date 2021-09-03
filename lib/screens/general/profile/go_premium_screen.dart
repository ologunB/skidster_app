import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class GoPremiumScreen extends StatefulWidget {
  const GoPremiumScreen({Key key}) : super(key: key);

  @override
  _GoPremiumScreenState createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          margin: EdgeInsets.all(30.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.h)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              regularText(
                'Become a Premium',
                fontSize: 24.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: regularText(
                  'Get unlimited access to truckloads\nand truckers',
                  fontSize: 11.sp,
                  textAlign: TextAlign.center,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              Divider(
                height: 0,
                thickness: 1.h,
                color: AppColors.grey.withOpacity(.2),
              ),
              ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.h),
                      color: selectedIndex == index
                          ? AppColors.primaryColor
                          : Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          regularText(
                            '\$19',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == index
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          regularText(
                            ' / 1 Month',
                            fontSize: 15.sp,
                            color: selectedIndex == index
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 1.h,
                    color: AppColors.grey.withOpacity(.2),
                  );
                },
              ),
              Divider(
                height: 0,
                thickness: 1.h,
                color: AppColors.grey.withOpacity(.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                child: buttonWithBorder('Continue',
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    height: 45.h,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w400,
                    onTap: () {}),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: regularText(
                  'No, thanks',
                  fontSize: 17.sp,
                  textAlign: TextAlign.center,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
