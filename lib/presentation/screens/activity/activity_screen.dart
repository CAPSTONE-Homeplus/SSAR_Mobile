import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Task> mockTasks = [
    Task(
      id: '1',
      title: 'Home Cleaning',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.upcoming,
      price: 300000,
      icon: Icons.cleaning_services,
      iconColor: Color(0xFF1CAF7D),
    ),
    Task(
      id: '2',
      title: 'Laundry Service',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      status: TaskStatus.inProgress,
      price: 250000,
      icon: Icons.local_laundry_service,
      iconColor: Colors.blue,
    ),
    Task(
      id: '3',
      title: 'Deep Cleaning',
      dateTime: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.scheduled,
      price: 450000,
      icon: Icons.cleaning_services,
      iconColor: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          'Activity',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          labelColor: Color(0xFF1CAF7D),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF1CAF7D),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Schedule'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(TaskStatus.upcoming),
          _buildTaskList(TaskStatus.scheduled),
          _buildMonthlyView(),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskStatus filterStatus) {
    final filteredTasks =
        mockTasks.where((task) => task.status == filterStatus).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: task.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(task.icon, color: task.iconColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(task.dateTime),
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(task.status),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                NumberFormat('#,###').format(task.price) + ' đ',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1CAF7D),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View Details',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF1CAF7D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    String text;

    switch (status) {
      case TaskStatus.upcoming:
        color = Color(0xFF1CAF7D);
        text = 'Upcoming';
        break;
      case TaskStatus.scheduled:
        color = Colors.blue;
        text = 'Scheduled';
        break;
      case TaskStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMonthlyView() {
    return Center(
      child: Text(
        'Monthly view coming soon',
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final DateTime dateTime;
  final TaskStatus status;
  final double price;
  final IconData icon;
  final Color iconColor;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.status,
    required this.price,
    required this.icon,
    required this.iconColor,
  });
}

enum TaskStatus {
  upcoming,
  scheduled,
  inProgress,
}
