import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import '../finder_details.dart';

class SavedProfilesScreen extends StatefulWidget {
  const SavedProfilesScreen({Key key, this.isTruck = false}) : super(key: key);

  final bool isTruck;

  @override
  _SavedProfilesScreenState createState() => _SavedProfilesScreenState();
}

class _SavedProfilesScreenState extends State<SavedProfilesScreen> {
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
                    'Saved Profile',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Truckers')
                      .doc('Saved')
                      .collection(uid)
                      .orderBy('updated_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomLoader();
                    } else if (snapshot.hasError) {
                      ErrorOccurredWidget(error: snapshot.error);
                    } else if (snapshot.hasData) {
                      List<TruckModel> myLoads = [];
                      snapshot.data.docs.forEach((element) {
                        TruckModel model = TruckModel.fromJson(element.data());
                        //  Logger().d(model.toJson());
                        myLoads.add(model);
                      });
                      return myLoads.isEmpty
                          ? Container(
                              height: SizeConfig.screenHeight / 3,
                              alignment: Alignment.center,
                              child: regularText(
                                'No saved profiles',
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
                                TruckModel model = myLoads[index];
                                return InkWell(
                                  onTap: () {
                                    navigateTo(context,
                                        FinderDetails(truckModel: model));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15.h),
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
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.h),
                                            child: Image.asset(
                                              'images/placeholder.png',
                                              height: 50.h,
                                              width: 50.h,
                                            )),
                                        SizedBox(width: 10.h),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              regularText(
                                                '${model.name} | ${model.companyName}',
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              ),
                                              SizedBox(height: 6.h),
                                              regularText(
                                                last2(model.address),
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.grey,
                                              ),
                                              SizedBox(height: 6.h),
                                              Row(
                                                children: [
                                                  item1('${model.truckType}'),
                                                  item1(
                                                      'Skids: ${model.skids}'),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget item1(String a) {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
      decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(6.h)),
      child: regularText(
        a,
        fontSize: 17.sp,
        color: AppColors.primaryColor,
      ),
    );
  }

  String last2(String a) {
    List<String> b = a.split(',');
    return b[b.length - 3].trim() + ', ' + b[b.length - 2].trim();
  }
}
