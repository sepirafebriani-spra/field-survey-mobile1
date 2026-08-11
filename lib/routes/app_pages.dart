import 'package:flutter_application_febri/dashboard/dashboard.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/dashboard.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/profile/profil_page.dart';
import 'app_routes.dart';

class AppPages {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
    //   ),
    //  GoRoute(
    //       path: '/profile',
    //       builder: (context, state) => const ProfilePage(),
        ),
    ],  
  );
}