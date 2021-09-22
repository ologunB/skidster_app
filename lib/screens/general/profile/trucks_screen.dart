import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/trucker/auth/set_profile_screen.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class MyTrucksScreen extends StatefulWidget {
  @override
  _MyTrucksScreenState createState() => _MyTrucksScreenState();
}

class _MyTrucksScreenState extends State<MyTrucksScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = AppCache.getUser.uid;

  @override
  void initState() {
    _firestore.collection('Truckers').doc('Added').collection(uid).snapshots();

    super.initState();
  }

  List<TruckModel> myTrucks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        floatingActionButton: myTrucks.length >= 5
            ? null
            : Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: FloatingActionButton(
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Navigator.push<void>(
                          context,
                          CupertinoPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  SetupProfileScreen(isAdd: true)));
                      setState(() {});
                    }),
              ),
        body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            shrinkWrap: true,
            children: [
              regularText(
                'My Trucks',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Truckers')
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
                      myTrucks = [];
                      snapshot.data.docs.forEach((element) {
                        TruckModel model = TruckModel.fromJson(element.data());
                        //  Logger().d(model.toJson());
                        myTrucks.add(model);
                      });
                      return myTrucks.isEmpty
                          ? AppEmptyWidget(text: 'Trucks tray is Empty')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: myTrucks.length,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                TruckModel model = myTrucks[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 15.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.h, vertical: 10.h),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                AppColors.grey.withOpacity(.3),
                                            spreadRadius: 2,
                                            blurRadius: 10)
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10.h)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          regularText(
                                            '#${model.id.toUpperCase()}',
                                            fontSize: 13.sp,
                                            color: AppColors.grey,
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              showDialog<AlertDialog>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      regularText(
                                                        'Are you sure you want\nto delete the Truck?',
                                                        fontSize: 17.sp,
                                                        textAlign:
                                                            TextAlign.center,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                buttonWithBorder(
                                                              'YES',
                                                              buttonColor: AppColors
                                                                  .primaryColor,
                                                              fontSize: 17.sp,
                                                              height: 40.h,
                                                              textColor:
                                                                  AppColors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              onTap: () {
                                                                delete(model.id,
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.h),
                                                          Expanded(
                                                            child:
                                                                buttonWithBorder(
                                                              'NO',
                                                              buttonColor:
                                                                  AppColors
                                                                      .white,
                                                              fontSize: 17.sp,
                                                              borderColor: AppColors
                                                                  .primaryColor,
                                                              height: 40.h,
                                                              textColor: AppColors
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.h,
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                  color: AppColors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.h)),
                                              child: regularText(
                                                'Delete',
                                                fontSize: 11.sp,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      regularText(
                                        model.truckType,
                                        fontSize: 15.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      regularText(
                                        'Insured: ${model.isInsured == 0 ? 'NO' : 'YES'}',
                                        fontSize: 15.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          item1('5000kg'),
                                          item1(
                                              'Experience: ${model.experience} years'),
                                          item1('${model.skids} Skids'),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                    }
                    return Container();
                  }),
            ]));
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

  delete(String id, context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference postRef =
        _firestore.collection('Truckers').doc('Added').collection(uid).doc(id);

    DocumentReference allTrucks = _firestore.collection('All-Truckers').doc(id);

    WriteBatch writeBatch = _firestore.batch();
    writeBatch.delete(postRef);
    writeBatch.delete(allTrucks);
    writeBatch.commit();
    Navigator.pop(context);
  }
}
