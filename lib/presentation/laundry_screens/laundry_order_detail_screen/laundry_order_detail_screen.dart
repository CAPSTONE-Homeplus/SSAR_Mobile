import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../core/enums/laundry_order_status.dart';
import '../../../data/laundry_repositories/laundry_order_repo.dart';
import '../../laundry_blocs/order/laundry_order_bloc.dart';
import '../../laundry_blocs/order/laundry_order_event.dart';
import '../../laundry_blocs/order/laundry_order_state.dart';

class LaundryOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const LaundryOrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<LaundryOrderDetailScreen> createState() => _LaundryOrderDetailScreenState();
}

class _LaundryOrderDetailScreenState extends State<LaundryOrderDetailScreen> {
  late final LaundryOrderDetailModel order;


  @override
  void initState() {
    super.initState();
    context.read<LaundryOrderBloc>().add(GetLaundryOrderEvent(widget.orderId));
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF1CAF7D);
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Chi Tiết Đơn Giặt',
        onBackPressed: () => AppRouter.navigateToHome(),
      ),
      body: BlocBuilder<LaundryOrderBloc, LaundryOrderState>(
        builder: (context, state) {
          if (state is LaundryOrderLoading) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          } else if (state is LaundryOrderFailure) {
            return Center(child: Text("Lỗi"));
          } else if (state is GetLaundrySuccess) {
            final order = state.order;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info Card
                    _buildCard(
                      title: 'Thông Tin Đơn Hàng',
                      content: Column(
                        children: [
                          _buildInfoRow('Mã đơn hàng:', order.orderCode, boldValue: true),
                          _buildInfoRow('Tên đơn hàng:', order.name),
                          _buildInfoRow('Loại dịch vụ:', order.type),
                          _buildInfoRow('Trạng thái:', LaundryOrderStatusExtension.fromString(order.status ?? '').name,
                              valueColor: LaundryOrderStatusExtension.fromString(order.status ?? '').color),
                          _buildInfoRow('Ngày đặt:', _formatDate(order.orderDate)),
                          if (order.deliveryDate != null)
                            _buildInfoRow('Ngày giao:', _formatDate(order.deliveryDate)),
                          if (order.estimatedCompletionTime != null)
                            _buildInfoRow('Dự kiến hoàn thành:', _formatDate(order.estimatedCompletionTime)),
                        ],
                      ),
                      icon: Icons.receipt_long,
                      color: primaryColor,
                    ),

                    const SizedBox(height: 16),

                    _buildCard(
                      title: 'Tổng Quan Chi Phí',
                      content: Column(
                        children: [
                          _buildInfoRow(
                            'Tổng cộng:',
                            currencyFormatter.format(order.totalAmount ?? 0.0),
                            boldValue: true,
                            valueColor: primaryColor,
                          ),
                          if (order.discountAmount != null && order.discountAmount! > 0)
                            _buildInfoRow(
                              'Giảm giá:',
                              '- ${currencyFormatter.format(order.discountAmount)}',
                              valueColor: Colors.red,
                            ),
                          if (order.discountAmount != null && order.discountAmount! < 0)
                            _buildInfoRow(
                              'Giảm giá:',
                              '+ ${currencyFormatter.format(order.discountAmount)}',
                              valueColor: Colors.green,
                            ),
                          _buildInfoRow(
                            'Thanh toán:',
                            currencyFormatter.format((order.totalAmount ?? 0.0) - (order.discountAmount ?? 0.0)),
                            boldValue: true,
                            valueColor: primaryColor,
                          ),
                        ],
                      ),
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 16),
                    // Additional Services
                    _buildCard(
                      title: 'Dịch Vụ Bổ Sung',
                      content: Column(
                        children: order.orderAdditionalServicesResponse.map((service) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    service.name ?? 'Dịch vụ không tên',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(service.price ?? 0),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      icon: Icons.add_circle,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    if (order.orderDetailsByKg!.isNotEmpty)
                      _buildCard(
                        title: 'Đồ Giặt Tính Theo Ký',
                        content: Column(
                          children: [
                            ...order.orderDetailsByKg!.map((item) => _buildItemRow(
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
                          ],
                        ),
                        icon: Icons.scale,
                        color: Colors.orange,
                      ),

                    const SizedBox(height: 16),

                    // Items By Piece
                    if (order.orderDetailsByItem.isNotEmpty)
                      _buildCard(
                        title: 'Đồ Giặt Tính Theo Món',
                        content: Column(
                          children: [
                            ...order.orderDetailsByItem!.map((item) => _buildItemRow(
                              item.itemTypeResponse?.name ?? 'Không tên',
                              quantity: item.quantity,
                              price: item!.unitPrice,
                              subtotal: item.subtotal,
                              notes: item.notes,
                              isKgBased: false,
                              currencyFormatter: currencyFormatter,
                              context: context,
                            )),
                          ],
                        ),
                        icon: Icons.checkroom,
                        color: Colors.purple,
                      ),

                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                        LaundryOrderStatusExtension.fromString(order.status ?? '').name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Vui lòng đợi trong giây lát'));
          }
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget content,
    required IconData icon,
    required Color color
  }) {
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

  Widget _buildInfoRow(String label, String? value, {
    bool boldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 14,
              fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
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
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                currencyFormatter.format(subtotal ?? 0),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1CAF7D),
                ),
              ),
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
              _buildDetailPill(
                Icons.attach_money,
                currencyFormatter.format(price ?? 0),
                context,
                color: Colors.green,
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

  Widget _buildDetailPill(IconData icon, String text, BuildContext context, {Color? color}) {
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
  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'chờ xử lý':
        return Colors.orange;
      case 'processing':
      case 'đang xử lý':
        return Colors.blue;
      case 'completed':
      case 'hoàn thành':
        return Colors.green;
      case 'cancelled':
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }


  VoidCallback _getActionButtonCallback(BuildContext context, String? status) {
    return () {
      // Here you would implement different actions based on the order status
      if (status == null) {
        Navigator.pop(context);
        return;
      }

      switch (status.toLowerCase()) {
        case 'pending':
        case 'chờ xử lý':
          _showCancelConfirmation(context);
          break;
        case 'processing':
        case 'đang xử lý':
        // Navigate to order tracking
          break;
        case 'completed':
        case 'hoàn thành':
        case 'cancelled':
        case 'đã hủy':
        // Navigate to reorder screen
          break;
        default:
          Navigator.pop(context);
      }
    };
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận hủy đơn'),
        content: Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement cancel order logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đơn hàng đã được hủy thành công')),
              );
            },
            child: Text('Có', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}