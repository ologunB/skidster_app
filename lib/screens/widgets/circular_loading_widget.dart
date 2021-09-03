import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';

class CircularLoadingWidget extends StatefulWidget {
  final double height;

  CircularLoadingWidget({Key key, this.height}) : super(key: key);

  @override
  _CircularLoadingWidgetState createState() => _CircularLoadingWidgetState();
}

class _CircularLoadingWidgetState extends State<CircularLoadingWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween<double>(begin: widget.height, end: 0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    Timer(Duration(seconds: 10), () {
      if (mounted) {
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value / 100 > 1.0 ? 1.0 : animation.value / 100,
      child: SizedBox(
        height: animation.value,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.primaryColor,
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.white.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }
}
