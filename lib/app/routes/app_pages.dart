import 'package:get/get.dart';
import 'package:kyzo/app/modules/login_view/bindings/login_screen_binding.dart';
import 'package:kyzo/app/modules/login_view/views/login_screen.dart';
import 'package:kyzo/app/modules/main_view/bindings/main_screen_binding.dart';
import 'package:kyzo/app/modules/main_view/views/main_screen.dart';
import 'package:kyzo/app/modules/register_view/bindings/register_screen_binding.dart';
import 'package:kyzo/app/modules/register_view/views/register_screen.dart';
import 'package:kyzo/app/modules/splash_view/bindings/splash_screen_binding.dart';
import 'package:kyzo/app/modules/splash_view/views/splash_screen.dart';
import 'package:kyzo/app/modules/username_image_view/bindings/username_image_binding.dart';
import 'package:kyzo/app/modules/username_image_view/views/username_image_screen.dart';
import 'app_routes.dart';

class AppPages
{
    static final routes = [
        GetPage(name: Routes.splash, page: () => SplashScreen(), binding: SplashScreenBinding()),
        GetPage(name: Routes.register, page: () => RegisterScreen(), binding: RegisterScreenBinding()),
        GetPage(name: Routes.login, page: () => LoginScreen(), binding: LoginScreenBinding()),
        GetPage(name: Routes.usernameImage, page: () => UsernameImageScreen(), binding: UsernameImageBinding()),
        GetPage(name: Routes.main, page: () => MainScreen(), binding: MainScreenBinding()),
    ];
}
