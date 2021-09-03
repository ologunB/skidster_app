import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final image;

  ImageWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.contain,
      //  height: SizeConfig.screenHeight,
      //   width: SizeConfig.screenWidth,
    );
  }
}
