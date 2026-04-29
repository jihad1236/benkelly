import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';

import '../model/subscription_model.dart';

class SubscriptionService {
  final NetworkCaller _networkCaller;

  SubscriptionService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  /// Fetch plans from the API and return a list of SubscriptionTierModel.
  /// Returns an empty list when the request fails.
  Future<List<SubscriptionTierModel>> fetchPlans() async {
    final res = await _networkCaller.getRequest(ApiConstants.plans);
    if (!res.isSuccess) {
      // Log in caller; return empty list so UI can handle gracefully
      return [];
    }

    final body = res.responseData;
    if (body is! Map<String, dynamic>) return [];

    final data = body['data'] as List<dynamic>?;
    if (data == null) return [];

    // Convert to list of maps and sort by price.amount ascending so that
    // free plan (0.0) appears first, then by increasing price.
    final List<Map<String, dynamic>> raw = data
        .map((e) => e as Map<String, dynamic>)
        .toList();

    double extractAmount(Map<String, dynamic> item) {
      final price = item['price'] as Map<String, dynamic>?;
      if (price == null) return double.maxFinite;
      final amt = price['amount'];
      if (amt == null) return double.maxFinite;
      if (amt is num) return amt.toDouble();
      return double.tryParse(amt.toString()) ?? double.maxFinite;
    }

    raw.sort((a, b) => extractAmount(a).compareTo(extractAmount(b)));

    final List<SubscriptionTierModel> plans = [];
    for (var i = 0; i < raw.length; i++) {
      final item = raw[i];
      plans.add(SubscriptionTierModel.fromApiJson(item, i + 1));
    }

    return plans;
  }
}
