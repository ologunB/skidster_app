import 'package:flutter/material.dart';

import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/user/home/review_load_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';

class PostLoadWidget extends StatefulWidget {
  const PostLoadWidget({Key key}) : super(key: key);

  @override
  _PostLoadWidgetState createState() => _PostLoadWidgetState();
}

class _PostLoadWidgetState extends State<PostLoadWidget> {
  double sliderValue = 30;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(20.h),
      children: [
        item('What are you shipping'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter what are you shipping',
          validator: Utils.isValidName,
          obscureText: false,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('What are you shipping'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter what are you shipping',
          obscureText: false,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('How many skids'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Input skids ',
          obscureText: false,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Weight'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Input Weight',
          obscureText: false,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Pickup Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Pickup Address',
          obscureText: false,
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Dropoff Address'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Dropoff Address',
          obscureText: false,
          textInputType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 16.h),
        item('Date and Time'),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'Enter Date and Time',
          obscureText: false,
          readOnly: true,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            item('Price Range'),
            Spacer(),
            item('\$100-\$10,000'),
          ],
        ),
        Slider(
            value: sliderValue,
            onChanged: (a) {
              sliderValue = a;
              setState(() {});
            },
            min: 0,
            label: '$sliderValue',
            max: 100,
            activeColor: AppColors.primaryColor),
        SizedBox(height: 30.h),
        buttonWithBorder('Continue',
            buttonColor: AppColors.primaryColor,
            fontSize: 17.sp,
            height: 50.h,
            textColor: AppColors.white,
            fontWeight: FontWeight.w600, onTap: () {
          navigateTo(context, ReviewLoadScreen());
        }),
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
}
