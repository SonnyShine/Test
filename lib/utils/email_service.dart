import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

class EmailService {
  static const String _smtpHost = 'smtp.gmail.com';
  static const int _smtpPort = 587;
  static const String _senderEmail = 'khoile139004@gmail.com';
  static const String _senderPassword = 'euctmnyejmzgonvo';
  static const String _senderName = 'UTC2 App';

  // Generate random password
  static String generateRandomPassword({int length = 8}) {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random.secure();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  // Validate email
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Send registration confirmation email
  static Future<Map<String, dynamic>> sendRegistrationConfirmEmail({
    required String recipientEmail,
    required String recipientName,
  }) async {
    try {
      if (!_isValidEmail(recipientEmail)) {
        return {'success': false, 'message': 'Email không hợp lệ!'};
      }

      final smtpServer = SmtpServer(
        _smtpHost,
        port: _smtpPort,
        username: _senderEmail,
        password: _senderPassword,
        allowInsecure: false,
        ssl: false,
      );

      final message = Message()
        ..from = Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = 'Đăng ký thành công - UTC2'
        ..html = _buildRegistrationTemplate(recipientName);

      final sendReport = await send(message, smtpServer);

      return {
        'success': sendReport.mail.toString().isNotEmpty,
        'message': sendReport.mail.toString().isNotEmpty
            ? 'Email xác nhận đã gửi thành công!'
            : 'Gửi email thất bại!',
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi gửi email: $e'};
    }
  }

  // Send forgot password email
  static Future<Map<String, dynamic>> sendForgotPasswordEmail({
    required String recipientEmail,
    required String recipientName,
    required String newPassword,
  }) async {
    try {
      if (!_isValidEmail(recipientEmail)) {
        return {'success': false, 'message': 'Email không hợp lệ!'};
      }

      final smtpServer = SmtpServer(
        _smtpHost,
        port: _smtpPort,
        username: _senderEmail,
        password: _senderPassword,
        allowInsecure: false,
        ssl: false,
      );

      final message = Message()
        ..from = Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = 'Mật khẩu mới - UTC2'
        ..html = _buildForgotPasswordTemplate(recipientName, newPassword);

      final sendReport = await send(message, smtpServer);

      return {
        'success': sendReport.mail.toString().isNotEmpty,
        'message': sendReport.mail.toString().isNotEmpty
            ? 'Mật khẩu mới đã gửi thành công!'
            : 'Gửi email thất bại!',
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi gửi email: $e'};
    }
  }

  // Simple registration email template
  static String _buildRegistrationTemplate(String name) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            .container { 
                max-width: 400px; 
                margin: 0 auto; 
                font-family: Arial, sans-serif; 
                padding: 20px;
                background: #f5f5f5;
            }
            .content { 
                background: white; 
                padding: 30px; 
                border-radius: 8px; 
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .success { 
                color: #28a745; 
                font-size: 48px; 
                margin-bottom: 20px; 
            }
            .title { 
                color: #333; 
                margin-bottom: 15px; 
            }
            .message { 
                color: #666; 
                line-height: 1.5; 
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="content">
                <div class="success">✅</div>
                <h2 class="title">Đăng ký thành công!</h2>
                <div class="message">
                    <p>Chào <strong>$name</strong>,</p>
                    <p>Tài khoản UTC2 của bạn đã được tạo thành công.</p>
                    <p>Bạn có thể đăng nhập ngay bây giờ.</p>
                </div>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  // Simple forgot password email template
  static String _buildForgotPasswordTemplate(String name, String password) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            .container { 
                max-width: 400px; 
                margin: 0 auto; 
                font-family: Arial, sans-serif; 
                padding: 20px;
                background: #f5f5f5;
            }
            .content { 
                background: white; 
                padding: 30px; 
                border-radius: 8px; 
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .icon { 
                color: #dc3545; 
                font-size: 48px; 
                margin-bottom: 20px; 
            }
            .title { 
                color: #333; 
                margin-bottom: 15px; 
            }
            .password-box { 
                background: #f8f9fa; 
                border: 2px solid #dc3545; 
                padding: 15px; 
                border-radius: 6px; 
                margin: 20px 0; 
            }
            .password { 
                font-size: 20px; 
                font-weight: bold; 
                color: #dc3545; 
                letter-spacing: 1px; 
            }
            .message { 
                color: #666; 
                line-height: 1.5; 
            }
            .warning { 
                background: #fff3cd; 
                padding: 10px; 
                border-radius: 4px; 
                margin-top: 15px; 
                font-size: 14px;
                color: #856404;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="content">
                <div class="icon">🔐</div>
                <h2 class="title">Mật khẩu mới</h2>
                <div class="message">
                    <p>Chào <strong>$name</strong>,</p>
                    <p>Mật khẩu mới cho tài khoản UTC2 của bạn:</p>
                </div>
                
                <div class="password-box">
                    <div class="password">$password</div>
                </div>

                <div class="warning">
                    ⚠️ Hãy đổi mật khẩu sau khi đăng nhập
                </div>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}