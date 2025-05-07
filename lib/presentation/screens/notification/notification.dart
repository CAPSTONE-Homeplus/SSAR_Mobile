import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/enums/laundry_order_status.dart';

import '../../../core/enums/order_status.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasource/signalr/order_laundry_remote_data_source.dart';
import '../../../data/datasource/signalr/order_tracking_remote_data_source.dart';
import '../../../domain/entities/order/order_tracking.dart';
import '../../blocs/laundry_order/laundry_order_bloc1.dart';
import '../../blocs/laundry_order/laundry_order_event1.dart';
import '../../blocs/laundry_order/laundry_order_state1.dart';
import '../../blocs/order_tracking_notification/order_tracking_bloc.dart';
import '../../blocs/order_tracking_notification/order_tracking_event.dart';
import '../../blocs/order_tracking_notification/order_tracking_state.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final List<dynamic> _notifications = [];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    context.read<LaundryOrderBloc1>().add(ConnectToLaundryOrderHub1());
    context.read<OrderTrackingBloc1>().add(ConnectToOrderTrackingHub());
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _disconnectHubs() {
    context.read<LaundryOrderBloc1>().add(DisconnectFromLaundryOrderHub1());
    context.read<OrderTrackingBloc1>().add(DisconnectFromOrderTrackingHub());
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MultiBlocListener(
        listeners: [
          BlocListener<LaundryOrderBloc1, LaundryOrderState1>(
            listener: (context, state) {
              print('LaundryOrder State: $state');
              if (state is LaundryOrderNotificationReceived1) {
                print('LaundryOrder Notification: ${state.orderNotification}');
                setState(() {
                  _notifications.insert(0, state.orderNotification);
                });
              }
            },
          ),
          BlocListener<OrderTrackingBloc1, OrderTrackingState1>(
            listener: (context, state) {

              setState(() {
                if (state.orderTrackings.isNotEmpty) {
                  _notifications.insertAll(0, state.orderTrackings);
                }

                if (state.sendOrderToStaffs.isNotEmpty) {
                  _notifications.insertAll(0, state.sendOrderToStaffs);
                }
              });
            },
          ),
        ],
        child: IconButton(
          // Phần còn lại giữ nguyên
          iconSize: 24,
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
              if (_notifications.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_notifications.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: _toggleOverlay,
        ),
      ),
    );
  }

// Sửa lại phương thức _createOverlayEntry để hỗ trợ nhiều loại
  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 10,
        left: 20,
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(-250, size.height + 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thông báo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleOverlay,
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: _notifications.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Chưa có thông báo mới."),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return _buildNotificationItem(notification);
                      },
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

  Widget _buildNotificationItem(dynamic notification) {
    if (notification is SendOrderToStaff) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cleaning_services, // Icon dọn nhà
              size: 16,
              color: Colors.blue[400],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mã đơn ${notification.code ?? 'N/A'} đã được cập nhật sang trạng thái ${OrderStatusExtension.fromString(notification.status ?? 'Không xác định').displayName}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (notification is LaundryOrderToUser) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_laundry_service, // Icon giặt là
              size: 16,
              color: Colors.purple[400],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mã đơn ${notification.orderCode ?? 'N/A'} đã được cập nhật sang trạng thái ${LaundryOrderStatusExtension.fromString(notification.status ?? 'Không xác định').name}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }


}
