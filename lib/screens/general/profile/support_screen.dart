import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/support_model.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_loader.dart';
import 'package:mms_app/screens/widgets/error_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

import 'create_support_screen.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController idController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 30.h),
          child: FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                navigateTo(context, CreateSupportScreen());
              }),
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            children: [
              regularText(
                'Contact Support',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Support')
                      .doc('Added')
                      .collection(AppCache.getUser.uid)
                      .orderBy('updated_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomLoader();
                    } else if (snapshot.hasError) {
                      ErrorOccurredWidget(error: snapshot.error);
                    } else if (snapshot.hasData) {
                      List<SupportModel> myTrucks = [];

                      snapshot.data.docs.forEach((element) {
                        SupportModel model =
                            SupportModel.fromJson(element.data());
                        //  Logger().d(model.toJson());

                        myTrucks.add(model);
                      });
                      return myTrucks.isEmpty
                          ? AppEmptyWidget(text: 'Tickets tray is Empty')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: myTrucks.length,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                SupportModel model = myTrucks[index];
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
                                                        'Are you sure you want\nto delete the ticket?',
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
                                        model.desc ?? '',
                                        fontSize: 15.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(height: 10.h),
                                      if (model.reply != null)
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Reply: ',
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${model.reply}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.textGrey,
                                            ),
                                          )
                                        ])),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          item1(model.status.toTitleCase()),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                    }
                    return Container();
                  })
            ]));
  }

  Widget item1(String a) {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
      decoration: BoxDecoration(
          color: a.contains("Resolved")
              ? Colors.green
              : AppColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(6.h)),
      child: regularText(
        a,
        fontSize: 11.sp,
        color: a.contains("Resolved") ? Colors.white : AppColors.primaryColor,
      ),
    );
  }

  void delete(String id, BuildContext context) async {
    DocumentReference admin = _firestore.collection('All-Supports').doc(id);
    DocumentReference user = _firestore
        .collection('Support')
        .doc('Added')
        .collection(AppCache.getUser.uid)
        .doc(id);
    WriteBatch writeBatch = _firestore.batch();
    writeBatch.delete(admin);
    writeBatch.delete(user);
    await writeBatch.commit();
    Navigator.pop(context);
  }
}
