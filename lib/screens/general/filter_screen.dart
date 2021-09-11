import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool showNearby = false;
  double sliderValue1 = 30;
  double sliderValue2 = 30;
  String selectedTruckType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 70.h,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.h),
          child: SafeArea(
            child: buttonWithBorder('Apply Filters',
                buttonColor: AppColors.primaryColor,
                fontSize: 17.sp,
                height: 50.h,
                textColor: AppColors.white,
                fontWeight: FontWeight.w600,
                onTap: () {}),
          ),
        ),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.h),
            child: regularText(
              'Filter',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: regularText(
              'Nearby',
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: Row(
              children: [
                Expanded(
                  child: regularText(
                    'Show Nearby',
                    fontSize: 17.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                Switch.adaptive(
                    inactiveTrackColor: Colors.grey.withOpacity(.5),
                    activeColor: AppColors.primaryColor,
                    value: showNearby,
                    onChanged: (bool val) {
                      showNearby = val;
                      setState(() {});
                    }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: Divider(),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: regularText(
              'Truck Type',
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.h),
                border: Border.all(
                  width: 1.h,
                  color: AppColors.textGrey,
                )),
            margin: EdgeInsets.symmetric(horizontal: 25.h),
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            height: 50.h,
            alignment: Alignment.center,
            child: DropdownButton<String>(
              style: TextStyle(
                fontFamily: "Gilroy",
                fontWeight: FontWeight.w400,
                color: Color(0xFF7c7c7c),
              ),
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'Select truck type...',
                  style: TextStyle(
                      color: Color(0xff7c7c7c),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
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
              items: ['Any', 'Trailer', 'Flatbed', 'Heavy duty']
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
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: regularText(
              'Skids Capacity',
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Slider(
                value: sliderValue1,
                onChanged: (a) {
                  sliderValue1 = a;
                  setState(() {});
                },
                min: 0,
                label: '$sliderValue1',
                max: 100,
                activeColor: AppColors.primaryColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: regularText(
              '0 kg - 500',
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            child: regularText(
              'Truck Type',
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Slider(
                value: sliderValue2,
                onChanged: (a) {
                  sliderValue2 = a;
                  setState(() {});
                },
                min: 1,
                label: '$sliderValue2',
                max: 100,
                activeColor: AppColors.primaryColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: regularText(
              'Radius ${sliderValue2.toInt()} KM',
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ]));
  }
}
