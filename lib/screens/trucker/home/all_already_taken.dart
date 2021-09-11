import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/user/loads/loads_info_screen.dart';
import 'package:mms_app/screens/user/loads/loads_status_screen.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class AllAlreadyTaken extends StatefulWidget {
  final String type;

  const AllAlreadyTaken({Key key, this.type}) : super(key: key);

  @override
  _AllAlreadyTakenState createState() => _AllAlreadyTakenState();
}

class _AllAlreadyTakenState extends State<AllAlreadyTaken> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;

  int progressLength = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppNotificationsWidget(),
            ],
          ),
          SizedBox(width: 30.h),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
              child: regularText(
                widget.type == 'Completed'
                    ? 'Completed Loads'
                    : widget.type == 'Recent'
                        ? 'Recently Added Loads'
                        : 'In-Progress Loads',
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: widget.type == 'Recent'
                    ? _firestore
                        .collection('All-Loaders')
                        .orderBy('updated_at', descending: true)
                        .snapshots()
                    : _firestore
                        .collection('Loaders')
                        .doc(widget.type)
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
                        ? Container(
                            height: SizeConfig.screenHeight / 3,
                            alignment: Alignment.center,
                            child: regularText(
                              'Load tray is Empty',
                              fontSize: 14.sp,
                              color: AppColors.grey,
                            ),
                          )
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
                                            isTruck: AppCache.userType ==
                                                UserType.TRUCKER,
                                          ));
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
                                              regularText(
                                                model.title,
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
                                              Row(
                                                children: [
                                                  if (model.weight.isNotEmpty)
                                                    item1(model.weight),
                                                  item1('\$${model.price}'),
                                                  item1('${model.skids} Skids'),
                                                  Spacer(),
                                                  if (model.isBooked ?? false)
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
                                                                  .circular(
                                                                      6.h)),
                                                      child: regularText(
                                                        widget.type ==
                                                                'Completed'
                                                            ? 'Completed'
                                                            : 'Booked',
                                                        fontSize: 11.sp,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
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
