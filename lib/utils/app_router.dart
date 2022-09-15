import 'package:flutter/material.dart';
import 'package:kophecy/screens/home_screen.dart';
import 'package:kophecy/screens/login_screen.dart';
import 'package:kophecy/screens/main_screen.dart';
import 'package:kophecy/screens/onboarding_screen.dart';
import 'package:kophecy/screens/register_screen.dart';
import 'package:kophecy/screens/splash_screen.dart';

const String splash = '/splash';
const String onBoarding = '/onboarding';
const String home = '/home';
const String login = '/login';
const String register = '/register';
const String landing = '/main';
const String auth = '/auth';

Map<String, WidgetBuilder> appRoutes = {
  splash: (context) => const SplashScreen(
        key: ValueKey("a"),
      ),
  onBoarding: (context) => const OnboardingScreen(
        key: ValueKey("b"),
      ),
  home: (context) => const HomeScreen(
        key: ValueKey("c"),
      ),
  login: (context) => const LoginScreen(
        key: ValueKey("d"),
      ),
  register: (context) => const RegisterScreen(
        key: ValueKey("f"),
      ),
  landing: (context) => const MainScreen(
        key: ValueKey("g"),
      ),
};
