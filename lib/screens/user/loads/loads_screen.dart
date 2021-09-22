import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/user/loads/loads_status_screen.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import 'loads_info_screen.dart';

class LoadsScreen extends StatefulWidget {
  const LoadsScreen({Key key, this.isTruck = false}) : super(key: key);

  final bool isTruck;

  @override
  _LoadsScreenState createState() => _LoadsScreenState();
}

class _LoadsScreenState extends State<LoadsScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = AppCache.getUser.uid;

  int progressLength = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                children: [
                  regularText(
                    'My Loads',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  Spacer(),
                  AppNotificationsWidget()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
              child: regularText(
                AppCache.userType == UserType.USER
                    ? 'Posted Loads'
                    : 'In-Progress Loads',
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Loaders')
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
                    List<LoadsModel> myLoads = [];
                    snapshot.data.docs.forEach((element) {
                      LoadsModel model = LoadsModel.fromJson(element.data());
                      //  Logger().d(model.toJson());
                      myLoads.add(model);
                    });
                    return myLoads.isEmpty
                        ? AppEmptyWidget(text: 'No Load in progress')
                        : ListView(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                shrinkWrap: true,
                                itemCount: (myLoads.length < 2)
                                    ? myLoads.length
                                    : progressLength,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  LoadsModel model = myLoads[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15.h),
                                    child: InkWell(
                                      onTap: () {
                                        if (model?.isBooked ?? false) {
                                          navigateTo(
                                              context,
                                              LoadsStatusScreen(
                                                loadsModel: model,
                                                isTruck: AppCache.userType ==
                                                    UserType.TRUCKER,
                                              ));
                                        } else {
                                          navigateTo(
                                              context,
                                              LoadsDetailsScreen(
                                                  loadsModel: model,
                                                  isTruck: widget.isTruck));
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14.h, vertical: 10.h),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.grey
                                                      .withOpacity(.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 10)
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 12.h),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.h,
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                  color: AppColors.grey
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.h)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  regularText(
                                                    DateFormat('MMM')
                                                        .format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                model.dateTime))
                                                        .toUpperCase(),
                                                    fontSize: 13.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  regularText(
                                                    DateFormat('dd').format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            model.dateTime)),
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  regularText(
                                                    DateFormat('EEE')
                                                        .format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                model.dateTime))
                                                        .toUpperCase(),
                                                    fontSize: 13.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  regularText(
                                                    model.title.toTitleCase(),
                                                    fontSize: 13.sp,
                                                    color: AppColors.grey,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 9.h,
                                                        width: 9.h,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1.h,
                                                                color: AppColors
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.h)),
                                                      ),
                                                      SizedBox(width: 10.h),
                                                      Expanded(
                                                        child: regularText(
                                                          model.pickup,
                                                          fontSize: 15.sp,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 9.h,
                                                        width: 9.h,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .primaryColor,
                                                            border: Border.all(
                                                                width: 1.h,
                                                                color: AppColors
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.h)),
                                                      ),
                                                      SizedBox(width: 10.h),
                                                      Expanded(
                                                        child: regularText(
                                                          model.dropoff,
                                                          fontSize: 15.sp,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        if (model
                                                            .weight.isNotEmpty)
                                                          item1(model.weight),
                                                        item1(
                                                            '\$50-\$${model.price}'),
                                                        item1(
                                                            '${model.skids} Skids'),
                                                        if (model.isBooked ??
                                                            false)
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 6.h),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.h,
                                                                    vertical:
                                                                        6.h),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.h)),
                                                            child: regularText(
                                                              'Booked',
                                                              fontSize: 11.sp,
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),

                                                        if (model.stage ==
                                                            20)
                                                          Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 6.h),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                10.h,
                                                                vertical:
                                                                6.h),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .red,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    6.h)),
                                                            child: regularText(
                                                              'BLOCKED',
                                                              fontSize: 11.sp,
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (myLoads.length > 2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        progressLength = myLoads.length;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.h, vertical: 4.h),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.h,
                                                color: AppColors.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(4.h)),
                                        child: regularText(
                                          'View More',
                                          fontSize: 12.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                  }
                  return Container();
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
              child: regularText(
                'Completed',
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Loaders')
                    .doc('Completed')
                    .collection(uid)
                    .orderBy('updated_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomLoader();
                  } else if (snapshot.hasError) {
                    ErrorOccurredWidget(error: snapshot.error);
                  } else if (snapshot.hasData) {
                    List<LoadsModel> myLoads = [];
                    snapshot.data.docs.forEach((element) {
                      LoadsModel model = LoadsModel.fromJson(element.data());
                      //  Logger().d(model.toJson());
                      myLoads.add(model);
                    });
                    return myLoads.isEmpty
                        ? AppEmptyWidget(text: 'No Completed Load')
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            shrinkWrap: true,
                            itemCount: myLoads.length,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              LoadsModel model = myLoads[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: InkWell(
                                  onTap: () {
                                    if (model?.isBooked ?? false) {
                                      navigateTo(
                                          context,
                                          LoadsStatusScreen(
                                            loadsModel: model,
                                            isTruck: AppCache.userType ==
                                                UserType.TRUCKER,
                                          ));
                                    } else {
                                      navigateTo(
                                          context,
                                          LoadsDetailsScreen(
                                              loadsModel: model,
                                              isTruck: widget.isTruck));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14.h, vertical: 10.h),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.grey
                                                  .withOpacity(.3),
                                              spreadRadius: 2,
                                              blurRadius: 10)
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.h)),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 12.h),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.h, vertical: 6.h),
                                          decoration: BoxDecoration(
                                              color: AppColors.grey
                                                  .withOpacity(.5),
                                              borderRadius:
                                                  BorderRadius.circular(6.h)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              regularText(
                                                DateFormat('MMM')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            model.dateTime))
                                                    .toUpperCase(),
                                                fontSize: 13.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                              SizedBox(height: 6.h),
                                              regularText(
                                                DateFormat('dd').format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        model.dateTime)),
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              ),
                                              SizedBox(height: 6.h),
                                              regularText(
                                                DateFormat('EEE')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            model.dateTime))
                                                    .toUpperCase(),
                                                fontSize: 13.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  regularText(
                                                    model.title.toTitleCase(),
                                                    fontSize: 13.sp,
                                                    color: AppColors.grey,
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 6.h),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.h,
                                                            vertical: 6.h),
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.h)),
                                                    child: regularText(
                                                      'Completed',
                                                      fontSize: 11.sp,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 9.h,
                                                    width: 9.h,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.h,
                                                            color: AppColors
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.h)),
                                                  ),
                                                  SizedBox(width: 10.h),
                                                  Expanded(
                                                    child: regularText(
                                                      model.pickup,
                                                      fontSize: 15.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 9.h,
                                                    width: 9.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryColor,
                                                        border: Border.all(
                                                            width: 1.h,
                                                            color: AppColors
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.h)),
                                                  ),
                                                  SizedBox(width: 10.h),
                                                  Expanded(
                                                    child: regularText(
                                                      model.dropoff,
                                                      fontSize: 15.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  if (model.weight.isNotEmpty)
                                                    item1('${model.weight}'),
                                                  item1(
                                                      '\$50-\$${model.price}'),
                                                  item1('${model.skids} Skids'),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  Widget item1(String a) {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
      decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(6.h)),
      child: regularText(
        a,
        fontSize: 11.sp,
        color: AppColors.primaryColor,
      ),
    );
  }
}
