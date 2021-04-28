import 'package:get/get.dart';
import '../view/view.dart';

class AppPages {
  static const INITIAL = Routes.SIGNIN;

  static final routes = [
    GetPage(name: Routes.HOMEPAGE, page: () => TabScreen()),
    GetPage(name: Routes.USER_PROFILE, page: () => UserProfile()),
    GetPage(name: Routes.SIGNIN, page: () => SignIn()),
    GetPage(name: Routes.SIGNUP, page: () => SignUp()),
  ];
}

class Homepage {}

abstract class Routes {
  static const SIGNIN = '/signin';
  static const SIGNUP = '/signup';
  static const HOMEPAGE = '/homepage';
  static const USER_PROFILE = '/homepage';
}
