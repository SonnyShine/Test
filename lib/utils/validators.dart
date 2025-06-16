// class Validators {
//   static bool isEmailValid(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }
//
//   static bool isPhoneValid(String phone) {
//     return RegExp(r'^[0-9]{10,11}$').hasMatch(phone);
//   }
//
//   static bool isPasswordValid(String password) {
//     return password.length >= 6;
//   }
//
//   static String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email không được để trống';
//     }
//     if (!isEmailValid(value)) {
//       return 'Email không hợp lệ';
//     }
//     return null;
//   }
//
//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Mật khẩu không được để trống';
//     }
//     if (!isPasswordValid(value)) {
//       return 'Mật khẩu phải có ít nhất 6 ký tự';
//     }
//     return null;
//   }
//
//   static String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Số điện thoại không được để trống';
//     }
//     if (!isPhoneValid(value)) {
//       return 'Số điện thoại không hợp lệ';
//     }
//     return null;
//   }
// }