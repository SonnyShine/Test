import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../utils/email_service.dart';
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
  int _passwordStrength = 0;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

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

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _databaseHelper.createUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        birthdate: _birthdateController.text.isNotEmpty ? _birthdateController.text : null,
        gender: _selectedGender!,
        password: _passwordController.text,
      );

      if (result['success']) {
        final emailResult = await EmailService.sendRegistrationConfirmEmail(
          recipientEmail: _emailController.text.trim(),
          recipientName: _nameController.text.trim(),
        );

        if (emailResult['success']) {
          _showMessage(
            'Tài khoản đã được tạo thành công! Email xác nhận đã được gửi đến ${_emailController.text}',
            isError: false,
          );
        } else {
          _showMessage(
            'Tài khoản đã được tạo nhưng không thể gửi email xác nhận.',
            isError: true,
          );
        }
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
    // Kiểm tra các trường required
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedGender == null ||
        !_agreeTerms) {
      _showMessage('Vui lòng điền đầy đủ thông tin bắt buộc!', isError: true);
      return false;
    }

    // Kiểm tra email hợp lệ
    if (!_isValidEmail(_emailController.text.trim())) {
      _showMessage('Email không hợp lệ!', isError: true);
      return false;
    }

    // Kiểm tra mật khẩu khớp
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Mật khẩu xác nhận không khớp!', isError: true);
      return false;
    }

    // Kiểm tra độ mạnh mật khẩu
    if (_passwordStrength < 2) {
      _showMessage('Mật khẩu quá yếu! Vui lòng chọn mật khẩu mạnh hơn.', isError: true);
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _updatePasswordStrength(String password) {
    setState(() {
      _passwordStrength = 0;
      if (password.length >= 8) _passwordStrength++;
      if (RegExp(r'[A-Z]').hasMatch(password)) _passwordStrength++;
      if (RegExp(r'[0-9]').hasMatch(password)) _passwordStrength++;
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) _passwordStrength++;
    });
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Độ mạnh mật khẩu',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: _passwordStrength / 4,
          backgroundColor: Colors.grey[300],
          color: _passwordStrength < 2
              ? Colors.red
              : (_passwordStrength < 3 ? Colors.orange : Colors.green),
        ),
        SizedBox(height: 4),
        Text(
          _getPasswordStrengthText(),
          style: TextStyle(
            fontSize: 11,
            color: _passwordStrength < 2
                ? Colors.red
                : (_passwordStrength < 3 ? Colors.orange : Colors.green),
          ),
        ),
      ],
    );
  }

  String _getPasswordStrengthText() {
    switch (_passwordStrength) {
      case 0:
      case 1:
        return 'Yếu';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Mạnh';
      case 4:
        return 'Rất mạnh';
      default:
        return '';
    }
  }

  Widget _buildTermsCheckbox() {
    return Row(
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
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ),
      ],
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
          welcomeTitle: 'Tạo tài khoản mới',
          welcomeSubtitle: 'Chào mừng bạn đến UTC2 ngay hôm nay',
        ),
        Expanded(
          child: AuthScaffold(
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'Họ và tên *',
                  prefixIcon: Icons.person,
                  controller: _nameController,
                ),
                CustomTextField(
                  hintText: 'Email *',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  hintText: 'Số điện thoại *',
                  prefixIcon: Icons.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  hintText: 'Ngày sinh (mm/dd/yyyy)',
                  prefixIcon: Icons.calendar_today,
                  controller: _birthdateController,
                  isDatePicker: true,
                ),
                CustomDropdown(
                  hintText: 'Chọn giới tính *',
                  prefixIcon: Icons.person_outline,
                  items: ['Nam', 'Nữ', 'Khác'],
                  selectedValue: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() => _selectedGender = newValue);
                  },
                ),
                CustomTextField(
                  hintText: 'Mật khẩu *',
                  prefixIcon: Icons.lock,
                  controller: _passwordController,
                  isPassword: true,
                  onChanged: _updatePasswordStrength,
                ),
                SizedBox(height: 10),
                _buildPasswordStrengthIndicator(),
                SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Xác nhận mật khẩu *',
                  prefixIcon: Icons.lock,
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                SizedBox(height: 16),
                _buildTermsCheckbox(),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Đăng ký tài khoản',
                  icon: Icons.person_add,
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 20),
                _buildDivider(),
                SizedBox(height: 8),
                Text(
                  'Đã có tài khoản?',
                  style: TextStyle(color: Colors.grey[500]),
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
                        Icon(Icons.login, color: Colors.blue, size: 18),
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