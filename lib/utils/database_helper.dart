import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'utc2_app.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        birthdate TEXT,
        gender TEXT NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  // Hash password for security
  // String _hashPassword(String password) {
  //   var bytes = utf8.encode(password);
  //   var digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Verify password
  // bool _verifyPassword(String password, String hashedPassword) {
  //   return _hashPassword(password) == hashedPassword;
  // }

  // Validate email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone
  bool _isValidPhone(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return RegExp(r'^[0-9]{10,11}$').hasMatch(cleanPhone);
  }

  // Create user
  Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String phone,
    String? birthdate,
    required String gender,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (name.trim().isEmpty) {
        return {'success': false, 'message': 'Tên không được để trống!'};
      }
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không hợp lệ!'};
      }
      if (!_isValidPhone(phone)) {
        return {'success': false, 'message': 'Số điện thoại không hợp lệ!'};
      }
      if (password.length < 8) {
        return {
          'success': false,
          'message': 'Mật khẩu phải có ít nhất 8 ký tự!',
        };
      }

      final db = await database;

      // Check existing email
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (existingUser.isNotEmpty) {
        return {'success': false, 'message': 'Email đã được sử dụng!'};
      }

      String currentTime = DateTime.now().toIso8601String();

      int userId = await db.insert('users', {
        'name': name.trim(),
        'email': email.toLowerCase(),
        'phone': phone.replaceAll(RegExp(r'[^\d]'), ''),
        'birthdate': birthdate,
        'gender': gender,
        'password': password,
        'created_at': currentTime,
        'updated_at': currentTime,
      });

      return {
        'success': true,
        'message': 'Đăng ký thành công!',
        'userId': userId,
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi khi tạo tài khoản: $e'};
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không hợp lệ!'};
      }

      final db = await database;
      final users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (users.isEmpty) {
        return {'success': false, 'message': 'User không tồn tại!'};
      }

      final user = users.first;
      if (!(password == user['password'] as String)) {
        return {'success': false, 'message': 'Email hoặc mật khẩu không đúng!'};
      }

      return {
        'success': true,
        'message': 'Đăng nhập thành công!',
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'birthdate': user['birthdate'],
          'gender': user['gender'],
        },
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi khi đăng nhập: $e'};
    }
  }

  // Get user by ID
  // Future<Map<String, dynamic>?> getUserById(int userId) async {
  //   try {
  //     final db = await database;
  //     final users = await db.query(
  //       'users',
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );
  //
  //     if (users.isEmpty) return null;
  //
  //     final user = users.first;
  //     return {
  //       'id': user['id'],
  //       'name': user['name'],
  //       'email': user['email'],
  //       'phone': user['phone'],
  //       'birthdate': user['birthdate'],
  //       'gender': user['gender'],
  //       'created_at': user['created_at'],
  //       'updated_at': user['updated_at'],
  //     };
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Update user
  // Future<Map<String, dynamic>> updateUser({
  //   required int userId,
  //   String? name,
  //   String? phone,
  //   String? birthdate,
  //   String? gender,
  // }) async {
  //   try {
  //     if (name != null && name.trim().isEmpty) {
  //       return {'success': false, 'message': 'Tên không được để trống!'};
  //     }
  //     if (phone != null && !_isValidPhone(phone)) {
  //       return {'success': false, 'message': 'Số điện thoại không hợp lệ!'};
  //     }
  //
  //     final db = await database;
  //     Map<String, dynamic> updateData = {
  //       'updated_at': DateTime.now().toIso8601String(),
  //     };
  //
  //     if (name != null) updateData['name'] = name.trim();
  //     if (phone != null)
  //       updateData['phone'] = phone.replaceAll(RegExp(r'[^\d]'), '');
  //     if (birthdate != null) updateData['birthdate'] = birthdate;
  //     if (gender != null) updateData['gender'] = gender;
  //
  //     int updatedRows = await db.update(
  //       'users',
  //       updateData,
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );
  //
  //     return {
  //       'success': updatedRows > 0,
  //       'message':
  //           updatedRows > 0
  //               ? 'Cập nhật thành công!'
  //               : 'Không tìm thấy người dùng!',
  //     };
  //   } catch (e) {
  //     return {'success': false, 'message': 'Lỗi khi cập nhật: $e'};
  //   }
  // }

  // Change password
  // Future<Map<String, dynamic>> changePassword({
  //   required int userId,
  //   required String oldPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     if (newPassword.length < 6) {
  //       return {
  //         'success': false,
  //         'message': 'Mật khẩu mới phải có ít nhất 6 ký tự!',
  //       };
  //     }
  //
  //     final db = await database;
  //     final users = await db.query(
  //       'users',
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );
  //
  //     if (users.isEmpty) {
  //       return {'success': false, 'message': 'Không tìm thấy người dùng!'};
  //     }
  //
  //     final user = users.first;
  //     if (!(oldPassword== user['password'] as String)) {
  //       return {'success': false, 'message': 'Mật khẩu cũ không đúng!'};
  //     }
  //
  //     await db.update(
  //       'users',
  //       {
  //         'password': newPassword,
  //         'updated_at': DateTime.now().toIso8601String(),
  //       },
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );
  //
  //     return {'success': true, 'message': 'Đổi mật khẩu thành công!'};
  //   } catch (e) {
  //     return {'success': false, 'message': 'Lỗi khi đổi mật khẩu: $e'};
  //   }
  // }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email không hợp lệ!'};
      }
      if (newPassword.length < 8) {
        return {
          'success': false,
          'message': 'Mật khẩu mới phải có ít nhất 8 ký tự!',
        };
      }

      final db = await database;
      final users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (users.isEmpty) {
        return {'success': false, 'message': 'Email không tồn tại!'};
      }

      await db.update(
        'users',
        {
          'password': newPassword,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      return {
        'success': true,
        'message': 'Mật khẩu đã được cập nhật!',
        'user': {'name': users.first['name'], 'email': users.first['email']},
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi khi đặt lại mật khẩu: $e'};
    }
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      if (!_isValidEmail(email)) return null;

      final db = await database;
      final users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (users.isEmpty) return null;

      final user = users.first;
      return {
        'id': user['id'],
        'name': user['name'],
        'email': user['email'],
        'phone': user['phone'],
        'birthdate': user['birthdate'],
        'gender': user['gender'],
      };
    } catch (e) {
      return null;
    }
  }

  // Get all users
  // Future<List<Map<String, dynamic>>> getAllUsers() async {
  //   try {
  //     final db = await database;
  //     final users = await db.query('users', orderBy: 'created_at DESC');
  //
  //     return users
  //         .map(
  //           (user) => {
  //             'id': user['id'],
  //             'name': user['name'],
  //             'email': user['email'],
  //             'phone': user['phone'],
  //             'birthdate': user['birthdate'],
  //             'gender': user['gender'],
  //             'created_at': user['created_at'],
  //             'updated_at': user['updated_at'],
  //           },
  //         )
  //         .toList();
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // Delete user
  // Future<Map<String, dynamic>> deleteUser(int userId) async {
  //   try {
  //     final db = await database;
  //     int deletedRows = await db.delete(
  //       'users',
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );
  //
  //     return {
  //       'success': deletedRows > 0,
  //       'message':
  //           deletedRows > 0
  //               ? 'Xóa tài khoản thành công!'
  //               : 'Không tìm thấy tài khoản!',
  //     };
  //   } catch (e) {
  //     return {'success': false, 'message': 'Lỗi khi xóa tài khoản: $e'};
  //   }
  // }

  // Close database
  // Future<void> close() async {
  //   if (_database != null) {
  //     await _database!.close();
  //     _database = null;
  //   }
  // }
}
