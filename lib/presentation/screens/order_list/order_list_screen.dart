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
import '../../../core/enums/laundry_order_status.dart';
import '../../../core/enums/order_status.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/order/order_laundry.dart';
import '../../blocs/order/order_bloc.dart';

// Constants
class AppColors {
  static const primaryColor = Color(0xFF1CAF7D);
  static const secondaryColor = Color(0xFF3498DB);
  static const accentColor = Color(0xFFFFA726);
  static const textPrimaryColor = Color(0xFF2D3748);
  static const textSecondaryColor = Color(0xFF718096);
  static const cardBorderColor = Color(0xFFE2E8F0);
  static const backgroundColor = Color(0xFFF5F5F5);
}

class AppStrings {
  static const orderTitle = 'Đơn hàng của bạn';
  static const searchHint = 'Mã đơn hàng';
  static const cleanServiceTab = 'Dọn dẹp';
  static const laundryServiceTab = 'Giặt sấy';
  static const emptyOrderMessage = 'Chưa có đơn hàng nào';
  static const startServiceMessage = 'Hãy bắt đầu sử dụng dịch vụ ngay!';
  static const errorLoadingMessage = 'Đã xảy ra lỗi khi tải dữ liệu';
  static const retryButton = 'Thử lại';
  static const orderCode = 'Mã đơn:';
  static const totalAmount = 'Tổng cộng:';
  static const defaultServiceName = 'Dịch vụ dọn dẹp';
  static const defaultLaundryType = 'Giặt sấy';
}

class OrderListScreen extends StatefulWidget {
  late String? selectedCategory;

