import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../blocs/laundry_service_type/laundry_service_type_bloc.dart';
import '../../blocs/laundry_service_type/laundry_service_type_event.dart';
import '../../blocs/laundry_service_type/laundry_service_type_state.dart';
import '../../widgets/custom_app_bar.dart';

class ChooseServiceTypeScreen extends StatefulWidget {
  const ChooseServiceTypeScreen({Key? key}) : super(key: key);

  @override
  _ChooseServiceTypeScreenState createState() => _ChooseServiceTypeScreenState();
}

class _ChooseServiceTypeScreenState extends State<ChooseServiceTypeScreen> {
  // Constants
  static const Color _primaryColor = Color(0xFF1CAF7D);
  static const String _appBarTitle = 'Dịch Vụ Giặt';

  // Service icons map - có thể thay thế bằng các icon thực tế phù hợp với từng loại dịch vụ
  final Map<String, IconData> _serviceIcons = {
    'Giặt Thường': Icons.local_laundry_service,
    'Giặt Khô': Icons.dry_cleaning,
    'Giặt Nhanh': Icons.speed,
    'Giặt Đồ Cao Cấp': Icons.diamond,
    'default': Icons.local_laundry_service,
  };

  late LaundryServiceTypeBloc _laundryServiceTypeBloc;
  List<dynamic> _laundryServiceTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _laundryServiceTypeBloc = context.read<LaundryServiceTypeBloc>();
    _fetchServiceTypes();
  }

  void _fetchServiceTypes() {
    _laundryServiceTypeBloc.add(GetLaundryServiceTypes());
    _laundryServiceTypeBloc.stream.listen((state) {
      if (state is LaundryServiceTypeLoaded) {
        setState(() {
          _laundryServiceTypes = state.laundryServiceTypes.items;
          _isLoading = false;
        });
      } else if (state is LaundryServiceTypeError) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(state.message);
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Chọn icon phù hợp với loại dịch vụ
  IconData _getServiceIcon(dynamic serviceType) {
    String serviceName = serviceType.name ?? '';
    return _serviceIcons[serviceName] ?? _serviceIcons['default']!;
  }

  // UI cho trạng thái đang tải
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sử dụng container để tạo hiệu ứng shadow cho loading indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: _primaryColor,
                    strokeWidth: 5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Đang tải dịch vụ...',
                  style: TextStyle(
                    fontSize: 16,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI khi không có dữ liệu
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Không có dịch vụ nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Hiện tại chưa có dịch vụ giặt nào khả dụng, vui lòng thử lại sau.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchServiceTypes,
            icon: const Icon(Icons.refresh),
            label: const Text('Tải lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card hiển thị thông tin dịch vụ
  Widget _buildServiceTypeCard(dynamic serviceType) {
    final IconData serviceIcon = _getServiceIcon(serviceType);

    // Tạo màu ngẫu nhiên cho background icon dựa trên tên dịch vụ
    final int nameHash = (serviceType.name ?? '').hashCode;
    final List<Color> colorOptions = [
      const Color(0xFFE3F9F0), // Xanh lá nhạt
      const Color(0xFFE3F2FD), // Xanh dương nhạt
      const Color(0xFFFFF8E1), // Vàng nhạt
      const Color(0xFFF3E5F5), // Tím nhạt
      const Color(0xFFFFEBEE), // Đỏ nhạt
    ];
    final Color bgColor = colorOptions[nameHash.abs() % colorOptions.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppRouter.navigateToChooseItemType(
          serviceType.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon với background tròn
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    serviceType.type == "PerKg" ?
                    'assets/images/img_laundry.png' :
                    'assets/images/img_laundry_1.png',
                    width: 64,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 16),
                // Thông tin dịch vụ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceType.name ?? 'Dịch vụ không tên',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceType.description ?? 'Không có mô tả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Icon chỉ hướng
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: _primaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: CustomAppBar(
        title: _appBarTitle,
        onBackPressed: () => AppRouter.navigateToHome(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Chọn dịch vụ giặt phù hợp',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),

            // Main content
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : _laundryServiceTypes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                itemCount: _laundryServiceTypes.length,
                itemBuilder: (context, index) {
                  return _buildServiceTypeCard(_laundryServiceTypes[index]);
                },
              ),
            ),
          ],
        ),
      ),

      // Floating action button để refresh
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
        onPressed: _fetchServiceTypes,
        backgroundColor: _primaryColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}