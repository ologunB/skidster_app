import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/storage/local_storage.dart';

class BaseAPI {
  Dio dio = Dio(BaseOptions(
      sendTimeout: 30000,
      receiveTimeout: 30000,
      contentType: 'application/json',
      validateStatus: (int s) => s < 500));

  // base_url test_base_url
  String baseUrl = GlobalConfiguration().getString('test_base_url');
  String ytKey = GlobalConfiguration().getString('yt_key');

  Options defaultOptions = Options(
      sendTimeout: 20000, // 20 seconds
      receiveTimeout: 20000, // 20 seconds
      contentType: 'application/json',
      validateStatus: (int s) => s < 500);

  String getToken() {
    String token = '';
    return token;
  }

  LoginData getUser() {
    LoginData user = AppCache.getUser;
    // print(AppCache.getUser.toJson());
    return user;
  }
}
