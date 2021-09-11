import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/truck_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/filter_screen.dart';
import 'package:mms_app/screens/general/finder_details.dart';
import 'package:mms_app/screens/general/message/message_details.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class FindTruckerWidget extends StatefulWidget {
  const FindTruckerWidget({Key key}) : super(key: key);

  @override
  _FindTruckerWidgetState createState() => _FindTruckerWidgetState();
}

class _FindTruckerWidgetState extends State<FindTruckerWidget> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser.uid;

  bool isLoading = false;
  List<TruckModel> myTrucks = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(20.h),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                cursorHeight: 15.h,
                maxLines: 1,
                controller: searchController,
                style: GoogleFonts.inter(
                  color: AppColors.primaryColor,
                  fontSize: 17.sp,
                  letterSpacing: 0.4,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.all(15.h),
                  hintText: 'Find your trucker...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textGrey,
                    fontSize: 17.sp,
                  ),
                  fillColor: AppColors.grey.withOpacity(.2),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(.2), width: 1.h),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                ),
                textAlign: TextAlign.start,
                onChanged: (a) async {
                  isLoading = true;
                  setState(() {});
                  await FirebaseFirestore.instance
                      .collection("All-Truckers")
                      .where("name", isGreaterThanOrEqualTo: a)
                      //  .where("address", isGreaterThanOrEqualTo: a)
                      .get()
                      .then((value) {
                    Logger().d(value.size);
                    myTrucks.clear();
                    value.docs.forEach((element) {
                      TruckModel model = TruckModel.fromJson(element.data());
                      //  Logger().d(model.toJson());

                      myTrucks.add(model);
                    });
                    isLoading = false;
                    setState(() {});
                  });
                },
              ),
            ),
            SizedBox(width: 12.h),
            InkWell(
              onTap: () {
                navigateTo(context, FilterScreen());
              },
              highlightColor: AppColors.white,
              child:
                  Image.asset('images/filter.png', height: 50.h, width: 50.h),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('All-Truckers')
                .orderBy('updated_at')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomLoader();
              } else if (snapshot.hasError) {
                ErrorOccurredWidget(error: snapshot.error);
              } else if (snapshot.hasData) {
                if (searchController.text.isEmpty) {
                  myTrucks.clear();
                  snapshot.data.docs.forEach((element) {
                    TruckModel model = TruckModel.fromJson(element.data());
                    //  Logger().d(model.toJson());
                    myTrucks.add(model);
                  });
                }

                return myTrucks.isEmpty
                    ? AppEmptyWidget(
                        text: searchController.text.isNotEmpty
                            ? 'No Trucker was found'
                            : 'Truck tray is Empty',
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Divider(
                              height: 0,
                              thickness: 1.h,
                              color: AppColors.grey.withOpacity(.2),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: myTrucks.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          TruckModel model = myTrucks[index];
                          return InkWell(
                            onTap: () {
                              navigateTo(
                                  context, FinderDetails(truckModel: model));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      regularText(
                                        model.name + ' | ' + model.companyName,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          regularText(
                                            Utils.last2(model.address),
                                            fontSize: 17.sp,
                                            color: AppColors.primaryColor,
                                          ),
                                          /*  Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.h),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: AppColors.primaryColor,
                                              size: 16.h,
                                            ),
                                          ),
                                          regularText(
                                            'Ontario, CA',
                                            fontSize: 17.sp,
                                            color: AppColors.primaryColor,
                                          ),*/
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      Container(
                                        height: 30.h,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            item1('${model.skids} Skids'),
                                            item1(model.truckType),
                                            item1(
                                                '${model.experience}years experience'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 6.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            ChatDetailsView(
                                              contact: UserData(
                                                uid: model.uid,
                                                name: model.name,
                                                image: '',
                                                phone: model.companyPhone,
                                              ),
                                            ));
                                      },
                                      child: Image.asset(
                                        'images/message_circle_icon.png',
                                        height: 33.h,
                                        width: 33.h,
                                      ),
                                    ),
                                    SizedBox(width: 6.h),
                                    InkWell(
                                      onTap: () {
                                        launch('tel:${model.companyPhone}');
                                      },
                                      child: Container(
                                          height: 33.h,
                                          width: 33.h,
                                          decoration: BoxDecoration(
                                              color: AppColors.grey
                                                  .withOpacity(.5),
                                              borderRadius:
                                                  BorderRadius.circular(20.h)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/call.png',
                                                height: 20.h,
                                                width: 20.h,
                                                color: AppColors.primaryColor,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
              }
              return Container();
            }),
      ],
    );
  }

  Widget item1(String a) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
          decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(6.h)),
          child: regularText(
            a,
            fontSize: 11.sp,
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }
}
