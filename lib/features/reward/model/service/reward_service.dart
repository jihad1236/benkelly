
import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/reward/model/reward_categories_buzzwords_model.dart';

class RewardService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<RewardCategoriesBuzzword>?> getCategoriesBuzzwords() async {
    final token = StorageService.token;
    if (token == null) {
      AppLoggerHelper.warning('No auth token found. Skipping categories buzzwords fetch.');
      return null;
    }

    final response = await _networkCaller.getRequest(
      ApiConstants.rewardCategoriesBuzzwords,
      token: 'Bearer $token',
    );

    if (response.isSuccess && response.responseData is List) {
      final List<dynamic> data = response.responseData as List<dynamic>;
      final List<RewardCategoriesBuzzword> result = data
          .where((item) => item is Map<String, dynamic>)
          .map((item) => RewardCategoriesBuzzword.fromJson(item as Map<String, dynamic>))
          .toList();
      
      AppLoggerHelper.debug('Fetched ${result.length} buzzword categories');
      return result;
    } else {
      AppLoggerHelper.error('Failed to fetch categories buzzwords', response.errorMessage);
      return null;
    }
  }
}