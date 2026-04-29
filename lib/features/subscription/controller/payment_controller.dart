import 'package:get/get.dart';

import '../service/payment_service.dart';

class PaymentController extends GetxController {
  final PaymentService _paymentService = PaymentService();

  final RxBool isLoading = false.obs;
  final RxString checkoutUrl = ''.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> createPaymentSession({
    required String priceId,
    String? successUrl,
    String? cancelUrl,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    checkoutUrl.value = '';

    try {
      final response = await _paymentService.createCheckoutSession(
        priceId: priceId,
        successUrl: successUrl ?? 'https://success.com',
        cancelUrl: cancelUrl ?? 'https://cancel.com',
      );

      if (response != null && response.success) {
        checkoutUrl.value = response.checkoutUrl;
        return true;
      } else {
        errorMessage.value =
            response?.message ?? 'Failed to create payment session';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    checkoutUrl.value = '';
    errorMessage.value = '';
    isLoading.value = false;
  }

  @override
  void onClose() {
    isLoading.close();
    checkoutUrl.close();
    errorMessage.close();
    super.onClose();
  }
}
