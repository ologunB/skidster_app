import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import 'fdottedline.dart';

class MySeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FDottedLine(
      color: AppColors.primaryColor,
      width: 1.5.h,
      strokeWidth: 1.2.h,
      space: 3.h,
    );
  }
}
