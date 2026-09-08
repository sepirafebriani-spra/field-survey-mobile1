import 'package:flutter_application_febri/screens/survey/dashboard.dart';
import 'package:flutter_application_febri/screens/survey/laporan_page.dart';
import 'package:go_router/go_router.dart';

import '../screens/survey/login_page.dart';
import '../screens/survey/register_page.dart';
import '../screens/survey/dashboard.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/survey/profil_page.dart';
import '../screens/survey/survey_page.dart';
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
      ),
      GoRoute(
        path: AppRoutes.profile, // gunakan AppRoutes biar konsisten
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.survey,
        builder: (context, state) => const SurveyPage(),
      ),
      GoRoute(
          path: AppRoutes.laporan,
          builder: (context, state) => const LaporanPage(),
        ),
    ],  
  );
}
