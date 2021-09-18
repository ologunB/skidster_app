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

class CreateSupportScreen extends StatefulWidget {
  @override
  _CreateSupportScreenState createState() => _CreateSupportScreenState();
}

class _CreateSupportScreenState extends State<CreateSupportScreen> {
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
                'Create Ticket',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
              CustomTextField(
                controller: idController,
                hintText: 'Load/Truck ID',
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
                  busy: isLoading,
                  fontWeight: FontWeight.w700,
                  height: 50.h, onTap: () async {
                if (controller.text.isEmpty) {
                  return;
                }

                try {
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  String uid = AppCache.getUser.uid;
                  String id = Utils.randomString(no: 5) +
                      DateTime.now().millisecondsSinceEpoch.toString();

                  Map<String, dynamic> mData = Map();
                  mData.putIfAbsent("id", () => id);
                  mData.putIfAbsent("load_id", () => idController.text);
                  mData.putIfAbsent("uid", () => uid);
                  mData.putIfAbsent("status", () => 'pending');
                  mData.putIfAbsent("desc", () => controller.text);
                  mData.putIfAbsent("from", () => AppCache.getUser.name);
                  mData.putIfAbsent("updated_at",
                      () => DateTime.now().millisecondsSinceEpoch);

                  DocumentReference admin =
                      _firestore.collection('All-Supports').doc(id);
                  DocumentReference user = _firestore
                      .collection('Support')
                      .doc('Added')
                      .collection(AppCache.getUser.uid)
                      .doc(id);
                  WriteBatch writeBatch = _firestore.batch();
                  writeBatch.set(admin, mData);
                  writeBatch.set(user, mData);
                  await writeBatch.commit();
                  isLoading = false;
                  setState(() {});
                  controller.text = '';
                  idController.text = '';
                  showSnackBar(
                      context, 'Thanks', 'Your message will be responded to');
                } on FirebaseAuthException catch (e) {
                  showSnackBar(context, 'Error', e.message);
                  isLoading = false;
                  setState(() {});
                } catch (e) {
                  showSnackBar(context, 'Error', e.toString());
                  isLoading = false;
                  setState(() {});
                }
              })
            ]));
  }

  bool isLoading = false;
}
