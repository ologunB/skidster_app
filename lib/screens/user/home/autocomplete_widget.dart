import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'package:mms_app/app/size_config/extensions.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  PlacesAutocompleteWidget(
      {@required this.apiKey,
      this.offset,
      this.location,
      this.radius,
      this.language,
      this.sessionToken,
      this.types,
      this.components,
      this.strictbounds,
      this.region,
      this.onError,
      Key key,
      this.proxyBaseUrl,
      this.httpClient,
      this.startText,
      this.debounce = 300,
      this.selectPrediction})
      : super(key: key);

  final String apiKey;
  final String startText;
  final Location location;
  final num offset;
  final num radius;
  Function(Prediction) selectPrediction;
  final String language;
  final String sessionToken;
  final List<String> types;
  final List<Component> components;
  final bool strictbounds;
  final String region;
  final ValueChanged<PlacesAutocompleteResponse> onError;
  final int debounce;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;

  @override
  State<PlacesAutocompleteWidget> createState() =>
      _PlacesAutocompleteOverlayState();
}

bool showBody = false;

class _PlacesAutocompleteOverlayState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Column header = Column(children: <Widget>[
      Material(
          color: theme.dialogBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10.h),
                Expanded(child: _textField(context)),
                SizedBox(width: 10.h),
              ],
            ),
          )),
      const Divider()
    ]);

    Widget body;

    if (_searching) {
      body = Stack(
          children: <Widget>[_Loader()],
          alignment: FractionalOffset.bottomCenter);
    } else if (_queryTextController.text.isEmpty ||
        _response == null ||
        _response.predictions.isEmpty) {
      body = Material(color: theme.dialogBackgroundColor);
    } else {
      body = SingleChildScrollView(
        child: Material(
          color: theme.dialogBackgroundColor,
          child: showBody
              ? ListBody(
                  children: _response.predictions
                      .map(
                        (Prediction p) => LocationItem(
                            prediction: p,
                            onTap: (Prediction a) {
                              //  AppCache.addLocationHistory(a);
                              showBody = false;
                              widget.selectPrediction(a);
                              setState(() {});
                              Navigator.pop(context);
                            }),
                      )
                      .toList(),
                )
              : const SizedBox(),
        ),
      );
    }

    final Stack container = Stack(children: <Widget>[
      header,
      Padding(padding: const EdgeInsets.only(top: 60.0), child: body),
    ]);

    return container;
  }

  Widget _textField(BuildContext context) => TextField(
      controller: _queryTextController,
      autofocus: true,
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black87
              : null,
          fontSize: 16.0),
      maxLines: 1,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (String a) {
        showBody = true;
        setState(() {});
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        fillColor: AppColors.white,
        filled: true,
        labelStyle: GoogleFonts.nunito(
            color: AppColors.grey, fontWeight: FontWeight.w600, fontSize: 16),
        errorStyle: const TextStyle(color: Color(0xff222222)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff082485), width: 1.7)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey, width: 2)),
        border: const OutlineInputBorder(),
        counterText: '',
      ).copyWith(
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Enter Address',
          hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          suffix: _queryTextController.text.isEmpty
              ? SizedBox()
              : GestureDetector(
                  child: const Text(
                    'x',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onTap: () {
                    _queryTextController.clear();
                    Utils.offKeyboard();
                    setState(() {});
                  },
                )));
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        constraints: const BoxConstraints(maxHeight: 2.0),
        child: const LinearProgressIndicator());
  }
}

class PredictionsListView extends StatelessWidget {
  const PredictionsListView({Key key, @required this.predictions, this.onTap})
      : super(key: key);

  final List<Prediction> predictions;
  final ValueChanged<Prediction> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: predictions
          .map((Prediction p) => LocationItem(prediction: p, onTap: onTap))
          .toList(),
    );
  }
}

class LocationItem extends StatelessWidget {
  const LocationItem(
      {Key key, this.prediction, this.onTap, this.isHistory = false})
      : super(key: key);

  final Prediction prediction;
  final ValueChanged<Prediction> onTap;
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(prediction);
        }
      },
      child: Container(
        color: Colors.white,
        padding:   EdgeInsets.all(10.h),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.h),
                  border: Border.all(width: 1.h, color: AppColors.grey),
                  color: AppColors.white, ),
              child: Icon(
                isHistory ? Icons.history : Icons.location_on,
                color: AppColors.grey,
                size: 20,
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    string1Divider(prediction.description),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    string2Divider(prediction.description),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.grey),
                  ),
                  SizedBox(height: 10.h),
                  Divider(height: 0, color: AppColors.grey),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String string1Divider(String text) {
  return text.split(',')[0].trim();
}

String string2Divider(String text) {
  if (text.split(',').length < 2) {
    return text;
  }
  return text.split(',')[1].trim() +
      ((text.split(',').length > 2) ? ', ' + text.split(',')[2].trim() : '');
}

enum Mode { overlay, fullscreen }

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController _queryTextController;
  PlacesAutocompleteResponse _response;
  GoogleMapsPlaces _places;
  bool _searching;
  Timer _debounce;

  final BehaviorSubject<String> _queryBehavior =
      BehaviorSubject<String>.seeded('');

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: widget.startText);

    _places = GoogleMapsPlaces(
        apiKey: widget.apiKey,
        baseUrl: widget.proxyBaseUrl,
        httpClient: widget.httpClient);
    _searching = false;

    _queryTextController.addListener(_onQueryChange);

    _queryBehavior.stream.listen(doSearch);
  }

  Future<void> doSearch(String value) async {
    if (value != null) {
      if (mounted && value.isNotEmpty) {
        setState(() {
          _searching = true;
        });

        final PlacesAutocompleteResponse res = await _places.autocomplete(
          value,
          offset: widget.offset,
          location: widget.location,
          radius: widget.radius,
          language: widget.language,
          sessionToken: widget.sessionToken,
          types: widget.types ?? [],
          components: widget.components ?? [],
          strictbounds: widget.strictbounds ?? false,
          region: widget.region ?? "",
        );

        Logger().d(res.toJson());
        if (res.errorMessage?.isNotEmpty == true ||
            res.status == 'REQUEST_DENIED') {
          onResponseError(res);
        } else {
          onResponse(res);
        }
      } else {
        onResponse(null);
      }
    }
  }

  void _onQueryChange() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      if (!_queryBehavior.isClosed) {
        _queryBehavior.add(_queryTextController.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _places.dispose();
    _debounce.cancel();
    _queryBehavior.close();
    _queryTextController.removeListener(_onQueryChange);
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) {
      return;
    }

    if (widget.onError != null) {
      widget.onError(res);
    }
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse res) {
    if (!mounted) {
      return;
    }

    setState(() {
      _response = res;
      _searching = false;
    });
  }
}
