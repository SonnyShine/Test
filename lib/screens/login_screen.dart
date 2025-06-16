import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
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

  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final result = await DatabaseHelper().loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result['success']) {
        final user = result['user'];
        _showMessage(result['message'], isError: false);
      } else {
        _showMessage(result['message'], isError: true);
      }
    } catch (e) {
      _showMessage('Có lỗi xảy ra: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showMessage('Vui lòng nhập email!', isError: true);
      return false;
    }

    if (password.isEmpty) {
      _showMessage('Vui lòng nhập mật khẩu!', isError: true);
      return false;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Email không hợp lệ!', isError: true);
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[500],
            thickness: 1,
            endIndent: 8,
          ),
        ),
        Text('hoặc', style: TextStyle(color: Colors.grey[500])),
        Expanded(
          child: Divider(
            color: Colors.grey[500],
            thickness: 1,
            indent: 8,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UTC2Logo(
          welcomeTitle: 'Chào mừng trở lại',
          welcomeSubtitle: 'Đăng nhập vào tài khoản của bạn',
        ),
        Expanded(
          child: AuthScaffold(
            child: Column(
              children: [
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
                      Icon(Icons.vpn_key, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Quên mật khẩu?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                _buildDivider(),
                SizedBox(height: 8),
                Text(
                  'Chưa có tài khoản?',
                  style: TextStyle(color: Colors.grey[500]),
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
                        Icon(Icons.person_add, color: Colors.blue, size: 18),
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
          ),
        ),
      ],
    );
  }
}