import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/snackbar.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'autocomplete_widget.dart';

class GetAddressView extends StatefulWidget {
  const GetAddressView({Key key, this.title, this.selectPrediction})
      : super(key: key);

  final String title;
  final Function(Prediction) selectPrediction;

  @override
  _GetAddressViewState createState() => _GetAddressViewState();
}

class _GetAddressViewState extends State<GetAddressView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: regularText(widget.title,
            fontSize: 16.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600),
      ),
      body:  PlacesAutocompleteWidget(
        language: 'EN',
        selectPrediction: widget.selectPrediction,
        onError: (PlacesAutocompleteResponse response) {
          showSnackBar(context, 'Error', response.errorMessage,
              duration: 3);
        },
        apiKey: Utils.googleMapKey,
        components: <Component>[Component(Component.country, 'CA')],
      ),
    );
  }
}
