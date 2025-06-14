import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/utc2_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng nhập thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  bool _validateForm() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          SizedBox(height: 80),
          UTC2Logo(),
          SizedBox(height: 20),
          Text(
            'Chào mừng trở lại',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Đăng nhập vào tài khoản của bạn',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 60),
          CustomTextField(
            hintText: 'Email',
            prefixIcon: Icons.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextField(
            hintText: 'Mật khẩu',
            prefixIcon: Icons.lock,
            controller: _passwordController,
            isPassword: true,
          ),
          SizedBox(height: 24),
          CustomButton(
            text: 'Đăng nhập',
            icon: Icons.login,
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => NavigationHelper.navigateToForgotPassword(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.vpn_key,
                  color: Colors.blue,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Colors.blue,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[500]!,
                  thickness: 1,
                  endIndent: 8,
                ),
              ),
              Text(
                'hoặc',
                style: TextStyle(color: Colors.grey[500]!),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[500]!,
                  thickness: 1,
                  indent: 8,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Chưa có tài khoản?',
            style: TextStyle(color: Colors.grey[500]!),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () => NavigationHelper.navigateToRegister(context),
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Đăng ký ngay',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}