import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/trucker/auth/upload_carierdocs_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class UploadDriverLicenceScreen extends StatefulWidget {
  const UploadDriverLicenceScreen({Key key}) : super(key: key);

  @override
  _UploadDriverLicenceScreenState createState() =>
      _UploadDriverLicenceScreenState();
}

class _UploadDriverLicenceScreenState extends State<UploadDriverLicenceScreen> {
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
            routeTo(context, UploadCareerDocumentScreen());
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Upload Your\nDriver License',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          regularText(
            'For security and safety reasons,\nwe require all truckers to verify their\nidentity',
            fontSize: 15.sp,
            color: AppColors.textGrey.withOpacity(.7),
          ),
          SizedBox(height: 30.h),
          Image.asset('images/upload1.png', width: 311.h),
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
