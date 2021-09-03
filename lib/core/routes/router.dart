import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/screens/general/login_layout.dart';
import 'package:mms_app/screens/general/login_screen.dart';
import 'package:mms_app/screens/general/onboarding_view.dart';
import 'package:mms_app/screens/general/signup_layout.dart';

const String OnboardingScreen = '/onboarding-view';
const String LoginView = '/login-view';
const String LayoutScreen = '/layout-view';
const String SignupLayoutScreen = '/signup-layout-view';
const String LoginLayoutScreen = '/login-layout-view';
const String ChangePasswordScreen = '/change-password';
const String ConfirmOTPScreen = '/confirm-otp';

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

void routeTo(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.push<void>(
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
