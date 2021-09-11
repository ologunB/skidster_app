import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class TermsServiceScreen extends StatefulWidget {
  @override
  _TermsServiceScreenState createState() => _TermsServiceScreenState();
}

class _TermsServiceScreenState extends State<TermsServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            children: [
              regularText(
                'Terms of Service',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 6.h),
              item1('Terms and Services'),
              item2('''
These terms and conditions (the “Terms and Conditions”) govern the use of https://skidster.ca (the “Site”). This Site is owned and operated by Mo. Ahmed. This Site is a app.

By using this Site, you indicate that you have read and understand these Terms and Conditions and agree to abide by them at all times.'''),
              item1('Intellectual Property'),
              item2('''
All content published and made available on our Site is the property of Mo. Ahmed and the Site’s creators. This includes, but is not limited to images, text, logos, documents, downloadable files and anything that contributes to the composition of our Site.
'''),
              item1('Limitation of Liability'),
              item2('''
Mo. Ahmed and our directors, officers, agents, employees, subsidiaries, and affiliates will not be liable for any actions, claims, losses, damages, liabilities and expenses including legal fees from your use of the Site.
'''),
              item1('Indemnity'),
              item2('''
Except where prohibited by law, by using this Site you indemnify and hold harmless Mo. Ahmed and our directors, officers, agents, employees, subsidiaries, and affiliates from any actions, claims, losses, damages, liabilities and expenses including legal fees arising out of your use of our Site or your violation of these Terms and Conditions.
'''),
              item1('Applicable Law'),
              item2('''These Terms and Conditions are governed by the laws of the Province of Ontario.
'''),
              item1('Severability'),
              item2('''
If at any time any of the provisions set forth in these Terms and Conditions are found to be inconsistent or invalid under applicable laws, those provisions will be deemed void and will be removed from these Terms and Conditions. All other provisions will not be affected by the removal and the rest of these Terms and Conditions will still be considered valid.
'''),
              item1('Changes'),
              item2('''
These Terms and Conditions may be amended from time to time in order to maintain compliance with the law and to reflect any changes to the way we operate our Site and the way we expect users to behave on our Site. We will notify users by email of changes to these Terms and Conditions or post a notice on our Site.
'''),
              item1('Contact Details'),
              item2('''
Please contact us if you have any questions or concerns. Our contact details are as follows:

(647) 450-3736
hello@skidster.ca
11 Four Seasons Pl, Suite 1000, M9B 6H7, Etobicoke, ON'''),
             SizedBox(height: 50.h)
            ]));
  }

  Widget item1(String a) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: regularText(
        a,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget item2(String a) {
    return regularText(
      a,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textGrey,
    );
  }
}
