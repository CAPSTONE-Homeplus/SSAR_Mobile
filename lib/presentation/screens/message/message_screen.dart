import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Messages & Notifications',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Messages'),
            Tab(text: 'Notifications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      itemCount: mockMessages.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final message = mockMessages[index];
        return _buildMessageCard(message);
      },
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      itemCount: mockNotifications.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final notification = mockNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildMessageCard(Message message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF1CAF7D).withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: Color(0xFF1CAF7D),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.senderName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              message.lastMessage,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (message.unreadCount > 0) ...[
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFF1CAF7D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.unreadCount.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          // Navigate to chat detail
        },
      ),
    );
  }

  Widget _buildNotificationCard(Notification notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.notifications,
          color: Color(0xFF1CAF7D),
        ),
        title: Text(
          notification.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          notification.body,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          DateFormat('HH:mm').format(notification.timestamp),
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        onTap: () {
          // Navigate to notification detail
        },
      ),
    );
  }
}

class Message {
  final String id;
  final String senderName;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;

  Message({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
  });
}

class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });
}

final List<Message> mockMessages = [
  Message(
    id: '1',
    senderName: 'John Doe',
    lastMessage: 'Your booking has been confirmed',
    timestamp: DateTime.now(),
    unreadCount: 2,
  ),
  Message(
    id: '2',
    senderName: 'Cleaning Service',
    lastMessage: 'We will arrive in 10 minutes',
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
    unreadCount: 0,
  ),
  Message(
    id: '3',
    senderName: 'Support Team',
    lastMessage: 'How can we help you today?',
    timestamp: DateTime.now().subtract(Duration(hours: 2)),
    unreadCount: 1,
  ),
];

final List<Notification> mockNotifications = [
  Notification(
    id: '1',
    title: 'New Message',
    body: 'You have a new message from John Doe.',
    timestamp: DateTime.now(),
  ),
  Notification(
    id: '2',
    title: 'Appointment Reminder',
    body: 'Your appointment is tomorrow at 10 AM.',
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
  ),
  Notification(
    id: '3',
    title: 'System Update',
    body: 'A system update is available.',
    timestamp: DateTime.now().subtract(Duration(hours: 2)),
  ),
];
