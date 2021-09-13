import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
class FilterItem {
  bool showNearby;
  String truckType;
  int skidsCapacity;
  int radius;
  Position location;

  FilterItem(
      {this.truckType, this.skidsCapacity, this.radius, this.showNearby, this.location});
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key key, this.filterItem}) : super(key: key);

  final FilterItem filterItem;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool showNearby;

  int sliderValue1;

  int sliderValue2;

  String selectedTruckType;

  @override
  void initState() {
    showNearby = widget?.filterItem?.showNearby ?? false;
    sliderValue1 = widget?.filterItem?.skidsCapacity ?? 90;
    sliderValue2 = widget?.filterItem?.radius ?? 3;
    selectedTruckType = widget?.filterItem?.truckType;
    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

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
                fontWeight: FontWeight.w600, onTap: () {
              Navigator.pop(
                  context,
                  FilterItem(
                      showNearby: showNearby,
                      truckType: selectedTruckType,
                      skidsCapacity: sliderValue1,
                      radius: sliderValue2));
            }),
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
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
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
                    onChanged: (bool val) async{
                      showNearby = val;
                      if(val){
                        try{
                         Position pos = await _determinePosition();
                        }catch(e){
                          showSnackBar(context, 'Error', e);
                          print(e);
                        }

                      }
                      setState(() {});
                    }),
              ],
            ),
          ),
     if(showNearby)  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

         SizedBox(height: 10.h),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 25.h),
           child: regularText(
             'Radius',
             fontSize: 17.sp,
             fontWeight: FontWeight.w700,
             color: AppColors.primaryColor,
           ),
         ),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 10.h),
           child: Slider(
               value: sliderValue2.toDouble(),
               onChanged: (a) {
                 sliderValue2 = a.toInt();
                 setState(() {});
               },
               min: 3,
               label: '$sliderValue2',
               max: 100,
               activeColor: AppColors.primaryColor),
         ),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 30.h),
           child: regularText(
             'Radius $sliderValue2 KM',
             fontSize: 14.sp,
             color: AppColors.primaryColor,
           ),
         ),
       ],),
          SizedBox(height: 10.h),

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
              style:  GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: Color(0xFF7c7c7c),
              ),
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'Select truck type...',
                  style:  GoogleFonts.inter(
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
                if(a == 'None'){
                  selectedTruckType = null;
                }else{
                  selectedTruckType = a;
                }

                setState(() {});
              },
              items: [
                'None',
                'Flatbed trailer',
                'Reefer trailer',
                'Furniture Truck',
                'Tipper Truck',
                'Tankers',
                'Trailer Truck',
                'Box Truck',
                'Logging Truck',
                'Livestock Truck',
                'Cement Truck',
                'Carrier Trailer',
                'Boat Haulage Truck',
                'Dump Truck',
              ].map<DropdownMenuItem<String>>((String value) {
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
                value: sliderValue1.toDouble(),
                onChanged: (a) {
                  sliderValue1 = a.toInt();
                  setState(() {});
                },
                min: 5,
                label: '$sliderValue1',
                max: 100,
                activeColor: AppColors.primaryColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: regularText(
              '1 - $sliderValue1 Skids',
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
          ),

        ]));
  }
}
