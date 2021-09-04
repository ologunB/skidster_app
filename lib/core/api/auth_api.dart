import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/constants.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';
import 'package:mms_app/core/utils/error_util.dart';

import 'base_api.dart';

class AuthApi extends BaseAPI {
  Logger log = Logger();

  Future<UserData> login(Map<String, String> data) async {
    final String url = '$baseUrl/auth/login';
    try {
      final Response<dynamic> res =
          await dio.post<dynamic>(url, data: data, options: defaultOptions);

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return UserData();
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        case REQUEST_CANNOT_BE_PROCESSED:
          throw res.data['message'].first.toString().toUpperCase();
          break;
        case WRONG_CREDENTIALS:
          throw CREDENTIALS_ARE_WRONG;
          break;
        case POORLY_FORMATTED_REQUEST:
          throw res.data['message'].first;
        case RESOURCE_NOT_FOUND:
          throw UNKNOWN_USER;
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);

      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

}
