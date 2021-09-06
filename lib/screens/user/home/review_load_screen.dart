import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/utils/navigator.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';

import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import '../../../locator.dart';
import '../user_main_layout.dart';

class ReviewLoadScreen extends StatefulWidget {
  const ReviewLoadScreen({Key key, this.loadsModel}) : super(key: key);

  final LoadsModel loadsModel;

  @override
  _ReviewLoadScreenState createState() => _ReviewLoadScreenState();
}

class _ReviewLoadScreenState extends State<ReviewLoadScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(_) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder(
            'Submit',
            buttonColor: AppColors.primaryColor,
            fontSize: 17.sp,
            height: 50.h,
            busy: isLoading,
            textColor: AppColors.white,
            fontWeight: FontWeight.w600,
            onTap: () {
              addLoad(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                regularText(
                  'Review Post Load',
                  fontSize: 22.sp,
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
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.h),
                        topRight: Radius.circular(20.h)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -15),
                          blurRadius: 20,
                          spreadRadius: 1,
                          color: AppColors.grey.withOpacity(.2))
                    ]),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                  children: [
                    regularText(
                      'Review Post Load',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
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
                        regularText(
                          widget.loadsModel.pickup,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
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
                        regularText(
                          widget.loadsModel.dropoff,
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Date & Time',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      DateFormat('EEEE MMMM, dd').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.loadsModel.dateTime)),
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    regularText(
                      DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.loadsModel.dateTime)),
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Item Name',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      widget.loadsModel.title,
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Skids',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '${widget.loadsModel.skids} Skids',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Weight',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '${widget.loadsModel.weight} KG',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                    regularText(
                      'Price',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                    regularText(
                      '\$40',
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 30.h),
                  ],
                )),
          )
        ],
      ),
    );
  }

  bool isLoading = false;

  void addLoad(context) async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String id = Utils.randomString(no: 5) +
        DateTime.now().millisecondsSinceEpoch.toString();
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference postRef =
        _firestore.collection('Loaders').doc('Added').collection(uid).doc(id);
    DocumentReference allTrucks = _firestore.collection('All-Loaders').doc(id);

    Map<String, dynamic> mData = widget.loadsModel.toJson();
    mData.update("id", (a) => id);
    mData.update("uid", (a) => uid);

    WriteBatch writeBatch = _firestore.batch();
    writeBatch.set(postRef, mData);
    writeBatch.set(allTrucks, mData);

    try {
      writeBatch.commit().timeout(Duration(seconds: 10), onTimeout: () {
        showSnackBar(context, 'Error', 'Timed out');
        setState(() {
          isLoading = false;
        });
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        userMainPageController.jumpToPage(1);
      });
    } catch (e) {
      showSnackBar(context, 'Error', e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
