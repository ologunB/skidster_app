import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/user/home/get_address_view.dart';
import 'package:mms_app/screens/user/home/review_load_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class PostLoadWidget extends StatefulWidget {
  const PostLoadWidget({Key key}) : super(key: key);

  @override
  _PostLoadWidgetState createState() => _PostLoadWidgetState();
}

class _PostLoadWidgetState extends State<PostLoadWidget> {
  double sliderValue = 400;

  TextEditingController title = TextEditingController();
  TextEditingController skids = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController dropoff = TextEditingController();
  TextEditingController dateTime = TextEditingController();

  DateTime selectedDateTime;
  Prediction dropoffData, pickupData;

  @override
  Widget build(_) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(20.h),
      children: [
        item('What are you shipping'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter what are you shipping',
          obscureText: false,
          controller: title,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('How many skids'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Input skids',
          obscureText: false,
          controller: skids,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Weight'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Input Weight - kg/lbs',
          obscureText: false,
          controller: weight,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Pickup Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Pickup Address',
          obscureText: false,
          controller: pickup,
          readOnly: true,
          onTap: () async {
            navigateTo(
                context,
                GetAddressView(
                  title: 'Pickup Address',
                  selectPrediction: (a) {
                    pickupData = a;
                    pickup.text = pickupData.description;
                  },
                ));
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Dropoff Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Dropoff Address',
          obscureText: false,
          controller: dropoff,
          readOnly: true,
          onTap: () {
            navigateTo(
                context,
                GetAddressView(
                  title: 'Dropoff Address',
                  selectPrediction: (a) {
                    dropoffData = a;
                    pickup.text = dropoffData.description;
                    Logger().d(dropoffData);
                    setState(() {});
                  },
                ));
          },
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Date and Time'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Date and Time',
          obscureText: false,
          readOnly: true,
          controller: dateTime,
          onTap: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime.now().add(Duration(days: 10)),
              onChanged: (date) {},
              onConfirm: (date) {
                dateTime.text = DateFormat('dd MMM, yyyy hh:mm a').format(date);
                selectedDateTime = date;
                setState(() {});
              },
              currentTime: DateTime.now(),
              locale: LocaleType.en,
            );
          },
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            item('Price Range'),
            Spacer(),
            item('\$0-\$${sliderValue.toInt()}'),
          ],
        ),
        Slider(
            value: sliderValue,
            onChanged: (a) {
              sliderValue = a;
              setState(() {});
            },
            min: 100,
            label: '$sliderValue',
            max: 10000,
            activeColor: AppColors.primaryColor),
        SizedBox(height: 30.h),
        buttonWithBorder(
          'Continue',
          buttonColor: AppColors.primaryColor,
          fontSize: 17.sp,
          height: 50.h,
          textColor: AppColors.white,
          fontWeight: FontWeight.w600,
          onTap: processPost,
        ),
      ],
    );
  }

  Widget item(String a) {
    return regularText(
      a,
      fontSize: 13.sp,
      color: AppColors.primaryColor,
    );
  }

  processPost() {
    if (selectedDateTime == null) {
      showSnackBar(context, null, 'Select Date and Time');
      return;
    }
    if (title.text.isEmpty) {
      showSnackBar(context, null, 'Enter Title');
      return;
    }

    if (skids.text.isEmpty) {
      showSnackBar(context, null, 'Enter skids');
      return;
    }
    if (pickup.text.isEmpty) {
      showSnackBar(context, null, 'Enter pickup');
      return;
    }
    if (dropoff.text.isEmpty) {
      showSnackBar(context, null, 'Enter dropoff');
      return;
    }

    LoadsModel loadsModel = LoadsModel(
      title: title.text,
      skids: skids.text,
      weight: weight.text.isEmpty ? '' : weight.text,
      pickup: pickup.text,
      dropoff: dropoff.text,
      dateTime: selectedDateTime.millisecondsSinceEpoch,
      price: sliderValue.toInt(),
      name: AppCache.getUser.name,
      phone: AppCache.getUser.phone,
    );
    navigateTo(context, ReviewLoadScreen(loadsModel: loadsModel));
  }
}
