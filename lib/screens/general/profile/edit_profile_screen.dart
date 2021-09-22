import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/show_exception_alert_dialog.dart';
import 'package:mms_app/screens/user/home/get_address_view.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController address;

  @override
  void initState() {
    Logger().d(AppCache.getUser.toJson());
    name = TextEditingController(text: AppCache.getUser.name.toTitleCase());
    email = TextEditingController(text: AppCache.getUser.email);
    phone = TextEditingController(text: AppCache.getUser.phone);
    if (AppCache.userType == UserType.TRUCKER) {
      address = TextEditingController(
          text: Utils.last2(AppCache.getUser.companyAddress));
    }
    imageUrl = AppCache.getUser.image;
    super.initState();
  }

  File imageFile;
  String imageUrl;

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
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                  height: 100.h,
                                  width: 100.h,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageUrl ?? 'm',
                                  height: 100.h,
                                  width: 100.h,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Image.asset(
                                    'images/placeholder.png',
                                    height: 100.h,
                                    width: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (BuildContext context,
                                          String url, dynamic error) =>
                                      Image.asset(
                                    'images/placeholder.png',
                                    height: 100.h,
                                    width: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                )),
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
                controller: name,
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
                readOnly: true,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
              item('Phone'),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter Phone',
                controller: phone,
                readOnly: true,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              if (AppCache.userType == UserType.TRUCKER)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    item('Address'),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hintText: 'Address',
                      obscureText: false,
                      controller: address,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      onTap: () async {
                        navigateTo(
                            context,
                            GetAddressView(
                              title: 'Select Address',
                              selectPrediction: (a) {
                                dropoffData = a;
                                Logger().d(a.toJson());
                                address.text =
                                    Utils.last2(dropoffData.description);
                                setState(() {});
                              },
                            ));
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              SizedBox(height: 40.h),
              buttonWithBorder(
                'SAVE CHANGES',
                buttonColor: AppColors.primaryColor,
                fontSize: 15.sp,
                height: 50.h,
                busy: isLoading,
                textColor: AppColors.white,
                fontWeight: FontWeight.w600,
                onTap: () {
                  uploadItem(context);
                },
              )
            ]));
  }

  Widget item(String a) {
    return regularText(a, fontSize: 13.sp, color: AppColors.primaryColor);
  }

  Prediction dropoffData;

  Future<void> getImageGallery() async {
    Utils.offKeyboard();
    final PickedFile result =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (result != null) {
      imageFile = File(result.path);
    } else {
      return;
    }
    setState(() {});
  }

  bool isLoading = false;

  void uploadItem(context) async {
    if (name.text.trim().isEmpty) {
      showSnackBar(context, 'Alert', 'Email cannot be empty');
      return;
    }
    if (phone.text.trim().isEmpty) {
      showSnackBar(context, 'Alert', 'Phone cannot be empty');
      return;
    }

    if (AppCache.userType == UserType.TRUCKER) {
      if (address.text.trim().isEmpty) {
        showSnackBar(context, 'Alert', 'Address cannot be empty');
        return;
      }
    }

    String uid = AppCache.getUser.uid;

    setState(() {
      isLoading = true;
    });
    Reference reference =
        FirebaseStorage.instance.ref().child("images/${Utils.randomString()}");

    double toLat, toLong;

    if (dropoffData != null) {
      PlacesDetailsResponse detail;
      GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Utils.googleMapKey);
      try {
        detail = await _places.getDetailsByPlaceId(dropoffData.placeId);
        Logger().d(detail.result.geometry.location.lat);
        Logger().d(detail.result.geometry.location.lng);
        toLat = detail.result.geometry.location.lat;
        toLong = detail.result.geometry.location.lng;
      } catch (e) {
        print(e);
        showSnackBar(context, 'Error', e);
        isLoading = false;
        setState(() {});
        return;
      }
    }

    try {
      String url = AppCache.getUser.image;
      if (imageFile != null) {
        UploadTask uploadTask = reference.putFile(imageFile);
        TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
        url = await downloadUrl.ref.getDownloadURL();
      }

      Map<String, dynamic> mData = AppCache.getUser.toJson();
      mData.update("name", (a) => name.text.trim());
      mData.update("company_address", (a) => address?.text?.trim());
      mData.update("phone", (a) => phone.text.trim());
      mData.update("email", (a) => email.text);
      //   mData.update("updated_at", (a) => DateTime.now().millisecondsSinceEpoch);
      mData.update("image", (a) => url, ifAbsent: () => url);
      if (toLat != null) {
        mData.update('_geoloc', (a) => {'lat': toLat, 'lng': toLong});
      }

      //   mData.putIfAbsent("company_name", () => companyName.text);
      //  mData.putIfAbsent("company_phone", () => companyPhone.text);
      //   mData.putIfAbsent("type", () => "trucker");
      //  mData.putIfAbsent("uid", () => user.uid);
      //   mData.putIfAbsent("plan", () => "free");

      FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .update(mData)
          .then((value) {
        setState(() {
          isLoading = false;
        });

        showSnackBar(context, 'Success', 'Profile has been updated');
        AppCache.setUser(mData);

        Map<String, dynamic> tData = AppCache.getUser.toJson();
        tData.putIfAbsent("name", () => name.text.trim());
        tData.putIfAbsent("address", () => address?.text?.trim());
        tData.putIfAbsent("phone", () => phone.text.trim());
        tData.putIfAbsent("image", () => AppCache.getUser.image);
        if (AppCache.userType == UserType.TRUCKER) {
          FirebaseFirestore.instance
              .collection('Truckers')
              .doc('Added')
              .collection(uid)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              print(element.id);
              FirebaseFirestore.instance
                  .collection('Truckers')
                  .doc('Added')
                  .collection(uid)
                  .doc(element.id)
                  .update(tData);
              FirebaseFirestore.instance
                  .collection('All-Truckers')
                  .doc(element.id)
                  .update(tData);
            });
          });
        } else {
          FirebaseFirestore.instance
              .collection('Loaders')
              .doc('Added')
              .collection(uid)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              print(element.id);
              FirebaseFirestore.instance
                  .collection('Loaders')
                  .doc('Added')
                  .collection(uid)
                  .doc(element.id)
                  .update(tData);
              FirebaseFirestore.instance
                  .collection('All-Loaders')
                  .doc(element.id)
                  .update(tData);
            });
          });
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
