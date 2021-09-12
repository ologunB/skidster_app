import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';

import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/notification_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/message/messages_screen.dart';
import 'package:mms_app/screens/general/profile/profile_screen.dart';
import 'package:mms_app/screens/widgets/notification_manager.dart';

import 'home/home_screen.dart';
import 'loads/loads_screen.dart';

class UserMainLayout extends StatefulWidget {
  const UserMainLayout({Key key}) : super(key: key);

  @override
  _UserMainLayoutState createState() => _UserMainLayoutState();
}

PageController userMainPageController = PageController();
int notificationCount = 0;

class _UserMainLayoutState extends State<UserMainLayout> {
  int currentIndex = 0;

  StreamSubscription adderStream, add2stream;

  CollectionReference _firestore = FirebaseFirestore.instance
      .collection('Notifications')
      .doc('Added')
      .collection(AppCache.getUser.uid);

  @override
  void initState() {
    userMainPageController = PageController();
    adderStream = _firestore.snapshots().listen((event) {
      notificationCount = 0;
      event.docs.forEach((element) {
        NotifiModel model = NotifiModel.fromJson(element.data());
        if (model?.isRead == false) {
          notificationCount++;
        }
        setState(() {});
      });
    });

    userMainPageController.addListener(() {
      currentIndex = userMainPageController.page.toInt();
      setState(() {});
    });

    getToken();
    things();
    super.initState();
  }

  Future<void> getToken() async {
    final String messagingToken = await NotificationManager.messagingToken();
    FirebaseDatabase.instance
        .reference()
        .child('fcm-tokens')
        .child(AppCache.getUser.uid)
        .set(<String, String>{'token': messagingToken});
  }

  Future<void> things() async {
    await Firebase.initializeApp();
    await FirebaseDatabase.instance.setPersistenceEnabled(true);
    await FirebaseDatabase.instance.setPersistenceCacheSizeBytes(100000000);
    await NotificationManager.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
    };
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  void dispose() {
    adderStream?.cancel();
    add2stream?.cancel();
    super.dispose();
  }

  void changeIndex(int index) {
    currentIndex = index;
    userMainPageController.jumpToPage(index);
    setState(() {});
  }

  List<Widget> views() => [
        UserHomeScreen(),
        LoadsScreen(isTruck: false),
        MessagesScreen(),
        ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: userMainPageController,
        children: views(),
      ),
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
