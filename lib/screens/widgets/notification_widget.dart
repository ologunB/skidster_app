import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/notifications_screen.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';

class AppNotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          navigateTo(context, NotificationsScreen());
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(
              Icons.notifications,
              size: 30.h,
              color: AppColors.primaryColor,
            ),
            if (notificationCount > 0)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 14.h,
                  width: 14.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: regularText(
                    notificationCount.toString(),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ));
  }
}
