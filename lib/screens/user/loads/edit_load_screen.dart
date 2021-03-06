import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/load_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/user/home/get_address_view.dart';
import 'package:mms_app/screens/user/home/review_load_screen.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/custom_textfield.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class EditLoadScreen extends StatefulWidget {
  const EditLoadScreen({Key key, this.loadsModel}) : super(key: key);
  final LoadsModel loadsModel;

  @override
  _EditLoadScreenState createState() => _EditLoadScreenState();
}

class _EditLoadScreenState extends State<EditLoadScreen> {
  LoadsModel loadsModel;

  double sliderValue;

  TextEditingController title = TextEditingController();
  TextEditingController skids = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController pickup = TextEditingController();
  TextEditingController dropoff = TextEditingController();
  TextEditingController dateTime = TextEditingController();

  DateTime selectedDateTime;
  Prediction dropoffData, pickupData;

  String selectedTruckType = 'KG';

  @override
  void initState() {
    loadsModel = widget.loadsModel;
    title = TextEditingController(text: loadsModel.title);
    skids = TextEditingController(text: loadsModel.skids.toString());
    dropoff = TextEditingController(text: loadsModel.dropoff);
    pickup = TextEditingController(text: loadsModel.pickup);
    selectedDateTime = DateTime.fromMillisecondsSinceEpoch(loadsModel.dateTime);
    dateTime = TextEditingController(
        text: DateFormat('dd MMM, yyyy hh:mm a').format(selectedDateTime));
    title = TextEditingController(text: loadsModel.title);
    sliderValue = loadsModel.price.toDouble();

    if (loadsModel?.weight != null) {
      String aStr = loadsModel?.weight?.replaceAll(new RegExp(r'[^0-9]'), '');

      weight = TextEditingController(text: aStr);
      selectedTruckType = widget.loadsModel.weight.replaceAll(aStr, '');
      if(selectedTruckType.isEmpty){
        selectedTruckType = 'KG';
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppNotificationsWidget(),
            ],
          ),
          SizedBox(width: 30.h),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 6.h),
            child: regularText(
              'Edit Load',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.grey,
            ),
          ),
          ListView(
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
              item('Weight(Optional)'),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey, width: 1.h),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: weight,
                        style: GoogleFonts.inter(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                          letterSpacing: 0.4,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Input Weight',
                          hintStyle: GoogleFonts.inter(
                            color: AppColors.textGrey,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7c7c7c),
                      ),
                      isExpanded: false,
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
                      items: ['KG', 'LBS']
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
                    )
                  ],
                ),
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
                          setState(() {});
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
                          dropoff.text = dropoffData.description;
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
                      dateTime.text =
                          DateFormat('dd MMM, yyyy hh:mm a').format(date);
                      selectedDateTime = date;
                      setState(() {});
                    },
                    currentTime: selectedDateTime,
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
                  item('CA\$50-CA\$${sliderValue.toInt()}'),
                ],
              ),
              Slider(
                value: sliderValue,
                onChanged: (a) {
                  sliderValue = a;
                  setState(() {});
                },
                min: 50,
                label: '$sliderValue',
                max: 10000,
                activeColor: AppColors.primaryColor,
              ),
              SizedBox(height: 30.h),
              buttonWithBorder(
                'Update',
                buttonColor: AppColors.primaryColor,
                fontSize: 17.sp,
                height: 50.h,
                textColor: AppColors.white,
                fontWeight: FontWeight.w600,
                onTap: processPost,
              ),
            ],
          )
        ],
      ),
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
    if (int.tryParse(skids.text?.trim()) == null) {
      showSnackBar(context, null, 'Skids must be a number');
      return;
    }

    LoadsModel loadsModel = LoadsModel(
      id: widget.loadsModel.id,
      title: title.text,
      skids: int.tryParse(skids.text?.trim()),
      weight: weight.text.isEmpty ? '' : (weight.text + selectedTruckType),
      pickup: pickup.text,
      dropoff: dropoff.text,
      dateTime: selectedDateTime.millisecondsSinceEpoch,
      price: sliderValue.toInt(),
      name: AppCache.getUser.name,
      phone: AppCache.getUser.phone,
      image: AppCache.getUser.image,
    );
    navigateTo(
        context, ReviewLoadScreen(loadsModel: loadsModel, isUpdate: true));
  }
}
