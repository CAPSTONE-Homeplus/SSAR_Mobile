import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/size_config.dart';
import '../../../core/enums/order_status.dart';
import '../../../domain/entities/order/order.dart';
import '../../blocs/order/order_bloc.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _searchController = TextEditingController();
  List<Orders> _filteredOrders = [];
  List<Orders> _allOrders = [];

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrdersByUserEvent());
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _allOrders;
      } else {
        _filteredOrders = _allOrders.where((order) {
          return (order.code?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (order.serviceType?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (order.status?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: 'Đơn hàng của bạn'),
      body: SafeArea(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return _buildLoadingState();
            }

            if (state is OrderError) {
              return _buildErrorState(context);
            }

            if (state is OrdersByUserLoaded) {
              _allOrders = state.orders.items ?? [];
              _filteredOrders = _allOrders;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: _filteredOrders.isEmpty
                        ? _buildEmptyState()
                        : _buildOrderList(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
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
          onChanged: _filterOrders,
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

  Widget _buildOrderList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 20,
      ),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Orders order) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.fem * 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppRouter.navigateToOrderDetailWithArguments(order.id ?? '');
          },
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.hem * 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.serviceType ?? 'Dịch vụ dọn dẹp',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.hem * 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(order.status!.toOrderStatus()),
                  ],
                ),
                SizedBox(height: SizeConfig.fem * 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(

                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.emergencyRequest == true
                            ? Icons.bolt
                            : Icons.schedule,
                        size: 16,
                        color: order.emergencyRequest == true
                            ? Colors.red[700]
                            : Colors.green[700],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.fem * 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mã đơn:',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: SizeConfig.hem * 14,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: SizeConfig.screenWidth * 0.6,
                      ),
                      child: Text(
                        order.code ?? 'Không xác định',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: SizeConfig.hem * 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.fem * 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng:',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: SizeConfig.hem * 14,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CurrencyDisplay(price: order.totalAmount ?? 0),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow({
    required IconData icon,
    required String text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF1CAF7D),
          size: SizeConfig.hem * 18,
        ),
        SizedBox(width: SizeConfig.hem * 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: SizeConfig.hem * 14,
              color: Colors.grey[800],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 10,
        vertical: SizeConfig.fem * 4,
      ),
      decoration: BoxDecoration(
        color: status.chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.displayName,
        style: GoogleFonts.poppins(
          color: status.textColor,
          fontSize: SizeConfig.hem * 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF1CAF7D)),
          ),
          SizedBox(height: SizeConfig.fem * 16),
          Text(
            'Đang tải đơn hàng...',
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontSize: SizeConfig.fem * 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: SizeConfig.hem * 80,
          ),
          SizedBox(height: SizeConfig.fem * 16),
          Text(
            'Lỗi: Không thể tải đơn hàng',
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: SizeConfig.fem * 18,
            ),
          ),
          SizedBox(height: SizeConfig.fem * 16),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(GetOrdersByUserEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CAF7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Thử lại',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: SizeConfig.fem * 16,
              ),
            ),
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
          SizedBox(height: SizeConfig.fem * 24),
          Text(
            'Chưa có đơn hàng nào',
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontSize: SizeConfig.hem * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SizeConfig.fem * 16),
          Text(
            'Hãy đặt dịch vụ đầu tiên của bạn ngay!',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: SizeConfig.hem * 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
