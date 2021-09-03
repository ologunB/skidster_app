import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/trucker/auth/upload_driverlicense_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({Key key}) : super(key: key);

  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  int insured, ownTruck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder('Next',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            routeTo(context, UploadDriverLicenceScreen());
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Set up\nYour Profile',
            fontSize: 40.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 18.h),
          item('I own truck'),
          SizedBox(height: 8.h),
          Row(
            children: [
              item3(1, ownTruck),
              SizedBox(width: 15.h),
              item3(0, ownTruck),
            ],
          ),
          SizedBox(height: 16.h),
          item('Type of truck'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Choose type truck',
            readOnly: true,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryColor,
              size: 24.h,
            ),
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Skids capacity of truck'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Input skids capacity',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Driving experience'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Enter Driving experience',
            validator: Utils.isValidName,
            obscureText: false,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          item('Is your truck insured?'),
          SizedBox(height: 8.h),
          Row(
            children: [
              item2(1, insured),
              SizedBox(width: 15.h),
              item2(0, insured),
            ],
          ),
          SizedBox(height: 16.h),
          item('Travel Preference'),
          SizedBox(height: 8.h),
          CustomTextField(
            hintText: 'Choose Travel Preference',
            readOnly: true,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryColor,
              size: 24.h,
            ),
            obscureText: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget item(String a) {
    return regularText(
      a,
      fontSize: 11.sp,
      color: AppColors.primaryColor,
    );
  }

  Widget item2(int a, int type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          insured = a;
          setState(() {});
        },
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: a == type ? Color(0xffCDD3EA) : Colors.white,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: a != type ? AppColors.grey : Color(0xffCDD3EA),
                width: 1.h,
              )),
          child: regularText(
            a == 0 ? 'NO' : 'YES',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: a == type ? AppColors.black : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget item3(int a, int type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ownTruck = a;
          setState(() {});
        },
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: a == type ? Color(0xffCDD3EA) : Colors.white,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: a != type ? AppColors.grey : Color(0xffCDD3EA),
                width: 1.h,
              )),
          child: regularText(
            a == 0 ? 'NO' : 'YES',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: a == type ? AppColors.black : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
