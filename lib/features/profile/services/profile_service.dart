import 'package:benkelly864/core/models/response_data.dart';
import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/customer_profile_model.dart';
import '../models/settings_model.dart';

class ProfileService {
  final NetworkCaller _caller = NetworkCaller();

  Future<CustomerProfileModel?> getProfile() async {
    final token = StorageService.token;
    final authHeader = token != null ? 'Bearer $token' : null;

    final ResponseData res = await _caller.getRequest(
      ApiConstants.customerProfile,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return CustomerProfileModel.fromJson(
            res.responseData as Map<String, dynamic>,
          );
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<SettingsModel?> getSettings() async {
    final token = StorageService.token;
    final authHeader = token != null ? 'Bearer $token' : null;

    final res = await _caller.getRequest(
      ApiConstants.settings,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return SettingsModel.fromJson(
            res.responseData as Map<String, dynamic>,
          );
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<SettingsModel?> updateSettings(Map<String, dynamic> body) async {
    final token = StorageService.token;
    final authHeader = token != null ? 'Bearer $token' : null;

    final ResponseData res = await _caller.putRequest(
      ApiConstants.settings,
      body: body,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return SettingsModel.fromJson(
            res.responseData as Map<String, dynamic>,
          );
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<CustomerProfileModel?> updateProfile({
    String? name,
    String? phoneNumber,
    String? imagePath,
  }) async {
    final token = StorageService.token;
    final authHeader = token != null ? 'Bearer $token' : null;

    Map<String, String> fields = {};
    if (name != null) fields['name'] = name;
    if (phoneNumber != null) fields['phone_number'] = phoneNumber;

    List<http.MultipartFile>? files;
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final file = File(imagePath);
        files = [await http.MultipartFile.fromPath('image', file.path)];
      } catch (_) {
        files = null;
      }
    }

    final res = await _caller.multipartRequest(
      ApiConstants.customerProfile,
      method: 'PATCH',
      fields: fields.isNotEmpty ? fields : null,
      files: files,
      token: authHeader,
    );

    if (res.isSuccess && res.responseData != null) {
      try {
        if (res.responseData is Map<String, dynamic>) {
          return CustomerProfileModel.fromJson(
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
