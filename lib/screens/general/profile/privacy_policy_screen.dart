import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
                'Privacy Policy',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 6.h),
              item1('Purpose'),
              item2('''
The purpose of this privacy policy (this “Privacy Policy”) is to inform users of our Site of the following:

> The personal data we will collect;
> Use of collected data;
> Who has access to the data collected;
> The rights of Site users; and
> The Site’s cookie policy.
This Privacy Policy applies in addition to the terms and conditions of our Site.
              '''),
              item1('Consent'),
              item2('''
By using our Site users agree that they consent to:

> The conditions set out in this Privacy Policy; and
> The collection, use, and retention of the data listed in this Privacy Policy.              
              '''),
              item1('How We Use Personal Data'),
              item2('''
Data collected on our Site will only be used for the purposes specified in this Privacy Policy or indicated on the relevant pages of our Site. We will not use your data beyond what we disclose in this Privacy Policy.
'''),
              item1('Who We Share Personal Data With'),
              item2('''
Employees

We may disclose user data to any member of our organization who reasonably needs access to user data to achieve the purposes set out in this Privacy Policy.

Other Disclosures
We will not sell or share your data with other third parties, except in the following cases:

> If the law requires it;
> If it is required for any legal proceeding;
> To prove or protect our legal rights; and
> To buyers or potential buyers of this company in the event that we seek to sell the company.
If you follow hyperlinks from our Site to another Site, please note that we are not responsible for and have no control over their privacy policies and practices.'''),
              item1('How Long We Store Personal Data'),
              item2('''
User data will be stored until the purpose the data was collected for has been achieved.

You will be notified if your data is kept for longer than this period.'''),
              item1('How We Protect Your Personal Data'),
              item2('''
In order to protect your security, we use the strongest available browser encryption and store all of our data on servers in secure facilities

While we take all reasonable precautions to ensure that user data is secure and that users are protected, there always remains the risk of harm. The Internet as a whole can be insecure at times and therefore we are unable to guarantee the security of user data beyond what is reasonably practical.'''),
              item1('Children'),
              item2('''
We do not knowingly collect or use personal data from children under 13 years of age. If we learn that we have collected personal data from a child under 13 years of age, the personal data will be deleted as soon as possible. If a child under 13 years of age has provided us with personal data their parent or guardian may contact our privacy officer.
'''),
              item1(
                  'How to Access, Modify, Delete, or Challenge the Data Collected'),
              item2('''
If you would like to know if we have collected your personal data, how we have used your personal data, if we have disclosed your personal data and to who we disclosed your personal data, or if you would like your data to be deleted or modified in any way, please contact our privacy officer here:

Mohammed Ahmed
skidsterapp@gmail.com
(647) 450-3736
11 Four Seasons Pl, Suite 1000, M9B 6H7, Etobicoke, ON'''),
              item1('Do Not Track Notice'),
              item2('''
Do Not Track (“DNT”) is a privacy preference that you can set in certain web browsers. We do not track the users of our Site over time and across third party websites and therefore do not respond to browser-initiated DNT signals.
'''),
              item1('Cookie Policy'),
              item2('''
A cookie is a small file, stored on a user’s hard drive by a website. Its purpose is to collect data relating to the user’s browsing habits. You can choose to be notified each time a cookie is transmitted. You can also choose to disable cookies entirely in your internet browser, but this may decrease the quality of your user experience.

We do not use cookies on our Site.'''),
              item1('Modifications'),
              item2('''
This Privacy Policy may be amended from time to time in order to maintain compliance with the law and to reflect any changes to our data collection process. When we amend this Privacy Policy we will update the “Effective Date” at the top of this Privacy Policy. We recommend that our users periodically review our Privacy Policy to ensure that they are notified of any updates. If necessary, we may notify users by email of changes to this Privacy Policy.
'''),
              item1('Contact Information'),
              item2('''
If you have any questions, concerns or complaints, you can contact our privacy officer, Mohammed Ahmed, at:

skidsterapp@gmail.com
(647) 450-3736
10 Four Seasons Pl, Suite 1000, M9B 6H7, Etobicoke, ON

©2002-2021 LawDepot.ca®'''),
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