   OrderListScreen({Key? key, this.selectedCategory = 'clean'
  }) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _searchController = TextEditingController();
  List<Orders> _filteredCleanOrders = [];
  List<Orders> _allCleanOrders = [];
  List<OrderLaundry> _laundryOrders = [];
  OrderStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrdersByUserEvent());
  }

  void _applyCleanFilters() {
    final query = _searchController.text.toLowerCase();

    final filtered = _allCleanOrders.where((order) {
      final code = order.code?.toLowerCase() ?? '';
      return query.isEmpty || code.contains(query);
    }).toList();

    setState(() {
      _filteredCleanOrders = filtered;
    });
  }

  void _switchCategory(String category) {
    setState(() {
      widget.selectedCategory = category;
    });

    if (category == 'clean') {
      context.read<OrderBloc>().add(GetOrdersByUserEvent());
    } else {
      context
          .read<LaundryOrderBlocV2>()
          .add(GetLaundryOrdersV2('laundry-user-id-goes-here'));
    }
  }

  void _applyStatusCleanFilters() {
    context
        .read<OrderBloc>()
        .add(GetOrdersByUserEvent(search: _selectedStatus?.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: AppStrings.orderTitle),
      body: SafeArea(
        child: Column(
          children: [
            FilterTabs(
              selectedCategory:  widget.selectedCategory ?? 'clean',
              onCategorySelected: _switchCategory,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.hem * 20,
                vertical: SizeConfig.fem * 8,
              ),
              child: Row(
                children: [
                  SizedBox(child: _buildStatusDropdown()),
                  SizedBox(width: SizeConfig.fem * 8),
                  Expanded(
                    child: SearchBar(
                      controller: _searchController,
                      onChanged: (_) {
                        if ( widget.selectedCategory == 'clean') {
                          _applyCleanFilters();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:  widget.selectedCategory == 'clean'
                  ? _buildCleanOrdersContent()
                  : _buildLaundryOrdersContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanOrdersContent() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) return const LoadingState();

        if (state is OrderError) {
          return ErrorState(
            onRetry: () {
              context.read<OrderBloc>().add(GetOrdersByUserEvent());
            },
          );
        }

        if (state is OrdersByUserLoaded) {
          _allCleanOrders = state.orders.items ?? [];

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applyCleanFilters();
          });

          return _filteredCleanOrders.isEmpty
              ? const EmptyState()
              : CleanOrderList(orders: _filteredCleanOrders);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLaundryOrdersContent() {
    return BlocBuilder<LaundryOrderBlocV2, LaundryOrderStateV2>(
      builder: (context, state) {
        if (state is LaundryOrderLoadingV2) return const LoadingState();

        if (state is LaundryOrderFailureV2) {
          return ErrorState(
            onRetry: () {
              context
                  .read<LaundryOrderBlocV2>()
                  .add(GetLaundryOrdersV2('laundry-user-id-goes-here'));
            },
          );
        }

        if (state is LaundryOrderLoadedV2) {
          _laundryOrders = state.orders;

          return _laundryOrders.isEmpty
              ? const EmptyState()
              : LaundryOrderList(orders: _laundryOrders);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonHideUnderline(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: SizeConfig.fem * 120,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButton<OrderStatus>(
          value: _selectedStatus,
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12 * SizeConfig.fem),
            child: Text(
              'Trạng thái',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12 * SizeConfig.ffem,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: 8 * SizeConfig.fem),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
              size: 24 * SizeConfig.ffem,
            ),
          ),
          underline: Container(),
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 14 * SizeConfig.ffem,
          ),
          dropdownColor: Colors.white,
          onChanged: (OrderStatus? newValue) {
            setState(() {
              _selectedStatus = newValue;

              // Reapply filters based on current category
              if (widget.selectedCategory == 'clean') {
                _applyStatusCleanFilters();
              }
            });
          },
          items: [
            // Add a "All" option
            DropdownMenuItem<OrderStatus>(
              value: null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * SizeConfig.fem),
                child: Text(
                  'Tất cả',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 12 * SizeConfig.ffem,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            // Add specific status options
            ...OrderStatus.values
                .map<DropdownMenuItem<OrderStatus>>((OrderStatus status) {
              return DropdownMenuItem<OrderStatus>(
                value: status,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12 * SizeConfig.fem),
                  child: Row(
                    children: [
                      Icon(
                        status.icon,
                        color: status.color,
                        size: 20 * SizeConfig.ffem,
                      ),
                      SizedBox(width: 8 * SizeConfig.fem),
                      Expanded(
                        child: Text(
                          status.displayName,
                          style: GoogleFonts.poppins(
                            color: status.color,
                            fontSize: 14 * SizeConfig.ffem,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Extracted Widgets
class FilterTabs extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FilterTabs({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 20,
        vertical: SizeConfig.fem * 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton('clean', AppStrings.cleanServiceTab),
          _buildFilterButton('laundry', AppStrings.laundryServiceTab),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = selectedCategory == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onCategorySelected(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.fem * 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.hem * 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.fem * 10,
      ),
      child: Container(
        height: SizeConfig.fem * 48,
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
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.ffem * 12,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: SizeConfig.hem * 12,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.primaryColor,
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
}

class CleanOrderList extends StatelessWidget {
  final List<Orders> orders;

  const CleanOrderList({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderBloc>().add(GetOrdersByUserEvent());
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.hem * 20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return CleanOrderCard(order: order);
        },
      ),
    );
  }
}

class LaundryOrderList extends StatelessWidget {
  final List<OrderLaundry> orders;

  const LaundryOrderList({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<LaundryOrderBlocV2>()
            .add(GetLaundryOrdersV2('laundry-user-id-goes-here'));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.hem * 20),

        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return LaundryOrderCard(order: order);
        },
      ),
    );
  }
}

class CleanOrderCard extends StatelessWidget {
  final Orders order;

  const CleanOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.fem * 16),
      child: OrderCardBase(
        onTap: () {
          AppRouter.navigateToOrderDetailWithArguments(order.id ?? '');
        },
        title: order.serviceType ?? AppStrings.defaultServiceName,
        statusWidget: OrderStatusChip(status: order.status ?? ''),
        dateText: order.timeSlotDetail ?? 'Đặt ngay',
        orderCode: order.code != null
            ? order.code!.length > 20
                ? (order.code?.substring(0, 20) ?? 'Không xác định') + '...'
                : (order.code ?? 'Không xác định')
            : 'Không xác định',
        totalAmount: order.totalAmount?.toDouble() ?? 0,
      ),
    );
  }
}

class LaundryOrderCard extends StatelessWidget {
  final OrderLaundry order;

  const LaundryOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.fem * 16),
      child: OrderCardBase(
        onTap: () {
          AppRouter.navigateToLaundryOrderDetailWithArguments(order.id ?? '');
        },
        title: order.name,
        statusWidget: LaundryStatusChip(status: order.status ?? 'pending'),
        dateText: order.orderDate.toString(),
        serviceType: order.type ?? AppStrings.defaultLaundryType,
        orderCode: order.orderCode ?? 'Không xác định',
        totalAmount: order.totalAmount ?? 0,
      ),
    );
  }
}

class OrderCardBase extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Widget statusWidget;
  final String dateText;
  final String? serviceType;
  final String orderCode;
  final double totalAmount;

  const OrderCardBase({
    Key? key,
    required this.onTap,
    required this.title,
    required this.statusWidget,
    required this.dateText,
    this.serviceType,
    required this.orderCode,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(SizeConfig.hem * 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.hem * 16,
                        color: AppColors.textPrimaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  statusWidget,
                ],
              ),
              SizedBox(height: SizeConfig.fem * 12),
              if (serviceType != null)
                ServiceTypeLabel(serviceType: serviceType!),
              SizedBox(height: SizeConfig.fem * 12),
              DateLabel(dateText: dateText),
              SizedBox(height: SizeConfig.fem * 8),
              Divider(color: AppColors.cardBorderColor, thickness: 1),
              SizedBox(height: SizeConfig.fem * 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderCodeDisplay(code: orderCode),
                  OrderTotalDisplay(amount: totalAmount),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ServiceTypeLabel extends StatelessWidget {
  final String serviceType;

  const ServiceTypeLabel({Key? key, required this.serviceType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 10,
        vertical: SizeConfig.fem * 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_laundry_service,
            size: SizeConfig.hem * 16,
            color: AppColors.secondaryColor,
          ),
          SizedBox(width: SizeConfig.hem * 6),
          Text(
            serviceType,
            style: GoogleFonts.poppins(
              fontSize: SizeConfig.hem * 12,
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DateLabel extends StatelessWidget {
  final String dateText;

  const DateLabel({Key? key, required this.dateText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: SizeConfig.hem * 14,
          color: AppColors.accentColor,
        ),
        SizedBox(width: SizeConfig.hem * 6),
        Text(
          dateText,
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.hem * 12,
            color: AppColors.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

class OrderCodeDisplay extends StatelessWidget {
  final String code;

  const OrderCodeDisplay({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.orderCode,
          style: GoogleFonts.poppins(
            color: AppColors.textSecondaryColor,
            fontSize: SizeConfig.hem * 12,
          ),
        ),
        SizedBox(height: SizeConfig.fem * 4),
        Text(
          code,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor,
            fontSize: SizeConfig.hem * 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class OrderTotalDisplay extends StatelessWidget {
  final double amount;

  const OrderTotalDisplay({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.totalAmount,
          style: GoogleFonts.poppins(
            color: AppColors.textSecondaryColor,
            fontSize: SizeConfig.hem * 12,
          ),
        ),
        SizedBox(height: SizeConfig.fem * 4),
        CurrencyDisplay(
          price: amount,
        ),
      ],
    );
  }
}

class OrderStatusChip extends StatelessWidget {
  final String status;

  const OrderStatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderStatus orderStatus = status.toOrderStatus();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 10,
        vertical: SizeConfig.fem * 4,
      ),
      decoration: BoxDecoration(
        color: orderStatus.chipColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: orderStatus.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            orderStatus.icon,
            size: SizeConfig.hem * 14,
            color: orderStatus.textColor,
          ),
          SizedBox(width: SizeConfig.hem * 4),
          Text(
            orderStatus.displayName,
            style: GoogleFonts.poppins(
              color: orderStatus.textColor,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.hem * 12,
            ),
          ),
        ],
      ),
    );
  }
}

class LaundryStatusChip extends StatelessWidget {
  final String status;

  const LaundryStatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LaundryOrderStatus orderStatus;
    try {
      orderStatus = LaundryOrderStatusExtension.fromString(status);
    } catch (e) {
      // Fallback to draft if status is invalid
      orderStatus = LaundryOrderStatus.draft;
    }

    // Define color variables based on the enum's color
    final Color mainColor = orderStatus.color;
    final Color bgColor = mainColor.withOpacity(0.1);
    final Color borderColor = mainColor.withOpacity(0.3);

    // Define icon based on status
    IconData iconData;
    switch (orderStatus) {
      case LaundryOrderStatus.draft:
        iconData = Icons.edit_note;
        break;
      case LaundryOrderStatus.pendingPayment:
        iconData = Icons.payment;
        break;
      case LaundryOrderStatus.processing:
        iconData = Icons.autorenew;
        break;
      case LaundryOrderStatus.completed:
        iconData = Icons.check_circle;
        break;
      case LaundryOrderStatus.cancelled:
        iconData = Icons.cancel;
        break;
      case LaundryOrderStatus.paid:
        iconData = Icons.attach_money;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.hem * 10,
        vertical: SizeConfig.fem * 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: SizeConfig.hem * 14,
            color: mainColor,
          ),
          SizedBox(width: SizeConfig.hem * 4),
          Text(
            orderStatus.name,
            style: GoogleFonts.poppins(
              color: mainColor,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.hem * 12,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorState({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            AppStrings.errorLoadingMessage,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(
              AppStrings.retryButton,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            AppStrings.emptyOrderMessage,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.startServiceMessage,
            style: GoogleFonts.poppins(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
