import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Colors.grey[500]!,
          //     Colors.grey[700]!,
          //   ],
          // ),
          color: Colors.grey[300],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}