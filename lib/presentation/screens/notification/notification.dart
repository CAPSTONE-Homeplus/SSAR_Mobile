import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/entities/notification/notification.dart';
import 'package:intl/intl.dart';

import '../../blocs/notification/notification_bloc.dart';
import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Định nghĩa màu chính - tương tự bTaskee
  static final Color primaryColor = const Color(0xFF1CAF7D);

  @override
  void initState() {
    super.initState();

    context.read<NotificationBloc>().add(ConnectToHubEvent());
    context.read<NotificationBloc>().add(LoadNotificationsEvent());
  }

  @override
  void dispose() {
    context.read<NotificationBloc>().add(DisconnectFromHubEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
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
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial || state is NotificationLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                context.read<NotificationBloc>().add(RefreshNotificationsEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationItem(
                    notification: notifications[index],
                    onTap: () {
                      context.read<NotificationBloc>().add(
                        MarkAsReadEvent(notifications[index].id),
                      );
                      _showNotificationDetails(context, notifications[index]);
                    },
                    onDismiss: () {
                      context.read<NotificationBloc>().add(
                        DeleteNotificationEvent(notifications[index].id),
                      );
                    },
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_notification.png',
            width: 120,
            height: 120,
            // Thay thế bằng đường dẫn thực tế hoặc sử dụng Icon nếu không có hình
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
          ),
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
              backgroundColor: primaryColor,
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
                backgroundColor: primaryColor,
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
              color: primaryColor,
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
              foregroundColor: primaryColor,
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