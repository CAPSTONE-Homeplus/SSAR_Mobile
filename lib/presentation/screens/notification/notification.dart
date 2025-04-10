import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/notification/notification.dart';
import 'package:intl/intl.dart';

import '../../../data/datasource/signalr/order_laundry_remote_data_source.dart';
import '../../blocs/laundry_order/laundry_order_bloc1.dart';
import '../../blocs/laundry_order/laundry_order_event1.dart';
import '../../blocs/laundry_order/laundry_order_state1.dart'; // Make sure to import this
import '../../blocs/notification/notification_bloc.dart';
import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  final OrderLaundryRemoteDataSource remoteDataSource;

  const NotificationScreen({
    Key? key,
    required this.remoteDataSource,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Định nghĩa màu chính - tương tự bTaskee
  @override
  void initState() {
    super.initState();
    context.read<LaundryOrderBloc1>().add(ConnectToLaundryOrderHub1());
    context.read<NotificationBloc>().add(ConnectToHubEvent());
    context.read<NotificationBloc>().add(LoadNotificationsEvent());

    // Print a debug message to confirm LaundryOrderBloc is connected
    print('Connecting to LaundryOrderBloc');
  }

  @override
  void dispose() {
    context.read<NotificationBloc>().add(DisconnectFromHubEvent());
    context.read<LaundryOrderBloc1>().add(DisconnectFromLaundryOrderHub1());
    print('Disconnecting from LaundryOrderBloc');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<NotificationBloc>().add(RefreshNotificationsEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add a BlocListener for LaundryOrderBloc to log state changes
          BlocListener<LaundryOrderBloc1, LaundryOrderState1>(
            listener: (context, state) {
              // Log whenever LaundryOrderBloc state changes
              print('LaundryOrderBloc state changed: ${state.runtimeType}');

              // Add more detailed logging based on specific states
              if (state is LaundryOrderHubConnected1) {
                print('LaundryOrder hub connected successfully');
              } else if (state is LaundryOrderHubDisconnected1) {
                print('LaundryOrder hub disconnected');
              } else if (state is LaundryOrderNotificationReceived1) {
                print('LaundryOrder notification received: ${state.orderNotification.toString()}');
              } else if (state is LaundryOrderError1) {
                print('LaundryOrder error: ${state.errorMessage}');
              }
            },
            child: SizedBox(), // Empty widget as we only need the listener
          ),

          // Optional: Add a small section to display LaundryOrderBloc status
          BlocBuilder<LaundryOrderBloc1, LaundryOrderState1>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Text(
                      'Laundry Order Status: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getLaundryOrderStatusText(state),
                      style: TextStyle(
                        fontSize: 14,
                        color: _getLaundryOrderStatusColor(state),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Existing NotificationBloc builder
          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationInitial || state is NotificationLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  );
                } else if (state is NotificationLoaded) {
                  final notifications = state.notifications;

                  if (notifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      context.read<NotificationBloc>().add(RefreshNotificationsEvent());
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 8),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationItem(
                          notification: notifications[index],
                        );
                      },
                    ),
                  );
                } else if (state is NotificationError) {
                  return _buildErrorState(state.message);
                }

                return Container();
              },
            ),
          ),
        ],
      ),
      // Add a button to debug LaundryOrderBloc
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.bug_report),
        onPressed: () {
          _showLaundryOrderDebugPanel(context);
        },
      ),
    );
  }

  String _getLaundryOrderStatusText(LaundryOrderState1 state) {
    if (state is LaundryOrderInitial1) return 'Initializing';
    if (state is LaundryOrderHubConnecting1) return 'Connecting';
    if (state is LaundryOrderHubConnected1) return 'Connected';
    if (state is LaundryOrderHubDisconnected1) return 'Disconnected';
    if (state is LaundryOrderNotificationReceived1) return 'Notification Received';
    if (state is LaundryOrderError1) return 'Error: ${state.errorMessage}';
    return 'Unknown';
  }

  Color _getLaundryOrderStatusColor(LaundryOrderState1 state) {
    if (state is LaundryOrderInitial1) return Colors.grey;
    if (state is LaundryOrderHubConnecting1) return Colors.blue;
    if (state is LaundryOrderHubConnected1) return Colors.green;
    if (state is LaundryOrderHubDisconnected1) return Colors.orange;
    if (state is LaundryOrderNotificationReceived1) return Colors.purple;
    if (state is LaundryOrderError1) return Colors.red;
    return Colors.grey;
  }

  void _showLaundryOrderDebugPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Laundry Order Debug Panel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<LaundryOrderBloc1, LaundryOrderState1>(
                  builder: (context, state) {
                    if (state is LaundryOrderHubConnecting1) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Connecting to hub...'),
                          ],
                        ),
                      );
                    } else if (state is LaundryOrderNotificationReceived1) {
                      final notification = state.orderNotification;
                      return Card(
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Latest Order Notification',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text('Type: ${notification.runtimeType}'),
                              SizedBox(height: 8),
                              Text('Details:'),
                              SizedBox(height: 8),
                              Text(notification.toString()),
                            ],
                          ),
                        ),
                      );
                    } else if (state is LaundryOrderError1) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is LaundryOrderHubConnected1) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Connected to LaundryOrder Hub',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Waiting for notifications...'),
                          ],
                        ),
                      );
                    } else if (state is LaundryOrderHubDisconnected1) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off,
                              color: Colors.orange,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Disconnected from LaundryOrder Hub',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: Text('Laundry Order Hub Status: ${state.runtimeType}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Reconnect to hub
                      print('Manually reconnecting to LaundryOrderHub');
                      context.read<LaundryOrderBloc1>().add(ConnectToLaundryOrderHub1());
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reconnect to Hub'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Disconnect from hub
                      print('Manually disconnecting from LaundryOrderHub');
                      context.read<LaundryOrderBloc1>().add(DisconnectFromLaundryOrderHub1());
                    },
                    icon: Icon(Icons.power_settings_new),
                    label: Text('Disconnect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Text(
            'Bạn chưa có thông báo nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Thông báo sẽ xuất hiện khi có cập nhật về đơn hàng của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationBloc>().add(RefreshNotificationsEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Làm mới'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 24),
            Text(
              'Không thể tải thông báo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Đã xảy ra lỗi: $message',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(LoadNotificationsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryColor,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                SizedBox(width: 6),
                Text(
                  'Nhận lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Đóng',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}