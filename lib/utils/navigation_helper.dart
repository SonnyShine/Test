import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }

  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void pushAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (Route<dynamic> route) => false,
    );
  }
}