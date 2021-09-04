import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import '../trucker_main_layout.dart';

class UploadCareerDocumentScreen extends StatefulWidget {
  const UploadCareerDocumentScreen({Key key}) : super(key: key);

  @override
  _UploadCareerDocumentScreenState createState() =>
      _UploadCareerDocumentScreenState();
}

class _UploadCareerDocumentScreenState
    extends State<UploadCareerDocumentScreen> {
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
          child: buttonWithBorder('Do It Later',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            routeToReplace(context, TruckerMainLayout());
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Upload\nCarrier Document',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 30.h),
          Image.asset('images/upload2.png', width: 311.h),
          regularText('Upload File',
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
              textAlign: TextAlign.center,
              decoration: TextDecoration.underline),
        ],
      ),
    );
  }
}
