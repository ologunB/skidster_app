import 'package:flutter/material.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/viewmodels/base_vm.dart';

class OnboardingViewModel extends BaseModel {
  int _index = 0;

  int get index => _index;
  PageController _controller;

  PageController controller() {
    _controller = PageController(keepPage: true, initialPage: _index);
    return _controller;
  }

  void onChanged(int index) {
    _index = index;
    notifyListeners();
  }

  void nextPage() {
    _controller.nextPage(duration: Duration(milliseconds: 1200), curve: Curves.ease);
  }

  void navigateToLoginView() {
    navigate.navigateToReplacing(LoginView);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
