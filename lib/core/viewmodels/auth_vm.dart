import 'dart:io';

import 'package:mms_app/core/api/auth_api.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/core/utils/custom_exception.dart';

import '../../locator.dart';
import 'base_vm.dart';

class AuthViewModel extends BaseModel {
  final AuthApi _authApi = locator<AuthApi>();
  LoginData userModel;
  String error;
  String otp;

  void setOTP(String value) {
    otp = value;
    notifyListeners();
  }

  Future<void> login(Map<String, String> data) async {
    setBusy(true);
    try {
      userModel = await _authApi.login(data);
      AppCache.setUser(userModel);
      setBusy(false);
      navigate.navigateToReplacing(LayoutScreen);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> resetPassword(String data) async {
    setBusy(true);
    try {
      await _authApi.resetPassword(data);
      setBusy(false);
      navigate.navigateTo(ConfirmOTPScreen);
      dialog.showDialog(
        title: 'Success',
        description: 'OTP has been sent to email address',
        buttonTitle: 'Close',
      );
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> confirmOtp() async {
    navigate.navigateTo(ChangePasswordScreen);
  }

  Future<void> changePassword(String old, String newOne) async {
    setBusy(true);
    try {
      await _authApi.changePassword(old, newOne);
      setBusy(false);
      navigate.navigateToReplacing(LoginView);
      dialog.showDialog(
        title: 'Success',
        description:
            'You have successfully changed your password, please do log back in',
        buttonTitle: 'Close',
      );
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }



  Future<void> editProfile(Map<String, dynamic> data) async {
    setBusy(true);
    try {
      await _authApi.editProfile(data);
      setBusy(false);
      dialog.showDialog(
          title: 'Success',
          description: 'Profile updated successfully',
          buttonTitle: 'Close');
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> addPicture(File image) async {
    setBusy(true);
    try {
      await _authApi.addProfilePhoto([image]);
      setBusy(false);
      dialog.showDialog(
          title: 'Success',
          description: 'Profile Picture updated successfully',
          buttonTitle: 'Close');
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> getProfile() async {
    setBusy(true);
    try {
      userModel = await _authApi.getProfile();
      AppCache.setUser(userModel);
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> deleteUser({String reason}) async {
    setBusy(true);
    try {
      await _authApi.deleteUser();
      AppCache.clear();
      dialog.showDialog(
          title: 'Success',
          description: 'You have been deleted from the Church.',
          buttonTitle: 'Close');
      navigate.navigateToReplacing(LoginView);
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      showDialog(e);
    }
  }

  Future<void> logout() async {
    setBusy(true);
    try {
      await _authApi.logout();
      AppCache.clear();
      navigate.navigateToReplacing(LoginView);
      setBusy(false);
    } on CustomException catch (e) {
      setBusy(false);
      showDialog(e);
    }
  }

  List<UserLocation> allLocs = [];

  Future<void> searchLocation(String a) async {
    if (a.isEmpty) return;
    setBusy(true);
    try {
      allLocs = await _authApi.searchLocation(a);
      setBusy(false);
    } on CustomException catch (e) {
      error = e.message;
      setBusy(false);
    }
  }

  void showDialog(CustomException e) {
    dialog.showDialog(
        title: 'Error', description: e.message, buttonTitle: 'Close');
  }
}
