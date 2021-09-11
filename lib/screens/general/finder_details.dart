import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/message/message_details.dart';
import 'package:mms_app/screens/general/notifications_screen.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class FinderDetails extends StatefulWidget {
  const FinderDetails({Key key, this.truckModel, this.isTruck = false})
      : super(key: key);

  final TruckModel truckModel;
  final bool isTruck;

  @override
  _FinderDetailsState createState() => _FinderDetailsState();
}

class _FinderDetailsState extends State<FinderDetails> {
  bool favorite = false;

  int tripsNumber, postedJobs, completedJobs;

  StreamSubscription streams1, streams2, streams3;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    streams1 = _firestore
        .collection('Loaders')
        .doc('Completed')
        .collection(widget.truckModel.uid)
        .snapshots()
        .listen((event) {
      tripsNumber = event.size;
      setState(() {});
    });

    _firestore
        .collection('Truckers')
        .doc('Saved')
        .collection(AppCache.getUser.uid)
        .doc(widget.truckModel.id)
        .get()
        .then((value) {
      favorite = value.exists;
      setState(() {});
    });

    if (!widget.isTruck) {
      _firestore
          .collection('Users')
          .doc(widget.truckModel.uid)
          .get()
          .then((value) {
        print(value.data());
        UserData user = UserData.fromJson(value.data());
        truckModel = TruckModel(
          name: user.name,
          address: user.companyAddress,
          companyName: user.companyName,
        );
        setState(() {});
      });
    } else {
      streams2 = _firestore
          .collection('Loaders')
          .doc('Completed')
          .collection(widget.truckModel.uid)
          .snapshots()
          .listen((event) {
        completedJobs = event.size;
        setState(() {});
      });

      streams3 = _firestore
          .collection('Loaders')
          .doc('Added')
          .collection(widget.truckModel.uid)
          .snapshots()
          .listen((event) {
        postedJobs = event.size;
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    streams1.cancel();
    streams2.cancel();
    streams3.cancel();
    super.dispose();
  }

  TruckModel truckModel;

  @override
  Widget build(BuildContext context) {
    if (widget.truckModel.experience != null) {
      truckModel = widget.truckModel;
    }
    if (widget.isTruck) {
      truckModel = widget.truckModel;
    }
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  navigateTo(context, NotificationsScreen());
                },
                child: Icon(
                  Icons.notifications,
                  size: 24.h,
                  color: AppColors.white,
                ),
              )
            ],
          ),
          SizedBox(width: 12.h)
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 10.h),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buttonWithBorder('Call',
                  borderColor: AppColors.primaryColor,
                  buttonColor: AppColors.primaryColor,
                  textColor: AppColors.white,
                  fontSize: 17.sp,
                  height: 50.h,
                  fontWeight: FontWeight.w600, onTap: () {
                if (truckModel.companyPhone == null) {
                  return;
                }
                launch('tel${truckModel?.companyPhone}');
              }),
              SizedBox(height: 8.h),
              buttonWithBorder('Message',
                  borderColor: AppColors.primaryColor,
                  buttonColor: AppColors.white,
                  textColor: AppColors.primaryColor,
                  fontSize: 17.sp,
                  height: 50.h,
                  fontWeight: FontWeight.w600, onTap: () {
                if (truckModel.name == null) {
                  return;
                }
                navigateReplacement(
                    context,
                    ChatDetailsView(
                      contact: UserData(
                        uid: truckModel.uid,
                        name: truckModel.name,
                        image: truckModel.image,
                        phone: truckModel.companyPhone,
                      ),
                    ));
              }),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.h),
                child: Image.asset(
                  'images/placeholder.png',
                  width: 100.h,
                  height: 100.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          regularText(
            widget.isTruck
                ? (truckModel?.name ?? '')
                : (truckModel?.name ?? '') +
                    ' | ' +
                    (truckModel?.companyName ?? ''),
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          SizedBox(height: 12.h),
          regularText(
            truckModel?.address ?? '',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: AppColors.white,
          ),
          SizedBox(height: 12.h),
          if (!widget.isTruck)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (truckModel.name == null) {
                      return;
                    }
                    DocumentReference postRef = _firestore
                        .collection('Truckers')
                        .doc('Saved')
                        .collection(AppCache.getUser.uid)
                        .doc(truckModel.id);

                    postRef.get().then((value) {
                      if (value.exists) {
                        postRef.delete();
                        favorite = !favorite;
                        setState(() {});
                      } else {
                        postRef.set(truckModel.toJson());
                        favorite = !favorite;
                        setState(() {});
                      }
                    });
                  },
                  child: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 24.h,
                  ),
                ),
                SizedBox(width: 12.h),
                Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24.h,
                ),
              ],
            ),
          SizedBox(height: 12.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.h),
                  topRight: Radius.circular(16.h),
                ),
              ),
              child: !widget.isTruck
                  ? Column(
                      children: [
                        if (truckModel?.truckType != null)
                          item(
                              'Truck Type', ': ${truckModel?.truckType ?? ''}'),
                        if (truckModel?.skids != null)
                          item(
                              'Skids Capacity', ': ${truckModel?.skids ?? ''}'),
                        if (tripsNumber != null)
                          item('Truck trips ', ': ${tripsNumber ?? ''}'),
                        if (truckModel?.experience != null)
                          item('Truck Driving Experience',
                              ': ${truckModel?.experience ?? ''} years'),
                        if (truckModel?.isInsured != null)
                          item('Truck Insurance',
                              ': ${truckModel?.isInsured == 1 ? 'YES' : 'NO'}'),
                      ],
                    )
                  : Column(
                      children: [
                        if (postedJobs != null)
                          item('Posted Jobs',
                              ': ${postedJobs + (completedJobs ?? 0)}'),
                        if (completedJobs != null)
                          item('Completed Jobs', ': ${completedJobs ?? ''}'),
                        Row()
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget item(String a, String b) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: regularText(
              a,
              fontSize: 17.sp,
              color: AppColors.grey,
            ),
          ),
          Expanded(
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
