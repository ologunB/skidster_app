import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'dart:io';

class UploadCareerDocumentScreen extends StatefulWidget {
  const UploadCareerDocumentScreen({Key key}) : super(key: key);

  @override
  _UploadCareerDocumentScreenState createState() =>
      _UploadCareerDocumentScreenState();
}

class _UploadCareerDocumentScreenState
    extends State<UploadCareerDocumentScreen> {
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
            }
          }),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.h),
        children: [
          regularText(
            'Upload\nCarrier Document',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 30.h),
          Image.asset('images/upload2.png', width: 311.h),
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
    String uid = FirebaseAuth.instance.currentUser.uid;

    setState(() {
      isLoading = true;
    });
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("carrier_docs/${Utils.randomString()}");

    try {
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
      String url = await downloadUrl.ref.getDownloadURL();

      Map<String, dynamic> mData = Map();
      mData.putIfAbsent("carrier_doc", () => url);

      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .update(mData)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
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
