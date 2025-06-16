import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../utils/email_service.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/utc2_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/navigation_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập email!', isError: true);
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showMessage('Email không hợp lệ!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();

      // Kiểm tra user tồn tại
      final user = await DatabaseHelper().getUserByEmail(email);
      if (user == null) {
        _showMessage('Email không tồn tại trong hệ thống!', isError: true);
        return;
      }

      // Tạo và cập nhật mật khẩu mới
      final newPassword = EmailService.generateRandomPassword(length: 8);
      final resetResult = await DatabaseHelper().resetPassword(
        email: email,
        newPassword: newPassword,
      );

      if (!resetResult['success']) {
        _showMessage(resetResult['message'], isError: true);
        return;
      }

      // Gửi email
      final emailResult = await EmailService.sendForgotPasswordEmail(
        recipientEmail: email,
        recipientName: user['name'],
        newPassword: newPassword,
      );

      if (emailResult['success']) {
        _showMessage('Mật khẩu mới đã được gửi đến email của bạn!', isError: false);
        NavigationHelper.navigateToLogin(context);
      } else {
        _showMessage('Đã cập nhật mật khẩu nhưng không thể gửi email: ${emailResult['message']}', isError: true);
      }
    } catch (e) {
      _showMessage('Đã xảy ra lỗi: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
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
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Colors.blue[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hướng dẫn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nhập địa chỉ email đã đăng ký để nhận mật khẩu mới. Kiểm tra cả hộp thư rác nếu không thấy email.',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UTC2Logo(
          welcomeTitle: 'Quên mật khẩu?',
          welcomeSubtitle: 'Đừng lo lắng, chúng tôi sẽ giúp bạn',
        ),
        Expanded(
          child: AuthScaffold(
            child: Column(
              children: [
                _buildInfoBox(),
                CustomTextField(
                  hintText: 'Địa chỉ email',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Gửi mật khẩu mới',
                  icon: Icons.send,
                  onPressed: _handleForgotPassword,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => NavigationHelper.goBack(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Quay lại đăng nhập',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Vẫn gặp vấn đề? Liên hệ hỗ trợ',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
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