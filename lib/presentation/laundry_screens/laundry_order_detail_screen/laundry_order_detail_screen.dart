import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/task/task_bloc.dart';
import 'package:home_clean/presentation/laundry_blocs/cancel/cancel_order_bloc.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';
import 'package:intl/intl.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../core/constant/colors.dart';
import '../../../core/enums/laundry_order_status.dart';
import '../../../core/enums/wallet_enums.dart';
import '../../../data/laundry_repositories/laundry_order_repo.dart';
import '../../blocs/laundry_order/laundry_order_bloc1.dart';
import '../../blocs/laundry_order/laundry_order_event1.dart';
import '../../blocs/laundry_order/laundry_order_state1.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../blocs/wallet/wallet_state.dart';
import '../../laundry_blocs/cancel/cancel_order_event.dart';
import '../../laundry_blocs/cancel/cancel_order_state.dart';
import '../../laundry_blocs/order/laundry_order_bloc.dart';
import '../../laundry_blocs/order/laundry_order_event.dart';
import '../../laundry_blocs/order/laundry_order_state.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/currency_display.dart';
import '../../widgets/section_widget.dart';
import 'components/OrderPaymentButton.dart';
import 'components/task_section_widget.dart';

class LaundryOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const LaundryOrderDetailScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<LaundryOrderDetailScreen> createState() =>
      _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends State<LaundryOrderDetailScreen> {
  late final LaundryOrderDetailModel order;
  String? selectedWalletId;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    context.read<LaundryOrderBloc>().add(GetLaundryOrderEvent(widget.orderId));
    context.read<LaundryOrderBloc1>().add(ConnectToLaundryOrderHub1());
    context.read<TaskBloc>().add(FetchOrderTasksEvent(orderId: widget.orderId));
  }

  @override
  void dispose() {
    context.read<LaundryOrderBloc1>().add(DisconnectFromLaundryOrderHub1());
    print('Disconnecting from LaundryOrderBloc');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF1CAF7D);
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Chi Tiết Đơn Giặt',
        onBackPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              initialIndex: 1,
              selectedCategory: "laundry",
              child: Container(),
            ),
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // Notification Listener
          BlocListener<LaundryOrderBloc1, LaundryOrderState1>(
            listenWhen: (previous, current) =>
                current is LaundryOrderNotificationReceived1,
            listener: (context, state) {
              if (state is LaundryOrderNotificationReceived1) {
                final noti = state.orderNotification;
                if (noti.id == widget.orderId) {
                  context
                      .read<LaundryOrderBloc>()
                      .add(GetLaundryOrderEvent(widget.orderId));
                }
              }
            },
          ),
          BlocListener<CancelOrderBloc, CancelOrderState>(
            listenWhen: (previous, current) =>
                current is CancelLaundryOrderSuccess ||
                current is CancelLaundryOrderFailure,
            listener: (context, state) {
              if (state is CancelLaundryOrderSuccess) {
                _refreshKey.currentState?.show();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đơn hàng đã được hủy thành công'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is CancelLaundryOrderFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Không thể hủy đơn hàng"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          )
        ],
        child: BlocBuilder<LaundryOrderBloc, LaundryOrderState>(
          builder: (context, state) {
            if (state is LaundryOrderLoading) {
              return Center(
                  child: CircularProgressIndicator(color: primaryColor));
            } else if (state is LaundryOrderFailure) {
              return Center(child: Text("Lỗi"));
            } else if (state is GetLaundrySuccess) {
              final order = state.order;

              return RefreshIndicator(
                key: _refreshKey,
                onRefresh: () {
                  context
                      .read<LaundryOrderBloc>()
                      .add(GetLaundryOrderEvent(widget.orderId));
                  return Future.value();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard(
                          title: 'Thông Tin Đơn Hàng',
                          content: Column(
                            children: [
                              _buildInfoRow('Mã đơn hàng:', order.orderCode,
                                  boldValue: true),
                              _buildInfoRow('Tên đơn hàng:', order.name),
                              // _buildInfoRow('Loại dịch vụ:', order.type),
                              _buildInfoRow(
                                  'Trạng thái:',
                                  LaundryOrderStatusExtension.fromString(
                                          order.status ?? '')
                                      .name,
                                  valueColor:
                                      LaundryOrderStatusExtension.fromString(
                                              order.status ?? '')
                                          .color),
                              _buildInfoRow(
                                  'Ngày đặt:', _formatDate(order.orderDate)),
                              if (order.deliveryDate != null)
                                _buildInfoRow('Ngày giao:',
                                    _formatDate(order.deliveryDate)),
                              if (order.estimatedCompletionTime != null)
                                _buildInfoRow('Dự kiến hoàn thành:',
                                    _formatDate(order.estimatedCompletionTime)),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.receipt,
                                      color: Colors.orange, size: 20),
                                  const SizedBox(width: 8),
                                  Text("Dịch vụ bổ sung:",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...order.orderAdditionalServicesResponse.map(
                                (service) => _buildInfoRow(
                                  service.name,
                                  currencyFormatter.format(service.price),
                                  isPrice: true,
                                  boldValue: true,
                                  valueColor: primaryColor,
                                  price: (service.price),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  AppRouter.navigateToLaundryOrderTracking(
                                      order);
                                },
                                label: const Text('Theo Dõi Đơn Hàng'),
                                icon: const Icon(Icons.track_changes_sharp),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                  foregroundColor: Colors.blue.shade700,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          icon: Icons.receipt_long,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildLaundryDetailsCard(context, order),
                        const SizedBox(height: 16),
                        _buildCard(
                          title: 'Chi Phí',
                          content: Column(
                            children: [
                              _buildInfoRow('Tổng cộng:', null,
                                  isPrice: true,
                                  price: order.totalAmount,
                                  boldValue: true,
                                  valueColor: primaryColor)
                            ],
                          ),
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        LaundryOrderStatusExtension.fromString(
                                    order.status ?? '') ==
                                LaundryOrderStatus.pendingPayment
                            ? _buildWallet(context)
                            : SizedBox(height: 16),
                        const SizedBox(height: 16),
                        OrderPaymentButton(
                          order: order,
                          selectedWalletId: selectedWalletId ?? '',
                          onSuccess: () {
                            showSuccessDialog(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        LaundryOrderStatusExtension.fromString(
                            order.status ?? '') ==
                            LaundryOrderStatus.pendingPayment
                            ? _buildCancelOrderButton(order)
                            : SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: Text('Vui lòng đợi trong giây lát'));
            }
          },
        ),
      ),
    );
  }

  // Improved cancel order button implementation
  Widget _buildCancelOrderButton(LaundryOrderDetailModel order) {
    if (LaundryOrderStatusExtension.fromString(order.status ?? '') !=
            LaundryOrderStatus.pendingPayment &&
        LaundryOrderStatusExtension.fromString(order.status ?? '') !=
            LaundryOrderStatus.processing) {
      return SizedBox
          .shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Xác Nhận Hủy Đơn'),
              content: Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Không', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<CancelOrderBloc>().add(
                          CancelLaundryOrderEvent(order.id),
                        );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Có', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Hủy Đơn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'Thanh Toán Thành Công',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _refreshKey.currentState?.show();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thoát',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaundryDetailsCard(
      BuildContext context, LaundryOrderDetailModel order) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // Check if both kg-based and item-based lists are empty
    if ((order.orderDetailsByKg.isEmpty ?? true) &&
        order.orderDetailsByItem.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.local_laundry_service,
                    color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Chi Tiết Đơn Hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kg-based Items Section
                if (order.orderDetailsByKg.isNotEmpty ?? false) ...[
                  Text(
                    'Đồ Giặt Tính Theo Ký',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...order.orderDetailsByKg.map((item) => _buildItemRow(
                        item.itemTypeResponse.name ?? 'Không tên',
                        quantity: item.quantity,
                        weight: item.weight,
                        actualWeight: item.actualWeight,
                        price: item.unitPrice,
                        subtotal: item.subtotal,
                        notes: item.notes,
                        isKgBased: true,
                        currencyFormatter: currencyFormatter,
                        context: context,
                      )),
                  const SizedBox(height: 16),
                ],

                // Item-based Section
                if (order.orderDetailsByItem.isNotEmpty) ...[
                  Text(
                    'Đồ Giặt Tính Theo Món',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...order.orderDetailsByItem.map(
                    (item) => _buildItemRow(
                      item.itemTypeResponse.name ?? 'Không tên',
                      quantity: item.quantity,
                      price: item.unitPrice,
                      subtotal: item.subtotal,
                      notes: item.notes,
                      isKgBased: false,
                      currencyFormatter: currencyFormatter,
                      context: context,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWallet(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is WalletLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 3,
            ),
          );
        } else if (state is WalletLoaded) {
          return SectionWidget(
            margin: const EdgeInsets.only(top: 16),
            title: 'Chọn ví thanh toán',
            icon: Icons.account_balance_wallet_outlined,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.wallets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final wallet = state.wallets[index];
                  final isSelected = wallet.id == selectedWalletId;
                  final walletTitle = wallet.type == WalletType.personal
                      ? '${wallet.type} (Ví riêng)'
                      : wallet.type;

                  return _buildPaymentOption(
                    title: walletTitle ?? '',
                    balance: wallet.balance?.toInt() ?? 0,
                    icon: Icons.account_balance,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedWalletId = wallet.id;
                      });
                    },
                  );
                },
              ),
            ),
          );
        } else if (state is WalletError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  "Lỗi: ${state.message}",
                  style: GoogleFonts.poppins(
                    color: Colors.red[700],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Không có dữ liệu ví",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required int balance,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: 'wallet_$title',
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withAlpha(8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withAlpha(1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: !isSelected
                          ? AppColors.primaryColor.withAlpha(1)
                          : Colors.green.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.green[700]
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        CurrencyDisplay(
                          price: balance,
                          fontSize: 14,
                          iconSize: 16,
                          unit: '',
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha((0.1 * 255).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required Widget content,
      required IconData icon,
      required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String? value, {
    bool boldValue = false,
    Color? valueColor,
    bool isPrice = false,
    double? price,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          isPrice && price != null
              ? CurrencyDisplay(
                  price: price,
                )
              : Text(
                  value ?? 'Cập nhật sau',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
                    color: valueColor ?? Colors.black,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    String itemName, {
    required int? quantity,
    double? weight,
    double? actualWeight,
    required double? price,
    required double? subtotal,
    required String? notes,
    required bool isKgBased,
    required NumberFormat currencyFormatter,
    required BuildContext context,
  }) {
    final displayPrice = subtotal == 0 ? quantity! * price! : subtotal;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              CurrencyDisplay(price: displayPrice),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (isKgBased) ...[
                _buildDetailPill(
                  Icons.scale,
                  '${weight?.toStringAsFixed(2) ?? '0'} kg',
                  context,
                ),
                if (actualWeight != null && actualWeight > 0)
                  _buildDetailPill(
                    Icons.fact_check,
                    'Thực tế: ${actualWeight.toStringAsFixed(2)} kg',
                    context,
                    color: Colors.blue,
                  ),
              ] else
                _buildDetailPill(
                  Icons.format_list_numbered,
                  'SL: ${quantity ?? 0}',
                  context,
                ),
            ],
          ),
          if (notes != null && notes.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Ghi chú: $notes',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailPill(IconData icon, String text, BuildContext context,
      {Color? color}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey[700])!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? Colors.grey[700])!.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? Colors.grey[700],
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
