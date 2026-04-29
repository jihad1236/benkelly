class CreatePaymentRequest {
  final String priceId;
  final String successUrl;
  final String cancelUrl;

  CreatePaymentRequest({
    required this.priceId,
    required this.successUrl,
    required this.cancelUrl,
  });

  Map<String, String> toFormData() {
    return {
      'price_id': priceId,
      'success_url': successUrl,
      'cancel_url': cancelUrl,
    };
  }
}

class PaymentResponse {
  final bool success;
  final String message;
  final String checkoutUrl;

  PaymentResponse({
    required this.success,
    required this.message,
    required this.checkoutUrl,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      checkoutUrl: json['data'] ?? '',
    );
  }
}
