import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with SingleTickerProviderStateMixin {

  final List<OrderStep> _orderSteps = [
    OrderStep(
      title: 'Đặt dịch vụ',
      description: 'Đơn hàng đã được xác nhận',
      time: '10:30 AM',
      status: StepStatus.completed,
    ),
    OrderStep(
      title: 'Đang tìm người làm',
      description: 'Đang ghép đôi với người làm phù hợp',
      time: '10:35 AM',
      status: StepStatus.completed,
    ),
    OrderStep(
      title: 'Người làm đang chuẩn bị',
      description: 'Nhân viên Nguyễn Văn A đang chuẩn bị làm việc',
      time: '11:00 AM',
      status: StepStatus.completed,
    ),
    OrderStep(
      title: 'Người làm đã đến',
      description: 'Nhân viên Nguyễn Văn A đang thực hiện công việc',
      time: '11:30 AM',
      status: StepStatus.current,
      subActivities: [
        SubActivity(
          title: 'Dọn phòng khách',
          status: SubActivityStatus.inProgress,
          estimatedTime: '30 phút',
        ),
        SubActivity(
          title: 'Dọn bếp',
          status: SubActivityStatus.pending,
          estimatedTime: '45 phút',
        ),
        SubActivity(
          title: 'Lau sàn',
          status: SubActivityStatus.pending,
          estimatedTime: '20 phút',
        ),
      ],
    ),
    OrderStep(
      title: 'Hoàn thành dịch vụ',
      description: 'Chờ xác nhận hoàn tất',
      time: '--:--',
      status: StepStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[700]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Theo dõi đơn hàng',
          style: GoogleFonts.poppins(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderDetailsCard(),

              const SizedBox(height: 20),

              _buildTrackingSteps(),

              const SizedBox(height: 20),

              _buildServiceWorkerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildTrackingSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trạng thái đơn hàng',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(_orderSteps.length, (index) {
          final step = _orderSteps[index];
          return _buildTrackingStepItem(step, index < _orderSteps.length - 1);
        }),
      ],
    );
  }

  Widget _buildTrackingStepItem(OrderStep step, bool showConnector) {
    Color getStepColor() {
      switch (step.status) {
        case StepStatus.completed:
          return Colors.green;
        case StepStatus.current:
          return Colors.orange;
        case StepStatus.pending:
          return Colors.grey;
      }
    }

    Widget stepIcon() {
      IconData iconData;
      switch (step.status) {
        case StepStatus.completed:
          iconData = Icons.check_circle;
          return Icon(iconData, color: Colors.white, size: 20);
        case StepStatus.current:
          iconData = Icons.directions_run;
          return Icon(iconData, color: Colors.white, size: 20);
        case StepStatus.pending:
          iconData = Icons.more_horiz;
          return Icon(iconData, color: Colors.white, size: 20);
      }
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: getStepColor(),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: stepIcon()),
                ),
                if (showConnector)
                  Container(
                    width: 2,
                    height: 60,
                    color: getStepColor().withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getStepColor(),
                    ),
                  ),
                  Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    step.time,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (step.title == 'Người làm đã đến' && step.subActivities != null)
                    const SizedBox(height: 10),
                  if (step.title == 'Người làm đã đến' && step.subActivities != null)
                    ...step.subActivities!.map((subActivity) => _buildSubActivityItem(subActivity)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubActivityItem(SubActivity subActivity) {
    Color getSubActivityColor() {
      switch (subActivity.status) {
        case SubActivityStatus.inProgress:
          return Colors.orange;
        case SubActivityStatus.completed:
          return Colors.green;
        case SubActivityStatus.pending:
          return Colors.grey;
      }
    }

    IconData getSubActivityIcon() {
      switch (subActivity.status) {
        case SubActivityStatus.inProgress:
          return Icons.directions_run;
        case SubActivityStatus.completed:
          return Icons.check_circle;
        case SubActivityStatus.pending:
          return Icons.more_horiz;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            getSubActivityIcon(),
            color: getSubActivityColor(),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subActivity.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: subActivity.status == SubActivityStatus.inProgress
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  'Dự kiến: ${subActivity.estimatedTime}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildServiceWorkerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            radius: 30,
            child: Icon(Icons.person, color: Colors.green[700], size: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nguyễn Văn A',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'Nhân viên dọn dẹp',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.phone, color: Colors.green[700]),
            onPressed: () {
              // Implement phone call functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Support action
            },
            icon: Icon(Icons.support_agent, color: Colors.white),
            label: Text(
              'Hỗ trợ',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Cancel order action
            },
            icon: Icon(Icons.cancel, color: Colors.white),
            label: Text(
              'Hủy đơn',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOrderDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã đơn: #BT2024051201',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.cleaning_services, color: Colors.green[700]),
              const SizedBox(width: 10),
              Text(
                'Dọn dẹp nhà',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
// Giữ nguyên các phương thức khác như _buildOrderDetailsCard(), _buildServiceWorkerCard(), _buildBottomActionBar()
// Như trong code trước đó
}

enum StepStatus {
  completed,
  current,
  pending,
}

enum SubActivityStatus {
  pending,
  inProgress,
  completed,
}

class OrderStep {
  final String title;
  final String description;
  final String time;
  final StepStatus status;
  final List<SubActivity>? subActivities;

  OrderStep({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    this.subActivities,
  });
}

class SubActivity {
  final String title;
  final SubActivityStatus status;
  final String estimatedTime;

  SubActivity({
    required this.title,
    required this.status,
    required this.estimatedTime,
  });
}