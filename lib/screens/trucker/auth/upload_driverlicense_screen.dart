import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/trucker/auth/upload_carierdocs_screen.dart';
import 'package:mms_app/screens/trucker/trucker_main_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'dart:io';

import 'package:mms_app/screens/widgets/utils.dart';

class UploadDriverLicenceScreen extends StatefulWidget {
  const UploadDriverLicenceScreen({Key key}) : super(key: key);

  @override
  _UploadDriverLicenceScreenState createState() =>
      _UploadDriverLicenceScreenState();
}

class _UploadDriverLicenceScreenState extends State<UploadDriverLicenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
        child: SafeArea(
          child: buttonWithBorder(file != null ? 'Upload' : 'Do It Later',
              buttonColor: AppColors.primaryColor,
              fontSize: 17.sp,
              height: 50.h,
              busy: isLoading,
              textColor: AppColors.white,
              fontWeight: FontWeight.w600, onTap: () {
            if (file != null) {
              uploadItem();
            } else {
              Navigator.pop(context);
            }
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Upload Your\nDriver License',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          regularText(
            'For security and safety reasons,\nwe require all truckers to verify their\nidentity',
            fontSize: 15.sp,
            color: AppColors.textGrey.withOpacity(.7),
          ),
          SizedBox(height: 30.h),
          Image.asset('images/upload1.png', width: 311.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: regularText('Upload File',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.center,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (file != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: Image.file(
                    file,
                    height: 100.h,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  File file;

  Future<void> getImageGallery() async {
    final PickedFile result =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (result != null) {
      file = File(result.path);
    } else {
      return;
    }
    setState(() {});
  }

  bool isLoading = false;

  void uploadItem() async {
    String uid = AppCache.getUser.uid;

    setState(() {
      isLoading = true;
    });
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("driver_licenses/${Utils.randomString()}");

    try {
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
      String url = await downloadUrl.ref.getDownloadURL();

      Map<String, dynamic> mData = Map();
      mData.putIfAbsent("driver_license", () => url);

      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .update(mData)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (!hasCarrierDoc) {
          navigateReplacement(context, UploadCareerDocumentScreen());
        } else {
          Navigator.pop(context);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        showExceptionAlertDialog(
            context: context, exception: e, title: "Error");
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
    }
  }
}
