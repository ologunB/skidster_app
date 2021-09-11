import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/trucker/auth/upload_carierdocs_screen.dart';
import 'package:mms_app/screens/trucker/auth/upload_driverlicense_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import '../trucker_main_layout.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({this.isAdd = false});

  final bool isAdd;

  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  int insured, ownTruck;

  @override
  void initState() {
    if (widget.isAdd) ownTruck = 1;
    textListener.addListener(() {
      if (widget.isAdd) {
        Navigator.pop(context);
      }

      setState(() {});
    });
    super.initState();
  }

  String selectedTruckType, selectedTravelPreference;
  TextEditingController skidsCapacity = TextEditingController();
  TextEditingController drivingExperience = TextEditingController();
  TextEditingController textListener = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool mama = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      bottomNavigationBar: ownTruck == 1
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
              child: SafeArea(
                child: buttonWithBorder(widget.isAdd ? 'Add' : 'Next',
                    buttonColor: AppColors.primaryColor,
                    fontSize: 17.sp,
                    busy: isLoading,
                    height: 50.h,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w600,
                    onTap: isLoading
                        ? null
                        : () {
                            addTruck();
                          }),
              ),
            )
          : null,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            widget.isAdd ? 'Add Truck' : 'Set up\nYour Profile',
            fontSize: 40.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 18.h),
          if (!widget.isAdd)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item('I own truck'),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    item3(1, ownTruck),
                    SizedBox(width: 15.h),
                    item3(0, ownTruck),
                  ],
                ),
              ],
            ),
          if (ownTruck == 1)
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 16.h),
                item('Type of truck'),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.h),
                      border: Border.all(
                        width: 1.h,
                        color: AppColors.textGrey,
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 12.h),
                  height: 50.h,
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7c7c7c),
                    ),
                    isExpanded: true,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'Select truck type...',
                        style: GoogleFonts.inter(
                          color: AppColors.textGrey,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    value: selectedTruckType,
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 24.h,
                    ),
                    onChanged: (a) {
                      selectedTruckType = a;
                      setState(() {});
                    },
                    items: ['Trailer', 'Flatbed', 'Heavy duty']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(value,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.h),
                item('Skids capacity of truck'),
                SizedBox(height: 8.h),
                CustomTextField(
                  hintText: 'Input skids capacity',
                  validator: Utils.isValidName,
                  obscureText: false,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: skidsCapacity,
                ),
                SizedBox(height: 16.h),
                item('Driving experience'),
                SizedBox(height: 8.h),
                CustomTextField(
                  hintText: 'Enter Driving experience',
                  validator: Utils.isValidName,
                  obscureText: false,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: drivingExperience,
                ),
                SizedBox(height: 16.h),
                item('Is your truck insured?'),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    item2(1, insured),
                    SizedBox(width: 15.h),
                    item2(0, insured),
                  ],
                ),
                SizedBox(height: 16.h),
                item('Travel Preference'),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.h),
                      border: Border.all(
                        width: 1.h,
                        color: AppColors.textGrey,
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 12.h),
                  height: 50.h,
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7c7c7c),
                    ),
                    isExpanded: true,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'Choose Travel Preference',
                        style: GoogleFonts.inter(
                          color: AppColors.textGrey,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    value: selectedTravelPreference,
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 24.h,
                    ),
                    onChanged: (a) {
                      selectedTravelPreference = a;
                      setState(() {});
                    },
                    items: ['Morning', 'Afternoon', 'Night']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(value,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            )
        ],
      ),
    );
  }

  Widget item(a) =>
      regularText(a, fontSize: 13.sp, color: AppColors.primaryColor);

  Widget item2(int a, int type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          insured = a;
          setState(() {});
        },
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: a == type ? Color(0xffCDD3EA) : Colors.white,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: a != type ? AppColors.grey : Color(0xffCDD3EA),
                width: 1.h,
              )),
          child: regularText(
            a == 0 ? 'NO' : 'YES',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: a == type ? AppColors.black : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget item3(int a, int type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ownTruck = a;
          setState(() {});
        },
        child: Container(
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: a == type ? Color(0xffCDD3EA) : Colors.white,
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: a != type ? AppColors.grey : Color(0xffCDD3EA),
                width: 1.h,
              )),
          child: regularText(
            a == 0 ? 'NO' : 'YES',
            fontSize: 17.sp,
            textAlign: TextAlign.center,
            color: a == type ? AppColors.black : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  void addTruck() async {
    if (isLoading) {
      return;
    }
    if (selectedTruckType == null) {
      showSnackBar(context, null, 'Select Truck Type');
      return;
    }
    if (skidsCapacity == null) {
      showSnackBar(context, null, 'Enter Skids Capacity');
      return;
    }
    if (selectedTruckType == null) {
      showSnackBar(context, null, 'Enter Driving Experience!');
      return;
    }
    if (insured == null) {
      showSnackBar(context, null, 'Is Truck Insured?');
      return;
    }
    if (selectedTravelPreference == null) {
      showSnackBar(context, null, 'Select Travel Preference');
      return;
    }
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String id = Utils.randomString(no: 5) +
        DateTime.now().millisecondsSinceEpoch.toString();
    String uid = AppCache.getUser.uid;
    DocumentReference postRef =
        _firestore.collection('Truckers').doc('Added').collection(uid).doc(id);

    DocumentReference allTrucks = _firestore.collection('All-Truckers').doc(id);

    Map<String, dynamic> mData = Map();
    mData.putIfAbsent("id", () => id);
    mData.putIfAbsent("truck_type", () => selectedTruckType);
    mData.putIfAbsent("name", () => AppCache.getUser.name);
    mData.putIfAbsent("company_name", () => AppCache.getUser.companyName);
    mData.putIfAbsent("company_phone", () => AppCache.getUser.companyPhone);
    mData.putIfAbsent("address", () => AppCache.getUser.companyAddress);
    mData.putIfAbsent("uid", () => uid);
    mData.putIfAbsent("skids", () => skidsCapacity.text);
    mData.putIfAbsent("experience", () => drivingExperience.text);
    mData.putIfAbsent("is_insured", () => insured);
    mData.putIfAbsent("trips_number", () => 3);
    mData.putIfAbsent("travel_pref", () => selectedTravelPreference);
    mData.putIfAbsent(
        "updated_at", () => DateTime.now().millisecondsSinceEpoch);
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
        if (!widget.isAdd) {
          if (!hasLicense) {
            navigateReplacement(context, UploadDriverLicenceScreen());
          } else if (!hasCarrierDoc) {
            navigateReplacement(context, UploadCareerDocumentScreen());
          } else {
            Navigator.pop(context);
          }
        }
        setState(() {
          textListener.text = 'mama';
          mama = true;
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
