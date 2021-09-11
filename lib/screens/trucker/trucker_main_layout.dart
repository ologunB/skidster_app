import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';

import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/message/messages_screen.dart';
import 'package:mms_app/screens/general/profile/profile_screen.dart';
import 'package:mms_app/screens/trucker/auth/set_profile_screen.dart';
import 'package:mms_app/screens/user/loads/loads_screen.dart';

import 'home/trucker_home_screen.dart';

class TruckerMainLayout extends StatefulWidget {
  const TruckerMainLayout({Key key}) : super(key: key);

  @override
  _TruckerMainLayoutState createState() => _TruckerMainLayoutState();
}

bool hasLicense = true;
bool hasCarrierDoc = true;

class _TruckerMainLayoutState extends State<TruckerMainLayout> {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    setState(() {});
  }

  List<Widget> views() => [
        TruckerHomeScreen(),
        LoadsScreen(isTruck: true),
        MessagesScreen(),
        ProfileScreen(),
      ];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = AppCache.getUser.uid;

  StreamSubscription trucksListner;

  @override
  void initState() {
    trucksListner = _firestore
        .collection('Truckers')
        .doc('Added')
        .collection(uid)
        .orderBy('updated_at')
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        navigateTo(context, SetupProfileScreen());
      } else {
        print('truck isnt empty');
      }
    });

    _firestore.collection('Users').doc(AppCache.getUser.uid).snapshots().listen((event) {
      Logger().d(event.data());
      UserData userData = UserData.fromJson(event.data());
      AppCache.setUser(event.data());
      if (userData.driverLicense == null) {
        hasLicense = false;
      }else{
        hasLicense = true;
      }
      if (userData.carrierDocs == null) {
        hasCarrierDoc = false;
      }else{
        hasCarrierDoc = true;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    trucksListner.cancel();
    super.dispose();
  }

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
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grey,
        currentIndex: currentIndex,
        selectedLabelStyle: GoogleFonts.mulish(
            fontSize: 11.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w400),
        unselectedLabelStyle: GoogleFonts.mulish(
            fontSize: 11.sp,
            color: AppColors.grey,
            fontWeight: FontWeight.w400),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Home',
              icon: ImageIcon(
                AssetImage('images/home.png'),
                color: AppColors.grey,
              ),
              activeIcon: ImageIcon(
                AssetImage('images/home.png'),
                color: AppColors.primaryColor,
              )),
          BottomNavigationBarItem(
              label: 'My Loads',
              icon: ImageIcon(
                AssetImage('images/loads.png'),
                color: AppColors.grey,
              ),
              activeIcon: ImageIcon(
                AssetImage('images/loads.png'),
                color: AppColors.primaryColor,
              )),
          BottomNavigationBarItem(
            label: 'Message',
            icon: ImageIcon(
              AssetImage('images/message.png'),
              color: AppColors.grey,
            ),
            activeIcon: ImageIcon(
              AssetImage('images/message.png'),
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: ImageIcon(
              AssetImage('images/person.png'),
              color: AppColors.grey,
            ),
            activeIcon: ImageIcon(
              AssetImage('images/person.png'),
              color: AppColors.primaryColor,
            ),
          ),
        ],
        onTap: changeIndex,
      ),
    );
  }
}
