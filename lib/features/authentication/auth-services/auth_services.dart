import 'dart:convert';

import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String password2,
  }) async {
    final uri = Uri.parse(ApiConstants.register);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
          'password2': password2,
        }),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {'success': true, 'data': body};
      }

      String message = 'Registration failed';
      if (body is Map) {
        if (body['detail'] != null) {
          message = body['detail'].toString();
        } else if (body['message'] != null)
          // ignore: curly_braces_in_flow_control_structures
          message = body['message'].toString();
        else if (body['email'] != null)
          // ignore: curly_braces_in_flow_control_structures
          message = body['email'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.login);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // Try to parse and persist tokens and user info when available
        if (body is Map) {
          final access = body['access']?.toString();
          final refresh = body['refresh']?.toString();
          final user = body['user'];
          final id = user != null ? user['id']?.toString() : null;
          final email = user != null ? user['email']?.toString() : null;

          AppLoggerHelper.debug("response body: $body");

          debugPrint(
            'Login successful: access=$access, refresh=$refresh, id=$id, email=$email',
          );

          // Only save when all required pieces are present
          if (access != null &&
              refresh != null &&
              id != null &&
              email != null) {
            await StorageService.saveToken(
              access,
              id,
              refresh: refresh,
              email: email,
            );
          }

          final String? token = StorageService.token;
          debugPrint('Stored token after login: $token');
        }

        return {'success': true, 'data': body, 'statusCode': resp.statusCode};
      }

      String message = 'Login failed';
      if (body is Map) {
        if (body['detail'] != null)
          message = body['detail'].toString();
        else if (body['message'] != null)
          message = body['message'].toString();
        else if (body['non_field_errors'] != null)
          message = body['non_field_errors'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Verify OTP endpoint. Expects `email` and `otp`.
  /// Returns {'success': true, 'data': body} on success or error info on failure.
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final uri = Uri.parse(ApiConstants.verifyOtp);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {'success': true, 'data': body, 'statusCode': resp.statusCode};
      }

      String message = 'Verify OTP failed';
      if (body is Map) {
        if (body['detail'] != null)
          message = body['detail'].toString();
        else if (body['message'] != null)
          message = body['message'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Request OTP for forgot-password flow. Expects `email`.
  static Future<Map<String, dynamic>> requestForgotPasswordOtp({
    required String email,
  }) async {
    final uri = Uri.parse(ApiConstants.forgotPassword);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {'success': true, 'data': body, 'statusCode': resp.statusCode};
      }

      String message = 'Request OTP failed';
      if (body is Map) {
        if (body['detail'] != null)
          message = body['detail'].toString();
        else if (body['message'] != null)
          message = body['message'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final uri = Uri.parse(ApiConstants.forgotVerifyOtp);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {'success': true, 'data': body, 'statusCode': resp.statusCode};
      }

      String message = 'Forgot-verify OTP failed';
      if (body is Map) {
        if (body['detail'] != null)
          message = body['detail'].toString();
        else if (body['message'] != null)
          message = body['message'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    final uri = Uri.parse(ApiConstants.resetPassword);

    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reset_token': resetToken,
          'new_password': newPassword,
        }),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return {'success': true, 'data': body, 'statusCode': resp.statusCode};
      }

      String message = 'Reset password failed';
      if (body is Map) {
        if (body['detail'] != null)
          message = body['detail'].toString();
        else if (body['message'] != null)
          message = body['message'].toString();
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
