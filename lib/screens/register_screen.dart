import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/utc2_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../utils/navigation_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng ký thành công!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login
    NavigationHelper.navigateToLogin(context);
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedGender == null ||
        !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật khẩu xác nhận không khớp!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UTC2Logo(
          welcomeTitle:'Tạo tài khoản mới',
          welcomeSubtitle: 'Chào mừng bạn đến UTC2 ngay hôm nay',
        ),
        Expanded(
          child: AuthScaffold(
            child: Column(
              children: [
                // Nội dung chính của AuthScaffold
                // SizedBox(height: 40),
                CustomTextField(
                  hintText: 'Họ và tên',
                  prefixIcon: Icons.person,
                  controller: _nameController,
                ),
                CustomTextField(
                  hintText: 'Email',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  hintText: 'Số điện thoại',
                  prefixIcon: Icons.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  hintText: 'mm/dd/yyyy',
                  prefixIcon: Icons.calendar_today,
                  controller: _birthdateController,
                  isDatePicker: true,
                ),
                CustomDropdown(
                  hintText: 'Chọn giới tính',
                  prefixIcon: Icons.person_outline,
                  items: ['Nam', 'Nữ', 'Khác'],
                  selectedValue: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() => _selectedGender = newValue);
                  },
                ),
                CustomTextField(
                  hintText: 'Mật khẩu',
                  prefixIcon: Icons.lock,
                  controller: _passwordController,
                  isPassword: true,
                ),
                CustomTextField(
                  hintText: 'Xác nhận mật khẩu',
                  prefixIcon: Icons.lock,
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (bool? value) {
                        setState(() => _agreeTerms = value ?? false);
                      },
                      fillColor: MaterialStateProperty.all(Colors.orange),
                    ),
                    Expanded(
                      child: Text(
                        'Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật của UTC2',
                        style: TextStyle(
                          color: Colors.grey[500]!,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Đăng ký tài khoản',
                  icon: Icons.person_add,
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 20),
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
                  'Đã có tài khoản?',
                  style: TextStyle(color: Colors.grey[500]!),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => NavigationHelper.navigateToLogin(context),
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
                          Icons.login,
                          color: Colors.blue,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Đăng nhập ngay',
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