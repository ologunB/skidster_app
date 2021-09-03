import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/api/auth_api.dart';
import 'core/utils/dialog_service.dart';
import 'core/utils/navigator.dart';
import 'core/viewmodels/auth_vm.dart';
import 'core/viewmodels/onboard_vm.dart';
import 'core/viewmodels/splash_vm.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  locator.registerFactory(() => SplashViewModel());
  locator.registerFactory(() => OnboardingViewModel());

  locator.registerLazySingleton(() => AuthApi());
  locator.registerFactory(() => AuthViewModel());
}

final List<SingleChildWidget> allProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
  ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel()),
];
