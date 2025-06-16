import 'package:flutter/material.dart';
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

  void _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập địa chỉ email!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liên kết đặt lại mật khẩu đã được gửi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UTC2Logo(
            welcomeTitle: 'Quên mật khẩu?',
            welcomeSubtitle: 'Đừng lo lắng, chúng tôi sẽ giúp bạn'
        ),
        Expanded(
          child: AuthScaffold(
            child: Column(
              children: [
                // Nội dung chính của AuthScaffold
                Container(
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
                      Icon(
                        Icons.info,
                        color: Colors.blue[600],
                        size: 20,
                      ),
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
                              'Nhập địa chỉ email đã đăng ký để nhận liên kết đặt lại mật khẩu. Kiểm tra cả hộp thư rác nếu không thấy email',
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
                ),
                CustomTextField(
                  hintText: 'Địa chỉ email',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Gửi liên kết đặt lại',
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
                      Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Quay lại đăng nhập',
                        style: TextStyle(
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Vẫn gặp vấn đề? Liên hệ hỗ trợ',
                  style: TextStyle(
                    color: Colors.grey[500]!,
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