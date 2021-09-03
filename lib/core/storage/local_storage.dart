import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mms_app/core/models/login_response.dart';

const String kUserBox = 'userBox';
const String profileKey = 'profile';
const String isFirstKey = 'isTheFirst';

class AppCache {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(kUserBox);
  }

  static Box<dynamic> get _userBox => Hive.box<dynamic>(kUserBox);

  static void haveFirstView(bool t) {
    if (isFirstKey == null) {
      return;
    }
    _userBox.put(isFirstKey, t);
  }

  static bool getIsFirst() {
    final bool data = _userBox.get(isFirstKey, defaultValue: true);
    return data;
  }

  static void setUser(LoginData user) {
    _userBox.put(profileKey, user.toJson());
  }

  static LoginData get getUser {
    final dynamic data = _userBox.get(profileKey);
    if (data == null) {
      return null;
    }
    final LoginData user = LoginData.fromJson(data);
    return user;
  }

  static Future<void> clear() async {
    await _userBox.clear();
  }

  static void clean(String key) {
    _userBox.delete(key);
  }

}
