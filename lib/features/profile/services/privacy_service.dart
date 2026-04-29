import 'package:benkelly864/core/models/response_data.dart';
import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:flutter/cupertino.dart';
import '../models/privacy_model.dart';

class PrivacyService {
  final NetworkCaller _caller = NetworkCaller();

  Future<PrivacyModel?> getPrivacy() async {
    final token = StorageService.token;

    debugPrint('Retrieved token: $token');
    final authHeader = token != null ? 'Bearer $token' : null;

    debugPrint('Fetching privacy settings with token: $authHeader');

    final ResponseData res = await _caller.getRequest(
      ApiConstants.privacy,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return PrivacyModel.fromJson(
            res.responseData as Map<String, dynamic>,
          );
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<PrivacyModel?> updatePrivacy(Map<String, dynamic> body) async {
    final token = StorageService.token;
    final authHeader = token != null ? 'Bearer $token' : null;

    debugPrint('Updating privacy settings with body: $body');

    final ResponseData res = await _caller.patchRequest(
      ApiConstants.privacy,
      body: body,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return PrivacyModel.fromJson(
            res.responseData as Map<String, dynamic>,
          );
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
