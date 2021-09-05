import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

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
                'Edit your Profile',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.h),
                        child: Image.asset(
                          'images/placeholder.png',
                          height: 100.h,
                          width: 100.h,
                        ),
                      ),
                      Positioned(
                          bottom: -10.h,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  getImageGallery();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6.h),
                                      border: Border.all(
                                          color: AppColors.white, width: 1.h)),
                                  child: Icon(Icons.camera_alt_outlined,
                                      color: AppColors.white, size: 18.h),
                                ),
                              )
                            ],
                          )),
                    ],
                  )
                ],
              ),
              SizedBox(height: 18.h),
              item('Name'),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter name',
                controller: phone,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 16.h),
              item('Email'),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Your Email',
                validator: Utils.validateEmail,
                obscureText: false,
                controller: email,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
              item('Phone'),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter Phone',
                controller: phone,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 40.h),
              buttonWithBorder('SAVE CHANGES',
                  buttonColor: AppColors.primaryColor,
                  fontSize: 15.sp,
                  height: 50.h,
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w600,
                  onTap: () {})
            ]));
  }

  Widget item(String a) {
    return regularText(a, fontSize: 13.sp, color: AppColors.primaryColor);
  }

  Future<void> getImageGallery() async {
    Utils.offKeyboard();
    final PickedFile result =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (result != null) {
    } else {
      return;
    }
    setState(() {});
  }
}
