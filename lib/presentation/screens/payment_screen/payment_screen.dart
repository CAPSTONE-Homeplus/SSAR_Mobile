import 'package:flutter/material.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  double loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    controller = WebViewController();

    // Configure Android-specific settings to allow cleartext traffic
    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _handlePageStarted,
          onProgress: _handleProgress,
          onPageFinished: _handlePageFinished,
          onWebResourceError: _handleWebResourceError,
          onNavigationRequest: _handleNavigationRequest,
        ),
      )
      ..setUserAgent('Mozilla/5.0 (Android 10; Mobile; rv:84.0) Gecko/84.0 Firefox/84.0')
      ..loadRequest(_getProcessedUrl());
  }

  Uri _getProcessedUrl() {
    // Try to use HTTPS instead of HTTP if it's a cleartext URL
    String url = widget.paymentUrl;
    if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
      print('Converted payment URL to HTTPS: $url');
    }
    return Uri.parse(url);
  }

  void _handlePageStarted(String url) {
    if (mounted) {
      setState(() {
        isLoading = true;
        loadingProgress = 0.0;
      });
    }
    print('Loading page: $url');
  }

  void _handleProgress(int progress) {
    if (mounted) {
      setState(() {
        loadingProgress = progress / 100;
      });
    }
  }

  void _handlePageFinished(String url) {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    print('Page loaded: $url');

    // Check for successful payment redirect
    if (url.contains('success') || url.contains('callback')) {
      _showSuccessDialog();
    }
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    print('Navigating to: ${request.url}');
    // You can add specific URL handling logic here
    return NavigationDecision.navigate;
  }

  void _handleWebResourceError(WebResourceError error) {
    print("WebView Error: ${error.description}, errorCode: ${error.errorCode}, URL: ${error.url}, Type: ${error.errorType}");

    // Show error message only when page is still loading
    if (isLoading) {
      _showErrorSnackBar("Lỗi kết nối: ${error.description} (${error.errorCode})");
    }

    // Attempt to reload if it's a connection error
    if (error.errorCode == -2 || error.description.contains('ERR_CLEARTEXT_NOT_PERMITTED')) {
      Future.delayed(Duration(seconds: 2), () {
        controller.reload();
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Thử lại',
          textColor: Colors.white,
          onPressed: () => controller.reload(),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF1CAF7D), size: 28),
            SizedBox(width: 12),
            Text(
              'Thanh toán thành công',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Giao dịch của bạn đã được xử lý thành công. Số dư sẽ được cập nhật trong ít phút.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              AppRouter.navigateToHome(); // Về trang chủ
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1CAF7D),
            ),
            child: Text(
              'Về trang chủ',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      _showExitConfirmDialog();
      return false;
    }
    return true;
  }

  void _showExitConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Hủy thanh toán?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn hủy quá trình thanh toán này không?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tiếp tục thanh toán',
              style: GoogleFonts.poppins(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppRouter.navigateToHome();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CAF7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Xác nhận hủy',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      title: Text(
        'Thanh toán',
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
        onPressed: () async {
          if (await controller.canGoBack()) {
            _showExitConfirmDialog();
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildWebView(),
        if (isLoading) _buildLoadingIndicator(),
        _buildSecurityFooter(),
      ],
    );
  }

  Widget _buildWebView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: WebViewWidget(controller: controller),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1CAF7D)),
                value: loadingProgress > 0 ? loadingProgress : null,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Đang tải cổng thanh toán...',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (loadingProgress > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${(loadingProgress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF1CAF7D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.lock, color: Color(0xFF1CAF7D), size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kết nối bảo mật - Thông tin của bạn được mã hóa',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Icon(Icons.verified_user, color: Color(0xFF1CAF7D), size: 18),
          ],
        ),
      ),
    );
  }
}