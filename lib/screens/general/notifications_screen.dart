import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/notification_model.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/user/loads/loads_status_notifi_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
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
  String uid = FirebaseAuth.instance.currentUser.uid;

  CollectionReference _firestore = FirebaseFirestore.instance
      .collection('Notifications')
      .doc('Added')
      .collection(AppCache.getUser.uid);

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
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              regularText(
                                'Are you sure you want\nto delete all notifications?',
                                fontSize: 17.sp,
                                textAlign: TextAlign.center,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: buttonWithBorder(
                                      'YES',
                                      buttonColor: AppColors.primaryColor,
                                      fontSize: 17.sp,
                                      height: 40.h,
                                      textColor: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      onTap: () {
                                        Navigator.pop(context);
                                        _firestore.get().then((value) {
                                          value.docs.forEach((element) {
                                            element.reference.delete();
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Expanded(
                                    child: buttonWithBorder(
                                      'NO',
                                      buttonColor: AppColors.white,
                                      fontSize: 17.sp,
                                      borderColor: AppColors.primaryColor,
                                      height: 40.h,
                                      textColor: AppColors.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    },
                    child: regularText('Delete All',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
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
                      _firestore.doc(model.id).update({'is_read': true});
                    });
                    return myLoads.isEmpty
                        ? Container(
                            height: SizeConfig.screenHeight / 3,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/empty.png',
                                  height: 100.h,
                                ),
                                regularText(
                                  'Notification tray is Empty',
                                  fontSize: 16.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              itemCount: myLoads.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        LoadsStatusNotifiScreen(
                                          isTruck: AppCache.userType ==
                                              UserType.TRUCKER,
                                          id: myLoads[index].loadId,
                                        ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            regularText(
                                              myLoads[index].person,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor,
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                _firestore
                                                    .doc(myLoads[index].id)
                                                    .delete();
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 18.h,
                                                color: AppColors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        regularText(
                                          myLoads[index].title,
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
