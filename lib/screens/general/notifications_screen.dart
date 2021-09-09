import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/notification_model.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                children: [
                  regularText(
                    'Notifications',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Notifications')
                    .doc('Added')
                    .collection(uid)
                    .orderBy('updated_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoader();
                  } else if (snapshot.hasError) {
                    ErrorOccurredWidget(error: snapshot.error);
                  } else if (snapshot.hasData) {
                    List<NotifiModel> myLoads = [];
                    snapshot.data.docs.forEach((element) {
                      NotifiModel model = NotifiModel.fromJson(element.data());
                      //  Logger().d(model.toJson());
                      myLoads.add(model);
                    });
                    return myLoads.isEmpty
                        ? Container(
                            height: SizeConfig.screenHeight / 3,
                            alignment: Alignment.center,
                            child: regularText(
                              'Notification tray is Empty',
                              fontSize: 16.sp,
                              color: AppColors.grey,
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              itemCount: myLoads.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      regularText(
                                        myLoads[index].person,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(height: 6.h),
                                      regularText(
                                        myLoads[index].title,
                                        fontSize: 17.sp,
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.h),
                                  child: Divider(
                                    height: 0,
                                    thickness: 1.h,
                                    color: AppColors.grey.withOpacity(.2),
                                  ),
                                );
                              },
                            ),
                          );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}
