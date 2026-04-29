import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';

import '../model/payment_model.dart';

class PaymentService {
  final NetworkCaller _networkCaller;

  PaymentService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  Future<PaymentResponse?> createCheckoutSession({
    required String priceId,
    required String successUrl,
    required String cancelUrl,
  }) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final request = CreatePaymentRequest(
        priceId: priceId,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );

      final response = await _networkCaller.multipartRequest(
        ApiConstants.createPayment,
        method: 'POST',
        fields: request.toFormData(),
        token: 'Bearer $token',
      );

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      final data = response.responseData;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      return PaymentResponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
