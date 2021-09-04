import 'package:flutter/material.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/navigator.dart';

import '../../locator.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (AppCache.getUser == null) {
        if (AppCache.getIsFirst()) {
          locator<NavigationService>().pushReplace(OnboardingScreen);
        } else {
          locator<NavigationService>().pushReplace(LoginLayoutScreen);
        }
      } else {
        Future.delayed(Duration(seconds: 2), () {
          if (AppCache.getUser.type == 'customer') {
            locator<NavigationService>().pushReplace(UserMainView);
          } else {
            locator<NavigationService>().pushReplace(TruckerMainView);
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          'images/logo-bg.png',
          height: 250.h,
          width: 250.h,
        ),
      ),
    );
  }
}
