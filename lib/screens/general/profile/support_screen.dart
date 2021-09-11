import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
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
              CustomTextField(
                controller: idController,
                hintText: 'Load ID',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                maxLines: 1,
              ),
              SizedBox(height: 18.h),
              CustomTextField(
                controller: controller,
                hintText: 'What is wrong?',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 6,
              ),
              SizedBox(height: 40.h),
              buttonWithBorder('Send feedback',
                  textColor: AppColors.white,
                  buttonColor: AppColors.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  height: 50.h, onTap: () {
                if (controller.text.isEmpty) {
                  return;
                }
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                String uid = FirebaseAuth.instance.currentUser.uid;
                String id = Utils.randomString(no: 5) +
                    DateTime.now().millisecondsSinceEpoch.toString();

                Map<String, dynamic> mData = Map();
                mData.putIfAbsent("id", () => id);
                mData.putIfAbsent("load_id", () => idController.text);
                mData.putIfAbsent("uid", () => uid);
                mData.putIfAbsent("text", () => controller.text);
                mData.putIfAbsent(
                    "updated_at", () => DateTime.now().millisecondsSinceEpoch);

                _firestore
                    .collection('Support')
                    .doc('Unattended')
                    .collection('Unattended')
                    .doc(id)
                    .set(mData)
                    .then((value) {});
                controller.text = '';
                showSnackBar(
                    context, 'Thanks', 'Your message will be responded to');
              })
            ]));
  }
}
