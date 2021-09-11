import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/finder_details.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class LoadsStatusScreen extends StatefulWidget {
  final LoadsModel loadsModel;
  final bool isTruck;

  const LoadsStatusScreen({Key key, this.loadsModel, this.isTruck = true})
      : super(key: key);

  @override
  _LoadsStatusScreenState createState() => _LoadsStatusScreenState();
}

class _LoadsStatusScreenState extends State<LoadsStatusScreen> {
  bool favorite = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;

  LoadsModel myLoad;

  StreamSubscription adderStream, add2stream;

  @override
  void initState() {
    adderStream = _firestore
        .collection('Loaders')
        .doc('Added')
        .collection(uid)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        LoadsModel model = LoadsModel.fromJson(element.data());
        if (model.id == widget.loadsModel.id) {
          myLoad = model;
          setState(() {});
          Logger().d(myLoad.toJson());
        }
      });
    });

    add2stream = _firestore
        .collection('Loaders')
        .doc('Completed')
        .collection(uid)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        LoadsModel model = LoadsModel.fromJson(element.data());
        if (model.id == widget.loadsModel.id) {
          myLoad = model;
          setState(() {});
          Logger().d(myLoad.toJson());
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    adderStream?.cancel();
    add2stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myLoad = myLoad == null ? widget.loadsModel : myLoad;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
          child: SafeArea(
            child: widget.isTruck
                ? buttonWithBorder(stagesText[myLoad.stage],
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    height: 50.h,
                    busy: isLoading,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w600, onTap: () {
                    if (myLoad.stage == 3) return;
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            regularText(
                              dialogStages[myLoad.stage],
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
                                      bookLoad(context, myLoad.stage);
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
                  })
                : buttonWithBorder(
                    userStagesText[myLoad.stage],
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    height: 50.h,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            children: [
              Row(
                children: [
                  regularText(
                    'Load Status',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  Spacer(),
                  PopupMenuButton(
                      onSelected: (int a) {
                        if (a == 0) {
                          FirebaseFirestore _firestore =
                              FirebaseFirestore.instance;
                          String id = Utils.randomString(no: 5) +
                              DateTime.now().millisecondsSinceEpoch.toString();

                          Map<String, dynamic> mData = Map();
                          mData.putIfAbsent("id", () => widget.loadsModel.id);
                          mData.putIfAbsent(
                              "reporter", () => AppCache.getUser.uid);
                          mData.putIfAbsent("updated_at",
                              () => DateTime.now().millisecondsSinceEpoch);

                          _firestore
                              .collection('Support')
                              .doc('Reports')
                              .collection('Unattended')
                              .doc(id)
                              .set(mData)
                              .then((value) {});

                          showSnackBar(
                            context,
                            'Success',
                            'The Load has been reported',
                            color: AppColors.primaryColor,
                          );
                        }
                      },
                      child: Icon(
                        Icons.info_outline,
                        size: 24.h,
                        color: AppColors.grey,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Report Load')),
                          ])
                ],
              ),
              SizedBox(height: 16.h),
              progressIndicator(myLoad?.stage ?? 0),
              SizedBox(height: 8.h),
              if (myLoad?.truckerName != null)
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Row(
                      children: [
                        regularText(
                          'Booked by:  ',
                          fontSize: 17.sp,
                          color: AppColors.primaryColor,
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                FinderDetails(
                                  truckModel: TruckModel(
                                    uid: myLoad?.truckerUid,
                                    id: myLoad.id,
                                  ),
                                ));
                          },
                          child: regularText(myLoad?.truckerName,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    )),
              Row(
                children: [
                  regularText(
                    'Post ID',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 10.h),
                  PopupMenuButton(
                      onSelected: (int a) {
                        if (a == 0) {
                          Clipboard.setData(
                              ClipboardData(text: widget.loadsModel.id));
                          showSnackBar(
                            context,
                            'Copied',
                            'The Load ID has been copied',
                            color: AppColors.primaryColor,
                          );
                        }
                      },
                      child: Icon(
                        Icons.info_outline,
                        size: 18.h,
                        color: AppColors.grey,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                            const PopupMenuItem<int>(
                                value: 0, child: Text('Copy ID')),
                          ])
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  regularText(
                    'Load Info',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item2('Item', ': ${widget.loadsModel.title}'),
                    if (widget.loadsModel.weight.isNotEmpty)
                      item2('Weight', ': ${widget.loadsModel.weight} kg'),
                    item2('Skids', ': ${widget.loadsModel.skids}'),
                    item2('Price', ': CA\$${widget.loadsModel.price}'),
                    item2('Pickup Address', ': ${widget.loadsModel.pickup}'),
                    item2('DropOff Address', ': ${widget.loadsModel.dropoff}'),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ));
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

  Widget progressIndicator(int val) {
    print(val);
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: AppColors.grey.withOpacity(.3),
            spreadRadius: 2,
            blurRadius: 10)
      ], color: Colors.white, borderRadius: BorderRadius.circular(15.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30.h,
            width: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: val > 0
                  ? AppColors.primaryColor
                  : AppColors.grey.withOpacity(.5),
            ),
            child: Icon(
              Icons.calendar_today,
              size: 18.h,
              color: val > 0 ? AppColors.white : AppColors.grey,
            ),
          ),
          Expanded(
              child: Container(
            height: 2.h,
            color: val > 0
                ? AppColors.primaryColor
                : AppColors.grey.withOpacity(.5),
          )),
          Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: val > 1
                    ? AppColors.primaryColor
                    : AppColors.grey.withOpacity(.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/profile1.png',
                    height: 18.h,
                    width: 18.h,
                    color: val > 1 ? AppColors.white : AppColors.grey,
                  )
                ],
              )),
          Expanded(
              child: Container(
            height: 2.h,
            color: val > 1
                ? AppColors.primaryColor
                : AppColors.grey.withOpacity(.5),
          )),
          Container(
            height: 30.h,
            width: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: val > 2
                  ? AppColors.primaryColor
                  : AppColors.grey.withOpacity(.5),
            ),
            child: Icon(
              Icons.check_circle_outline_outlined,
              size: 18.h,
              color: val > 2 ? AppColors.white : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Map<int, String> dialogStages = {
    0: 'Are you sure you have\nbooked this load?',
    1: 'Are you sure you have enroute to destination?',
    2: 'Are you sure you have delivered?',
  };

  Map<int, String> stagesText = {
    0: 'I have booked the load',
    1: 'I am enroute to destination',
    2: 'I have delivered',
    3: 'Completed',
  };

  Map<int, String> userStagesText = {
    1: 'The load has been booked',
    2: 'Load is enroute to destination',
    3: 'Load has delivered',
  };

  bool isLoading = false;

  bookLoad(context, stage) async {
    print(stage);
    if (stage == 3) {
      setState(() {});
      return;
    }
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String id = widget.loadsModel.id;
    String uid = widget.loadsModel.loaderUid;
    String myUid = AppCache.getUser.uid;
    String rand = Utils.randomString(no: 5) +
        DateTime.now().millisecondsSinceEpoch.toString();
    DocumentReference postRef =
        _firestore.collection('Loaders').doc('Added').collection(uid).doc(id);
    DocumentReference trucksLoad =
        _firestore.collection('Loaders').doc('Added').collection(myUid).doc(id);

    DocumentReference completePostRef = _firestore
        .collection('Loaders')
        .doc('Completed')
        .collection(uid)
        .doc(id);
    DocumentReference completeTrucksLoad = _firestore
        .collection('Loaders')
        .doc('Completed')
        .collection(myUid)
        .doc(id);
    DocumentReference allTrucks = _firestore.collection('All-Loaders').doc(id);

    DocumentReference notifiDoc = _firestore
        .collection('Notifications')
        .doc('Added')
        .collection(uid)
        .doc(rand);

    Map<String, dynamic> mData = widget.loadsModel.toJson();
    if (stage == 0) {
      mData.update("trucker_name", (a) => AppCache.getUser.name);
      mData.update("trucker_phone", (a) => AppCache.getUser.phone);
      mData.update("trucker_uid", (a) => AppCache.getUser.uid);
      mData.update("is_booked", (a) => true);
    } else {
      mData = Map();
    }
    mData.update("stage", (a) => stage + 1, ifAbsent: () => stage + 1);
    mData.update(
      "updated_at",
      (a) => DateTime.now().millisecondsSinceEpoch,
      ifAbsent: () => DateTime.now().millisecondsSinceEpoch,
    );

    Map<String, dynamic> notifiData = Map();
    notifiData.putIfAbsent('id', () => rand);
    notifiData.putIfAbsent('load_id', () => widget.loadsModel.id);
    notifiData.putIfAbsent('is_read', () => false);
    notifiData.putIfAbsent('person', () => AppCache.getUser.name);
    notifiData.putIfAbsent('text', () => userStagesText[stage + 1]);
    notifiData.putIfAbsent(
        "updated_at", () => DateTime.now().millisecondsSinceEpoch);
    WriteBatch writeBatch = _firestore.batch();
    if (stage == 0) {
      // update user to processing
      writeBatch.update(postRef, mData);
      // delete from the market
      writeBatch.delete(allTrucks);
      // create new item for trucker¬
      writeBatch.set(trucksLoad, mData);
    } else if (stage == 1) {
      // update user to processing
      writeBatch.update(postRef, mData);
      // create new item for trucker¬
      writeBatch.update(trucksLoad, mData);
    } else if (stage == 2) {
      if (myLoad == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      Map<String, dynamic> _mData = myLoad.toJson();
      _mData.update("stage", (a) => 3, ifAbsent: () => 3);
      _mData.update(
        "updated_at",
        (a) => DateTime.now().millisecondsSinceEpoch,
        ifAbsent: () => DateTime.now().millisecondsSinceEpoch,
      );
      // set user complete
      writeBatch.set(completePostRef, _mData);
      // set user complete
      writeBatch.set(completeTrucksLoad, _mData);
      // delete user progress
      writeBatch.delete(postRef);
      // delete trucker progress
      writeBatch.delete(trucksLoad);
    }
    writeBatch.set(notifiDoc, notifiData);

    Navigator.pop(context);
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
      }).catchError((e) {
        Logger().d(e);
        showSnackBar(context, 'Error', e.toString());
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      showSnackBar(context, 'Error', e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
