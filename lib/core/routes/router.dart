import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/screens/general/auth/login_layout.dart';
import 'package:mms_app/screens/general/auth/login_screen.dart';
import 'package:mms_app/screens/general/onboarding_view.dart';
import 'package:mms_app/screens/general/auth/signup_layout.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';

const String OnboardingScreen = '/onboarding-view';
const String LoginView = '/login-view';
const String LayoutScreen = '/layout-view';
const String SignupLayoutScreen = '/signup-layout-view';
const String LoginLayoutScreen = '/login-layout-view';
const String ChangePasswordScreen = '/change-password';
const String ConfirmOTPScreen = '/confirm-otp';
const String UserMainView = '/user-main-view';
const String TruckerMainView = '/truck-main-view';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: OnboardingView(),
        args: settings.arguments,
      );
    case LoginLayoutScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: LoginLayout(),
        args: settings.arguments,
      );

    case SignupLayoutScreen:
      return _getPageRoute(
        routeName: settings.name,
        view: SignupLayout(),
        args: settings.arguments,
      );

    case LoginView:
      return _getPageRoute(
        routeName: settings.name,
        view: LoginScreen(),
        args: settings.arguments,
      );

    case UserMainView:
      return _getPageRoute(
        routeName: settings.name,
        view: UserMainLayout(),
        args: settings.arguments,
      );

    case TruckerMainView:
      return _getPageRoute(
        routeName: settings.name,
        view: TruckerMainLayout(),
        args: settings.arguments,
      );

    default:
      return CupertinoPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute<dynamic> _getPageRoute({String routeName, Widget view, Object args}) {
  return CupertinoPageRoute<dynamic>(
      settings: RouteSettings(name: routeName, arguments: args),
      builder: (_) => view);
}

void navigateTo(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.push<void>(
      context,
      CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) => view, fullscreenDialog: dialog));
}

void navigateReplacement(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.pushReplacement(
      context,
      CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) => view, fullscreenDialog: dialog));
}


void routeToReplace(BuildContext context, Widget view) {
  Navigator.pushAndRemoveUntil<void>(
      context,
      CupertinoPageRoute<dynamic>(builder: (BuildContext context) => view),
      (Route<void> route) => false);
}
