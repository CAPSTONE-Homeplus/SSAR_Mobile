import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
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
    context.read<LaundryOrderBloc1>().add(DisconnectFromLaundryOrderHub1());
    context.read<OrderTrackingBloc1>().add(DisconnectFromOrderTrackingHub());
    _overlayEntry?.remove();
    super.dispose();
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

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 10,
        right: 10,
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(-220, size.height + 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
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
                  return ListTile(
                    leading: Icon(
                      Icons.local_laundry_service,
                      color: _getStatusColor(notification.status),
                    ),
                    title: Text('Mã đơn: ${notification.orderCode}'),
                    subtitle: Text(
                      'Trạng thái: ${notification.status}',
                      style: TextStyle(
                        color: _getStatusColor(notification.status),
                      ),
                    ),
                    onTap: () {
                      AppRouter.navigateToLaundryOrderDetail(notification.id);
                      _toggleOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: BlocListener<LaundryOrderBloc1, LaundryOrderState1>(
        listener: (context, state) {
          if (state is LaundryOrderNotificationReceived1) {
            setState(() {
              _notifications.insert(0, state.orderNotification);
            });
          }
        },
        child: BlocListener<OrderTrackingBloc1, OrderTrackingState1>(
          listener: (context, state) {
            if (state is OrderTrackingReceived) {
              setState(() {
                _notifications.insert(0, {
                  'id': state.orderTrackings,
                });
              });
            }
          },
          child: IconButton(
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
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'processing':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
