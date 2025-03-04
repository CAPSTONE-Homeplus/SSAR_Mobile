// lib/presentation/screens/notification_screen.dart
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
      appBar: AppBar(
        title: Text('Thông báo'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<NotificationBloc>().add(RefreshNotificationsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial || state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Bạn chưa có thông báo nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(RefreshNotificationsEvent());
              },
              child: ListView.separated(
                padding: EdgeInsets.all(8),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(height: 1),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi: ${state.message}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(LoadNotificationsEvent());
                    },
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            SizedBox(height: 16),
            Text(
              'Nhận lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

