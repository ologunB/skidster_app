import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/notifications_screen.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class AppNotificationsWidget extends StatelessWidget {
  const AppNotificationsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, NotificationsScreen());
      },
      child: Icon(
        Icons.notifications,
        size: 30.h,
        color: AppColors.primaryColor,
      ),
    );
  }
}
