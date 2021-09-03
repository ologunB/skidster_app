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

  Future<LoginData> login(Map<String, String> data) async {
    final String url = '$baseUrl/auth/login';
    try {
      final Response<dynamic> res =
          await dio.post<dynamic>(url, data: data, options: defaultOptions);

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return LoginResponse.fromJson(res.data).data;
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

  Future<LoginData> getProfile() async {
    final String url = '$baseUrl/users/me';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return LoginResponse.fromJson(res.data).data;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
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

  Future<bool> resetPassword(String email) async {
    final String url = '$baseUrl/auth/forgot-password';
    try {
      final Response<dynamic> res = await dio.post<dynamic>(url,
          data: {"email": email}, options: defaultOptions);

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> changePassword(String old, String newOne) async {
    final String url = '$baseUrl/auth/change-password';
    try {
      final Response<dynamic> res = await dio.post<dynamic>(url,
          data: {"otp": old, "newPassword": newOne}, options: defaultOptions);

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> updateDeviceToken(String token) async {
    final String url = '$baseUrl/device-tokens/update';
    try {
      final Response<dynamic> res = await dio.put<dynamic>(url,
          data: {"token": token},
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          return false;
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> logout() async {
    final String url = '$baseUrl/auth/logout';
    try {
      final Response<dynamic> res = await dio.delete<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));
      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          return false;
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> deleteUser() async {
    final String url = '$baseUrl/users/${AppCache.getUser.id}';
    try {
      final Response<dynamic> res = await dio.delete<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));
      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          return false;
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> editProfile(Map<String, dynamic> data) async {
    log.d(data);
    final String url = '$baseUrl/users/update-profile-info';
    try {
      final Response<dynamic> res = await dio.put<dynamic>(url,
          data: data,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));
      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<bool> addProfilePhoto(List<File> images) async {
    final FormData formData = FormData();

    for (final File image in images) {
      formData.files.add(MapEntry<String, MultipartFile>(
          'picture',
          MultipartFile.fromFileSync(image.path,
              filename: image.path.split('/').last)));
    }

    try {
      final Response<dynamic> res = await dio.put<dynamic>(
        '$baseUrl/users/update-profile-picture/',
        data: formData,
        options: Options(
            contentType: 'application/json',
            followRedirects: true,
            // will not throw errors
            validateStatus: (int status) => status < 500,
            headers: <String, String>{'Authorization': 'Bearer ${getToken()}'}),
        onSendProgress: (int sent, int total) {
          final double progress = (sent * 100) / total;
          print('progress: $progress ($sent/$total)');
        },
      );

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          return true;
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      log.d(e);
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }

  Future<List<UserLocation>> searchLocation(String a) async {
    final String url = '$baseUrl/users/locations/search?searchTerm=$a';
    try {
      final Response<dynamic> res = await dio.get<dynamic>(url,
          options: defaultOptions.copyWith(headers: <String, String>{
            'Authorization': 'Bearer ${getToken()}'
          }));

      log.d(res.data);
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<UserLocation> list = [];
            res.data['data'].forEach((a) {
              list.add(UserLocation.fromJson(a));
            });
            return list;
          } catch (e) {
            throw PARSING_ERROR;
          }
          break;
        default:
          throw res.data['message'].first ?? 'Unknown Error';
      }
    } catch (e) {
      throw CustomException(DioErrorUtil.handleError(e));
    }
  }
}
