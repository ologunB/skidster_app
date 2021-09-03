import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';

import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class TruckerMainLayout extends StatefulWidget {
  const TruckerMainLayout({Key key}) : super(key: key);

  @override
  _TruckerMainLayoutState createState() => _TruckerMainLayoutState();
}

class _TruckerMainLayoutState extends State<TruckerMainLayout> {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    setState(() {});
  }

  List<Widget> views() => [Text('data')];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: views()[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 11.sp,
        unselectedFontSize: 11.sp,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.textGrey,
        currentIndex: currentIndex,
        selectedLabelStyle: GoogleFonts.mulish(
            fontSize: 11.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w400),
        unselectedLabelStyle: GoogleFonts.mulish(
            fontSize: 11.sp,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Home',
              icon: ImageIcon(
                AssetImage('assets/images/Home0.png'),
                color: AppColors.textGrey,
              ),
              activeIcon: ImageIcon(
                AssetImage('assets/images/Home1.png'),
              )),
          BottomNavigationBarItem(
            label: 'Requests',
            icon: ImageIcon(
              AssetImage('assets/images/Request0.png'),
              color: AppColors.textGrey,
            ),
            activeIcon: ImageIcon(
              AssetImage('assets/images/Request0.png'),
              color: AppColors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Messages',
            icon: ImageIcon(
              AssetImage('assets/images/Message0.png'),
              color: AppColors.textGrey,
            ),
            activeIcon: ImageIcon(
              AssetImage('assets/images/Message1.png'),
            ),
          ),
        ],
        onTap: changeIndex,
      ),
    );
  }
}
