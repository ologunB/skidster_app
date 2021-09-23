import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/paid_plans_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';

import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class GoPremiumScreen extends StatefulWidget {
  const GoPremiumScreen({Key key}) : super(key: key);

  @override
  _GoPremiumScreenState createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  int selectedIndex;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = AppCache.getUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          margin: EdgeInsets.all(30.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.h)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              regularText(
                'Become a Premium',
                fontSize: 24.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: regularText(
                  'Get unlimited access to truckloads\nand truckers',
                  fontSize: 11.sp,
                  textAlign: TextAlign.center,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              Divider(
                height: 0,
                thickness: 1.h,
                color: AppColors.grey.withOpacity(.2),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Plans')
                      .orderBy('updated_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomLoader();
                    } else if (snapshot.hasError) {
                      ErrorOccurredWidget(error: snapshot.error);
                    } else if (snapshot.hasData) {
                      List<PaidPlansModel> myTrucks = [];

                      snapshot.data.docs.forEach((element) {
                        PaidPlansModel model =
                            PaidPlansModel.fromJson(element.data());
                        //  Logger().d(model.toJson());
                        myTrucks.add(model);
                      });
                      return myTrucks.isEmpty
                          ? AppEmptyWidget(text: 'No Plans for now')
                          : ListView.separated(
                              itemCount: 3,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedIndex = index;
                                    setState(() {});
                                    /*    Map<String, dynamic> mData = Map();
                                    mData.putIfAbsent("plan", () => myTrucks[index].title);

                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(uid)
                                        .update(mData);*/
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.h),
                                    color: selectedIndex == index
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        regularText(
                                          'CA\$${myTrucks[index].price}',
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w600,
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : AppColors.primaryColor,
                                        ),
                                        regularText(
                                          ' / ${days(myTrucks[index].duration)} Month',
                                          fontSize: 15.sp,
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 0,
                                  thickness: 1.h,
                                  color: AppColors.grey.withOpacity(.2),
                                );
                              },
                            );
                    }
                    return Container();
                  }),
              Divider(
                height: 0,
                thickness: 1.h,
                color: AppColors.grey.withOpacity(.2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
                child: buttonWithBorder('Continue',
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    height: 45.h,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w400,
                    onTap: () {}),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: regularText(
                  'No, thanks',
                  fontSize: 17.sp,
                  textAlign: TextAlign.center,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String days(int a) {
    return (a % 30).toString();
  }
}
