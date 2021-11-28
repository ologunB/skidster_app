import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class FindTruckerWidget extends StatefulWidget {
  const FindTruckerWidget({Key key}) : super(key: key);

  @override
  _FindTruckerWidgetState createState() => _FindTruckerWidgetState();
}

class _FindTruckerWidgetState extends State<FindTruckerWidget> {
  bool isLoading = true;
  List<TruckModel> myTrucks = [];
  List<TruckModel> filteredList = [];

  TextEditingController searchController = TextEditingController();

  FilterItem filters;

  @override
  void initState() {
    FirebaseFirestore.instance.collection('All-Truckers').get().then((value) {
      value.docs.forEach((element) {
        myTrucks.add(TruckModel.fromJson(element.data()));
      });
      isLoading = false;
      filteredList.addAll(myTrucks);
      setState(() {});
    });
    super.initState();
  }

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
                onChanged: (a)   {
                  a = a.trim();
                  filteredList.clear();
                  if (a.length > 1) {
                    a = a.toUpperCase();
                    for (TruckModel item in myTrucks) {
                      if (item.name.toUpperCase().contains(a) ||
                          item.companyName.toUpperCase().contains(a) ||
                          item.address.toUpperCase().contains(a) ||
                          item.uid.toUpperCase().contains(a)) {
                        if (filters != null) {
                          double l = 0;
                          if (filters.showNearby &&
                              item.position is Map &&
                              filters.location != null) {
                            double a = item.position['lat'] -
                                filters.location.latitude;
                            double b = item.position['lng'] -
                                filters.location.longitude;
                            l = math.sqrt(a * a - b * b);
                          }
                          if ((item.skids < filters.skidsCapacity) &&
                              (filters.truckType == null
                                  ? true
                                  : item.truckType
                                      .contains(filters.truckType)) &&
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
                print(a.location);
                print(a.showNearby);
                print(a.truckType);
                print(a.radius);
                print(a.skidsCapacity);
                if (a != null) {
                  filters = a;
                }
              },
              highlightColor: AppColors.white,
              child:
                  Image.asset('images/filter.png', height: 50.h, width: 50.h),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        isLoading
            ? CustomLoader()
            : filteredList.isEmpty
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
                    itemCount: filteredList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      TruckModel model = filteredList[index];
                      return InkWell(
                        onTap: () {
                          navigateTo(context, FinderDetails(truckModel: model));
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText(
                                    model.name.toTitleCase() +
                                        ' | ' +
                                        model.companyName.toTitleCase(),
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
                                            image: model.image,
                                            phone: model.phone,
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
                                    launch('tel:${model.phone}');
                                  },
                                  child: Container(
                                      height: 33.h,
                                      width: 33.h,
                                      decoration: BoxDecoration(
                                          color: AppColors.grey.withOpacity(.5),
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
                    })
      ],
    );
  }

  Widget item1(String a) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
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
