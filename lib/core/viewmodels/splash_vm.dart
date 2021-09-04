import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';

import 'base_vm.dart';

class SplashViewModel extends BaseModel {
  Future<void> isLoggedIn() async {
    final UserData loginData = AppCache.getUser;
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (loginData == null) {
        navigate.navigateToReplacing(LoginView);
      } else {
        navigate.navigateToReplacing(LayoutScreen);
      }
    });
  }
}
