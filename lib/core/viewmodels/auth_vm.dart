import 'dart:io';

import 'package:mms_app/core/api/auth_api.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';

import '../../locator.dart';
import 'base_vm.dart';

class AuthViewModel extends BaseModel {


  void showDialog(CustomException e) {
    dialog.showDialog(
        title: 'Error', description: e.message, buttonTitle: 'Close');
  }
}
