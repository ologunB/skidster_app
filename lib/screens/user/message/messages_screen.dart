import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/user/home/post_load_widget.dart';
import 'package:mms_app/screens/user/user_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import 'message_details.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.all(20.h),
              child: Row(
                children: [
                  regularText(
                    'Messages',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  Spacer(),
                  Icon(
                    Icons.notifications,
                    size: 30.h,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      routeTo(context, ChatDetailsView());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              regularText(
                                'Stones',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                              Spacer(),
                              regularText(
                                '10.00 am',
                                fontSize: 15.sp,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          regularText(
                            'How much for lorem ipsum dolor sit amet?',
                            fontSize: 17.sp,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Divider(
                      height: 0,
                      thickness: 1.h,
                      color: AppColors.grey.withOpacity(.2),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
