import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/order/order_tracking.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order_tracking/order_tracking_bloc.dart';
import '../../blocs/order_tracking/order_tracking_event.dart';
import '../../blocs/order_tracking/order_tracking_state.dart';
import '../../blocs/staff/staff_bloc.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Orders orders;

  OrderTrackingScreen({required this.orders});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  late List<OrderStep> _orderSteps = [];

  @override
  void initState() {
    super.initState();
    context.read<OrderTrackingBloc>().add(ConnectToHubEvent());
    context.read<OrderTrackingBloc>().add(GetOrderTrackingByIdEvent(widget.orders.id ?? ''));
    context.read<StaffBloc>().add(GetStaffById(widget.orders.employeeId ?? ''));
  }
  @override
  void dispose() {
    context.read<OrderTrackingBloc>().add(DisconnectFromHubEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Theo dõi đơn hàng', onBackPressed: () {
        Navigator.of(context).pop();
      }),
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
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        BlocConsumer<OrderTrackingBloc, OrderTrackingState>(
          listener: (context, state) {
            if (state is OrderTrackingLoaded || state is OrderTrackingUpdated) {
              // Lấy OrderTracking từ state và chuyển đổi thành OrderSteps
              OrderTracking tracking;
              if (state is OrderTrackingLoaded) {
                tracking = state.tracking;
              } else {
                tracking = (state as OrderTrackingUpdated).tracking;
              }

              setState(() {
                // Chuyển đổi từ định dạng OrderTracking sang OrderStep
                // Lưu ý: Bạn cần thêm hàm fromJson vào class OrderStep hoặc điều chỉnh cách chuyển đổi
                _orderSteps = tracking.steps
                    .map((step) => OrderStep.fromJson(step))
                    .toList();
              });
            }
          },
          builder: (context, state) {
            if (state is OrderTrackingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderTrackingError) {
              return Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            }

            return _orderSteps.isEmpty
                ? Center(
              child: Text(
                'Không có thông tin theo dõi đơn hàng',
                style: GoogleFonts.poppins(),
              ),
            )
                : Column(
              children: List.generate(_orderSteps.length, (index) {
                final step = _orderSteps[index];
                return _buildTrackingStepItem(
                    step,
                    index < _orderSteps.length - 1
                );
              }),
            );
          },
        ),
      ],
    );
  }
  Widget _buildTrackingStepItem(OrderStep step, bool showConnector) {
    Color getStepColor() {
      switch (step.status.toLowerCase()) {
        case "inprogress":
          return Colors.blue[700]!;
        case "completed":
          return Colors.green[700]!;
        case "pending":
          return Colors.orange[400]!;
        default:
          return Colors.grey;
      }
    }

    Widget stepIcon() {
      final iconName = step.status.toLowerCase();

      final iconData = {
        "inprogress": Icons.timer,
        "completed": Icons.check_circle,
        "pending": Icons.circle,
      }[iconName] ?? Icons.help;

      return Icon(iconData, color: Colors.white, size: 20);
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
                  if (step.description == 'Người làm đã đến' && step.subActivities != null)
                    const SizedBox(height: 10),
                  if (step.description == 'Người làm đã đến' && step.subActivities != null)
                    ...step.subActivities!.map((subActivity) => _buildSubActivityItem(subActivity)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildSubActivityItem(ActivityStatus subActivity) {
    IconData getSubActivityIcon() {
      switch (subActivity.status.toLowerCase()) {
        case "completed":
          return Icons.check_circle;
        case "inprogress":
          return Icons.timer;
        case "pending":
          return Icons.more_horiz;
        default:
          return Icons.help;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            getSubActivityIcon(),
            size: 16,
            color: subActivity.status.toLowerCase() == "completed"
                ? AppColors.primaryColor
                : Colors.grey,
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
                    fontWeight: subActivity.status.toLowerCase() == "inprogress"
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  subActivity.status,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: subActivity.status.toLowerCase() == "inprogress"
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
    return BlocBuilder<StaffBloc, StaffState>(
      builder: (context, state) {
        if (state is StaffLoading) {
          return Container(
          );
        } else if (state is StaffLoaded) {
          final staff = state.staff;
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
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nhân viên: ${staff.fullName}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        "Giới tính: ${staff.gender == 'male' ? 'Nam' : 'Nữ'}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "Số điện thoại: ${staff.phoneNumber}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is StaffError) {
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
            child: Center(
              child: Text(
                'Không thể tải thông tin nhân viên: ${state.message}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        // Initial state or any other state
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
                child: Icon(Icons.person, color: AppColors.primaryColor, size: 40),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đang tải thông tin...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
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
                icon: Icon(Icons.phone, color: Colors.grey),
                onPressed: null,
              ),
            ],
          ),
        );
      },
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
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã đơn: ${widget.orders.code}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.orders.createdAt.toString() == null ? DateTime.now() : DateTime.parse(widget.orders.createdAt.toString()))}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timelapse, color: AppColors.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Thời gian dự kiến: ${widget.orders.estimatedDuration} giờ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
