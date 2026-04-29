import 'dart:convert';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:benkelly864/core/services/storage_service.dart';

/// Service that handles Google Sign-In and sends the obtained token to the backend.
class GoogleAuthService {
  /// You can optionally pass a [serverClientId] (the Web OAuth client id) to request an idToken
  static Future<Map<String, dynamic>> signInAndSendTokenToBackend({
    String? serverClientId,
  }) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: serverClientId,
    );

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        return {'success': false, 'message': 'Google sign-in was cancelled'};
      }

      if (kDebugMode) {
        debugPrint('Google account obtained: ${account.email}');
      }

      final String email = account.email;
      final String name = account.displayName ?? '';
      final String image = account.photoUrl ?? '';

      if (kDebugMode) {
        debugPrint('Google account: email=$email, name=$name, image=$image');
      }

      final uri = Uri.parse(ApiConstants.googleSocialLogin);
      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'name': name,
          'image': image,
        }),
      );

      final dynamic body = resp.body.isNotEmpty ? jsonDecode(resp.body) : null;

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        if (body is Map<String, dynamic>) {
          final user = body['user'];
          final tokens = body['tokens'];
          final access = tokens is Map ? tokens['access']?.toString() : null;
          final refresh = tokens is Map ? tokens['refresh']?.toString() : null;
          final id = user is Map ? user['id']?.toString() : null;
          final savedEmail =
              user is Map ? (user['email']?.toString() ?? email) : email;

          if (kDebugMode) {
            debugPrint(
              'Google login successful: access=$access, refresh=$refresh, id=$id, email=$savedEmail',
            );
          }

          if (access != null &&
              refresh != null &&
              id != null &&
              savedEmail.isNotEmpty) {
            await StorageService.saveToken(
              access,
              id,
              refresh: refresh,
              email: savedEmail,
            );

            if (kDebugMode) {
              final String? storedToken = StorageService.token;
              debugPrint('Stored token after Google login: $storedToken');
            }

            return {
              'success': true,
              'data': body,
              'statusCode': resp.statusCode,
            };
          }

          return {
            'success': false,
            'message': 'Google login response is missing token data',
            'statusCode': resp.statusCode,
            'errors': body,
          };
        }

        return {
          'success': false,
          'message': 'Google login response format is invalid',
          'statusCode': resp.statusCode,
          'errors': body,
        };
      }

      String message = 'Social login failed';
      if (body is Map) {
        if (body['detail'] != null) {
          message = body['detail'].toString();
        } else if (body['message'] != null) {
          message = body['message'].toString();
        }
      }

      return {
        'success': false,
        'message': message,
        'statusCode': resp.statusCode,
        'errors': body,
      };
    } on PlatformException catch (pe) {
      final code = pe.code;
      final message = pe.message ?? 'PlatformException during Google Sign-In';
      final details = pe.details;
      return {
        'success': false,
        'message': 'PlatformException: $code - $message',
        'code': code,
        'details': details,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      await googleSignIn.signOut();
    } catch (_) {}
  }
}
