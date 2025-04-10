import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/laundry_blocs/order/aundry_order_bloc_v2.dart';
import 'package:home_clean/presentation/laundry_blocs/order/laundry_order_event_v2.dart';
import 'package:home_clean/presentation/laundry_blocs/order/laundry_order_state_v2.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../core/constant/size_config.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/order/order_laundry.dart';
import '../../blocs/order/order_bloc.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _searchController = TextEditingController();
  List<Orders> _filteredCleanOrders = [];
  List<Orders> _allCleanOrders = [];
  List<OrderLaundry> _laundryOrders = [];
  String _selectedCategory = 'clean';

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrdersByUserEvent());
  }

  void _applyCleanFilters() {
    final query = _searchController.text.toLowerCase();

    final filtered = _allCleanOrders.where((order) {
      final code = order.code?.toLowerCase() ?? '';
      final service = order.serviceType?.toLowerCase() ?? '';
      final status = order.status?.toLowerCase() ?? '';

      return query.isEmpty ||
          code.contains(query) ||
          service.contains(query) ||
          status.contains(query);
    }).toList();

    setState(() {
      _filteredCleanOrders = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: 'Đơn hàng của bạn'),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterTabs(),
            Expanded(
              child: _selectedCategory == 'clean'
                  ? BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoading) return _buildLoadingState();

                        if (state is OrderError) {
                          return _buildErrorState(() {
                            context
                                .read<OrderBloc>()
                                .add(GetOrdersByUserEvent());
                          });
                        }

                        if (state is OrdersByUserLoaded) {
                          _allCleanOrders = state.orders.items ?? [];

                          // 👉 Gọi filter sau build tránh lỗi setState trong build
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _applyCleanFilters();
                          });

                          return _filteredCleanOrders.isEmpty
                              ? _buildEmptyState()
                              : _buildCleanOrderList();
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  : BlocBuilder<LaundryOrderBlocV2, LaundryOrderStateV2>(
                      builder: (context, state) {
                        if (state is LaundryOrderLoadingV2)
                          return _buildLoadingState();

                        if (state is LaundryOrderFailureV2) {
                          return _buildErrorState(() {
                            context.read<LaundryOrderBlocV2>().add(
                                GetLaundryOrdersV2(
                                    'laundry-user-id-goes-here'));
                          });
                        }

                        if (state is LaundryOrderLoadedV2) {
                          _laundryOrders = state.orders;

                          return _laundryOrders.isEmpty
                              ? _buildEmptyState()
                              : _buildLaundryOrderList();
                        }

                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 20,
        vertical: SizeConfig.fem * 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) {
            if (_selectedCategory == 'clean') {
              _applyCleanFilters();
            }
          },
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.ffem * 12,
          ),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm đơn hàng...',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: SizeConfig.hem * 12,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xFF1CAF7D),
              size: SizeConfig.hem * 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.fem * 12,
              horizontal: SizeConfig.fem * 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 20,
        vertical: SizeConfig.fem * 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton('clean', 'Dọn dẹp'),
          _buildFilterButton('laundry', 'Giặt ủi'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = _selectedCategory == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = value;
          });

          if (value == 'clean') {
            context.read<OrderBloc>().add(GetOrdersByUserEvent());
          } else {
            context
                .read<LaundryOrderBlocV2>()
                .add(GetLaundryOrdersV2('laundry-user-id-goes-here'));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.fem * 10),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1CAF7D) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1CAF7D)),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : const Color(0xFF1CAF7D),
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.hem * 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCleanOrderList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.hem * 20),
      itemCount: _filteredCleanOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredCleanOrders[index];
        return _buildCleanOrderCard(order);
      },
    );
  }

  Widget _buildLaundryOrderList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.hem * 20),
      itemCount: _laundryOrders.length,
      itemBuilder: (context, index) {
        final order = _laundryOrders[index];
        return _buildLaundryOrderCard(order);
      },
    );
  }

  Widget _buildCleanOrderCard(Orders order) {
    return Card(
      margin: EdgeInsets.only(bottom: SizeConfig.fem * 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () {
          AppRouter.navigateToOrderDetailWithArguments(order.id ?? '');
        },
        title: Text(order.serviceType ?? 'Dịch vụ dọn dẹp',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text('Mã đơn: ${order.code ?? 'Không xác định'}'),
        trailing: CurrencyDisplay(price: order.totalAmount ?? 0),
      ),
    );
  }

  Widget _buildLaundryOrderCard(OrderLaundry order) {
    return Card(
      margin: EdgeInsets.only(bottom: SizeConfig.fem * 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () {
          AppRouter.navigateToLaundryOrderDetailWithArguments(order.id ?? '');
        },
        title: Text(order.name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text('Mã đơn: ${order.orderCode}'),
        trailing: CurrencyDisplay(price: order.totalAmount ?? 0),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text('Đã xảy ra lỗi khi tải dữ liệu',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CAF7D)),
            child: Text('Thử lại',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text('Chưa có đơn hàng nào',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700])),
          const SizedBox(height: 16),
          Text('Hãy bắt đầu sử dụng dịch vụ ngay!',
              style: GoogleFonts.poppins(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
