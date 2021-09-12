import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/finder_details.dart';
import 'package:mms_app/screens/general/message/message_details.dart';
import 'package:mms_app/screens/user/loads/loads_status_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_load_screen.dart';

class LoadsDetailsScreen extends StatefulWidget {
  const LoadsDetailsScreen({Key key, this.isTruck = false, this.loadsModel})
      : super(key: key);

  final bool isTruck;
  final LoadsModel loadsModel;

  @override
  _LoadsDetailsScreenState createState() => _LoadsDetailsScreenState();
}

class _LoadsDetailsScreenState extends State<LoadsDetailsScreen> {
  bool favorite = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _firestore
        .collection('Loaders')
        .doc('Saved')
        .collection(AppCache.getUser.uid)
        .doc(widget.loadsModel.id)
        .get()
        .then((value) {
      favorite = value.exists;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoadsModel loadsModel = widget.loadsModel;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          children: [
            Row(
              children: [
                regularText(
                  'Load Info',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                AppNotificationsWidget()
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                regularText(
                  'Post ID: #${loadsModel.id.toUpperCase()}',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                ),
                Spacer(),
                if (widget.isTruck)
                  InkWell(
                    onTap: () {
                      DocumentReference postRef = _firestore
                          .collection('Loaders')
                          .doc('Saved')
                          .collection(AppCache.getUser.uid)
                          .doc(widget.loadsModel.id);

                      postRef.get().then((value) {
                        if (value.exists) {
                          postRef.delete();
                          favorite = !favorite;
                          setState(() {});
                        } else {
                          postRef.set(widget.loadsModel.toJson());
                          favorite = !favorite;
                          setState(() {});
                        }
                      });
                    },
                    child: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      size: 30.h,
                      color: AppColors.primaryColor,
                    ),
                  )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.grey.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.h)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      regularText(
                        loadsModel.title,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                      Spacer(),
                      regularText(
                        DateFormat('EEE MMM, dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                widget.loadsModel.dateTime)),
                        fontSize: 15.sp,
                        color: AppColors.grey,
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
                                width: 1.h, color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(10.h)),
                      ),
                      SizedBox(width: 10.h),
                      Expanded(
                        child: regularText(
                          loadsModel.pickup,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
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
                            color: AppColors.primaryColor,
                            border: Border.all(
                                width: 1.h, color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(10.h)),
                      ),
                      SizedBox(width: 10.h),
                      Expanded(
                        child: regularText(
                          loadsModel.dropoff,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item2('Item', ': ${loadsModel.title}'),
                  if (loadsModel.weight.isNotEmpty)
                    item2('Weight', ': ${loadsModel.weight}'),
                  item2('Skids', ': ${loadsModel.skids}'),
                  item2('Price', ': \$50 - \$${loadsModel.price}'),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            !widget.isTruck
                ? loadsModel?.isBooked == true
                    ? SizedBox()
                    : Center(
                        child: InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                EditLoadScreen(
                                  loadsModel: widget.loadsModel,
                                ));
                          },
                          child: regularText(
                            'Edit',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                : Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                            size: 24.h,
                          ),
                          SizedBox(width: 8.h),
                          regularText(
                            'Share',
                            fontSize: 17.sp,
                            color: AppColors.primaryColor,
                          ),
                          Spacer(),
                          regularText(
                            'Posted by :',
                            fontSize: 17.sp,
                            color: AppColors.grey,
                          ),
                          SizedBox(width: 8.h),
                          InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  FinderDetails(
                                    isTruck:
                                        AppCache.userType == UserType.TRUCKER,
                                    truckModel: TruckModel(
                                      uid: loadsModel?.loaderUid,
                                      id: loadsModel.id,
                                      name: loadsModel.name,
                                      address: loadsModel.pickup,
                                      companyPhone: loadsModel.phone,
                                    ),
                                  ));
                            },
                            child: regularText(loadsModel?.name,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Color(0xffFFEBA3),
                              borderRadius: BorderRadius.circular(10.h)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateReplacement(
                                      context,
                                      LoadsStatusScreen(
                                          loadsModel: widget.loadsModel));
                                },
                                child: regularText('Click here',
                                    fontSize: 17.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              regularText(
                                ' if you have booked this load',
                                fontSize: 17.sp,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          )),
                      SizedBox(height: 30.h),
                      buttonWithBorder('Call',
                          borderColor: AppColors.primaryColor,
                          buttonColor: AppColors.primaryColor,
                          textColor: AppColors.white,
                          fontSize: 17.sp,
                          height: 50.h,
                          fontWeight: FontWeight.w600, onTap: () {
                        launch('tel:${loadsModel.phone}');
                      }),
                      SizedBox(height: 8.h),
                      buttonWithBorder('Message',
                          borderColor: AppColors.primaryColor,
                          buttonColor: AppColors.white,
                          textColor: AppColors.primaryColor,
                          fontSize: 17.sp,
                          height: 50.h,
                          fontWeight: FontWeight.w600, onTap: () {
                        navigateTo(
                            context,
                            ChatDetailsView(
                                contact: UserData(
                              name: loadsModel.name,
                              uid: loadsModel.loaderUid,
                              image: loadsModel.image,
                            )));
                      }),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget item2(String a, String b) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: regularText(
              a,
              fontSize: 17.sp,
              color: AppColors.grey,
            ),
          ),
          Expanded(
            flex: 2,
            child: regularText(
              b,
              fontSize: 17.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
