import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/common/widgets/custom_appbar.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/theme_globals.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String successUrl;
  final String cancelUrl;

  const PaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            _checkUrlForCompletion(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            _showErrorDialog(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _checkUrlForCompletion(String url) {
    if (url.contains(widget.successUrl) || url.contains('success')) {
      _handlePaymentSuccess();
    } else if (url.contains(widget.cancelUrl) || url.contains('cancel')) {
      _handlePaymentCancelled();
    }
  }

  void _handlePaymentSuccess() {
    Get.back(result: {'success': true});
    Get.snackbar(
      'Payment Successful',
      'Your subscription has been activated!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _handlePaymentCancelled() {
    Get.back(result: {'success': false, 'cancelled': true});
    Get.snackbar(
      'Payment Cancelled',
      'You have cancelled the payment',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back(result: {'success': false, 'error': message});
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool darkTheme = isDark;

    return Scaffold(
      backgroundColor: darkTheme ? AppColors.warmBackground : AppColors.card,
      appBar: CustomAppBar(
        title: AppText.payment,
        showBack: true,
        showSearch: false,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: darkTheme ? AppColors.accentGold : AppColors.mutedOlive,
              ),
            ),
        ],
      ),
    );
  }
}
