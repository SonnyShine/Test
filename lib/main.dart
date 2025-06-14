import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';

void main() {
  runApp(UTC2App());
}

class UTC2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTC2 Auth',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}