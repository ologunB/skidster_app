import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/load_response.dart';
 import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/general/filter_screen.dart';
import 'package:mms_app/screens/trucker/home/all_already_taken.dart';
import 'package:mms_app/screens/user/loads/loads_info_screen.dart';
import 'package:mms_app/screens/user/loads/loads_status_screen.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/app_separator.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class TruckerHomeScreen extends StatefulWidget {
  const TruckerHomeScreen({Key key}) : super(key: key);

  @override
  _TruckerHomeScreenState createState() => _TruckerHomeScreenState();
}

class _TruckerHomeScreenState extends State<TruckerHomeScreen> {
  bool isPostLoad = true;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = AppCache.getUser.uid;

  bool isLoading = true;
  List<LoadsModel> myTrucks = [];
  List<LoadsModel> filteredList = [];

  TextEditingController searchController = TextEditingController();

  FilterItem filters;

  @override
  void initState() {
    _firestore.collection('All-Loaders').get().then((value) {
      value.docs.forEach((element) {
        myTrucks.add(LoadsModel.fromJson(element.data()));
      });
      isLoading = false;
      filteredList.addAll(myTrucks);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          children: [
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              children: [
                Row(
                  children: [
                    regularText(
                      'Welcome ${AppCache.getUser.name.toTitleCase()}',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    Spacer(),
                    AppNotificationsWidget()
                  ],
                ),
                regularText(
                  'What would you like to do?',
                  fontSize: 17.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        isPostLoad = true;
                        setState(() {});
                      },
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 12.h),
                        decoration: BoxDecoration(
                            color:
                                isPostLoad ? Color(0xffCDD3EA) : Colors.white,
                            borderRadius: BorderRadius.circular(10.h)),
                        child: regularText(
                          'Find Load',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isPostLoad
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
            Container(
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
                            style: GoogleFonts.inter(
                              color: AppColors.primaryColor,
                              fontSize: 17.sp,
                              letterSpacing: 0.4,
                            ),
                            onChanged: (a) {
                              a = a.trim();
                              filteredList.clear();
                              if (a.length > 1) {
                                a = a.toUpperCase();
                                for (LoadsModel item in myTrucks) {
                                  if (item.name.toUpperCase().contains(a) ||
                                      item.phone.toUpperCase().contains(a) ||
                                      item.pickup.toUpperCase().contains(a) ||
                                      item.dropoff.toUpperCase().contains(a) ||
                                      item.weight.toUpperCase().contains(a)) {
                                    if (filters != null) {
                                      double l = 0;

                                      if ((item.skids <
                                              filters.skidsCapacity) &&
                                          (filters.showNearby
                                              ? l < filters.radius
                                              : true)) {
                                        filteredList.add(item);
                                      }
                                    } else {
                                      filteredList.add(item);
                                    }
                                  }
                                }
                              } else {
                                filteredList.addAll(myTrucks);
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.all(15.h),
                              hintText: 'Find your Load...',
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
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.grey.withOpacity(.2),
                                    width: 1.h),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(width: 12.h),
                        InkWell(
                          onTap: () async {
                            Utils.unfocusKeyboard(context);
                            FilterItem a = await Navigator.push(
                              context,
                              CupertinoPageRoute<FilterItem>(
                                builder: (BuildContext context) =>
                                    FilterScreen(filterItem: filters),
                              ),
                            );
                            if (a != null) filters = a;
                          },
                          highlightColor: AppColors.white,
                          child: Image.asset('images/filter.png',
                              height: 50.h, width: 50.h),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        regularText(
                          'Recently Added Loads',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            navigateTo(
                                context, AllAlreadyTaken(type: 'Recent'));
                          },
                          child: regularText('View all',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    isLoading
                        ? CustomLoader()
                        : filteredList.isEmpty
                            ? AppEmptyWidget(text: 'Loads tray is Empty')
                            : SingleChildScrollView(
                                padding: EdgeInsets.all(8.h),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: filteredList.map((model) {
                                    return InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            LoadsDetailsScreen(
                                                loadsModel: model,
                                                isTruck: true));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14.h, vertical: 10.h),
                                        width: SizeConfig.screenWidth * .9,
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
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      4.h),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 9.h,
                                                                width: 9.h,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            1.h,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.h)),
                                                              ),
                                                              Expanded(
                                                                  child: SizedBox() ??
                                                                      MySeparator()),
                                                              Container(
                                                                height: 9.h,
                                                                width: 9.h,
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    border: Border.all(
                                                                        width:
                                                                            1.h,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.h)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.h),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    regularText(
                                                                  model.pickup,
                                                                  fontSize:
                                                                      15.sp,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              regularText(
                                                                model.dropoff,
                                                                fontSize: 15.sp,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    children: [
                                                      if (model
                                                          .weight.isNotEmpty)
                                                        item1(
                                                            '${model.weight}'),
                                                      item1('\$${model.price}'),
                                                      item1(
                                                          '${model.skids} Skids'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        regularText(
                          'My Loads',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            navigateTo(context, AllAlreadyTaken(type: 'Added'));
                          },
                          child: regularText('View all',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.h)),
                          child: regularText(
                            'In Progress',
                            fontSize: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Loaders')
                            .doc('Added')
                            .collection(uid)
                            .orderBy('updated_at', descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CustomLoader();
                          } else if (snapshot.hasError) {
                            ErrorOccurredWidget(error: snapshot.error);
                          } else if (snapshot.hasData) {
                            List<LoadsModel> myLoads = [];
                            snapshot.data.docs.forEach((element) {
                              LoadsModel model =
                                  LoadsModel.fromJson(element.data());
                              //  Logger().d(model.toJson());

                              myLoads.add(model);
                            });
                            return myLoads.isEmpty
                                ? regularText(
                                    'No Loads in progress',
                                    fontSize: 13.sp,
                                    color: AppColors.grey,
                                  )
                                : SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Column(
                                      children: myLoads.map((model) {
                                        return InkWell(
                                          onTap: () {
                                            navigateTo(
                                                context,
                                                LoadsStatusScreen(
                                                    loadsModel: model));
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 15.h),
                                            padding: EdgeInsets.all(15.h),
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
                                                    BorderRadius.circular(
                                                        10.h)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                regularText(
                                                  model.title.toTitleCase(),
                                                  fontSize: 15.sp,
                                                  color: AppColors.primaryColor,
                                                ),
                                                Row(
                                                  children: [
                                                    regularText(
                                                      '${Utils.last2(model.pickup)} > ${Utils.last2(model.dropoff)} ',
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    Spacer(),
                                                    regularText(
                                                      DateFormat('dd MMM, yyyy')
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  model
                                                                      .dateTime)),
                                                      fontSize: 11.sp,
                                                      color: AppColors.grey,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                          }
                          return Container();
                        }),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Container(
                          height: 30.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10.h)),
                          child: regularText(
                            'Completed',
                            fontSize: 13.sp,
                            color: AppColors.white,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            navigateTo(
                                context, AllAlreadyTaken(type: 'Completed'));
                          },
                          child: regularText('View all',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Loaders')
                            .doc('Completed')
                            .collection(uid)
                            .orderBy('updated_at', descending: true)
                            .limit(2)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CustomLoader();
                          } else if (snapshot.hasError) {
                            ErrorOccurredWidget(error: snapshot.error);
                          } else if (snapshot.hasData) {
                            List<LoadsModel> myLoads = [];
                            snapshot.data.docs.forEach((element) {
                              LoadsModel model =
                                  LoadsModel.fromJson(element.data());
                              //  Logger().d(model.toJson());

                              myLoads.add(model);
                            });
                            return myLoads.isEmpty
                                ? regularText(
                                    'No Completed Loads',
                                    fontSize: 13.sp,
                                    color: AppColors.grey,
                                  )
                                : SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Column(
                                      children: myLoads.map((model) {
                                        return InkWell(
                                          onTap: () {
                                            navigateTo(
                                                context,
                                                LoadsStatusScreen(
                                                    loadsModel: model));
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 15.h),
                                            padding: EdgeInsets.all(15.h),
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
                                                    BorderRadius.circular(
                                                        10.h)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                regularText(
                                                  model.title.toTitleCase(),
                                                  fontSize: 15.sp,
                                                  color: AppColors.primaryColor,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: regularText(
                                                        '${Utils.last2(model.pickup)} > ${Utils.last2(model.dropoff)} ',
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12.h),
                                                    regularText(
                                                      'Completed',
                                                      fontSize: 11.sp,
                                                      color: AppColors.grey,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                          }
                          return Container();
                        }),
                    SizedBox(height: 12.h),
                  ],
                ))
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
