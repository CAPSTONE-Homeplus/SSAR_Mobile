import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/laundry_order_status.dart';
import '../../../../data/laundry_repositories/laundry_order_repo.dart';
import '../../../../domain/entities/task/task.dart';
import '../../../blocs/task/task_bloc.dart';
import '../../../blocs/task/task_event.dart';
import '../../../blocs/task/task_state.dart';

class TaskTimelineScreen extends StatefulWidget {
  final LaundryOrderDetailModel orders;

  const TaskTimelineScreen({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  State<TaskTimelineScreen> createState() => _TaskTimelineScreenState();
}

class _TaskTimelineScreenState extends State<TaskTimelineScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when screen initializes
    context
        .read<TaskBloc>()
        .add(FetchOrderTasksEvent(orderId: widget.orders.id ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Tiến Trình Đơn Hàng ${widget.orders.orderCode}',
        onBackPressed: () {
          AppRouter.navigateToLaundryOrderDetail(
            widget.orders.id ?? '',
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child:
              StepIndicatorTaskTimelineWidget(orderId: widget.orders.id ?? ''),
        ),
      ),
    );
  }
}

class StepIndicatorTaskTimelineWidget extends StatelessWidget {
  final String orderId;

  const StepIndicatorTaskTimelineWidget({Key? key, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoadingState) {
          return _buildLoadingState(context);
        } else if (state is TaskLoadedState) {
          final tasks = state.tasksResponse.items;

          if (tasks.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildCustomTimeline(tasks, context);
        } else if (state is TaskErrorState) {
          return _buildErrorState(context, state.errorMessage);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            'Đang tải tiến trình...',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa Có Tiến Trình',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đơn hàng này chưa có bất kỳ hoạt động nào được ghi nhận.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade300,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Lỗi Tải Dữ Liệu',
            style: TextStyle(
              color: Colors.red.shade800,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context
                  .read<TaskBloc>()
                  .add(FetchOrderTasksEvent(orderId: orderId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Thử Lại',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTimeline(List<Task> tasks, BuildContext context) {
    tasks.sort((a, b) {
      if (a.startDate == null && b.startDate == null) {
        return 0;
      } else if (a.startDate == null) {
        return 1;
      } else if (b.startDate == null) {
        return -1;
      } else {
        return a.startDate!.compareTo(b.startDate!);
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<TaskBloc>()
            .add(FetchOrderTasksEvent(orderId: orderId));
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final statusColor = StatusUtility.getStatusColor(
                      TaskStatusEnumExtension.fromString(task.status ?? ''));
                  final statusName = StatusUtility.getStatusName(
                      TaskStatusEnumExtension.fromString(task.status ?? ''));
                  final statusIcon = StatusUtility.getStatusIcon(
                      TaskStatusEnumExtension.fromString(task.status ?? ''));
                  final isLastItem = index == tasks.length - 1;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline Indicator Column
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: statusColor,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: statusIcon,
                                ),
                              ),

                              // Connecting Line (except for the last item)
                              if (!isLastItem)
                                Expanded(
                                  child: Container(
                                    width: 3,
                                    color: statusColor.withOpacity(0.5),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ),
                            ],
                          ),

                          // Spacing between indicator and content
                          const SizedBox(width: 16),

                          // Task Content
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: statusColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Task Name and Status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.taskName ?? 'Nhiệm Vụ Không Tên',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          statusName,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Additional Task Details
                                  _buildDetailRow(
                                    icon: Icons.assignment_outlined,
                                    text: task.taskCode != null
                                        ? "Mã: ${task.taskCode}"
                                        : "Không có mã",
                                  ),

                                  if (task.employeeName != null)
                                    _buildDetailRow(
                                      icon: Icons.person_outline,
                                      text: "Người thực hiện: ${task.employeeName}",
                                    ),

                                  // Dates
                                  _buildDetailRow(
                                    icon: Icons.calendar_today,
                                    text: "Bắt đầu: ${_formatDate(task.startDate)}",
                                  ),

                                  if (task.completedDate != null)
                                    _buildDetailRow(
                                      icon: Icons.check_circle_outline,
                                      text:
                                          "Hoàn thành: ${_formatDate(task.completedDate)}",
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 350),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dateStr) {
    if (dateStr == null) {
      return 'Chưa có ngày';
    }
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateStr);
  }
}

class StatusUtility {
  static Color getStatusColor(TaskStatusEnum status) => status.color;

  static String getStatusName(TaskStatusEnum status) => status.name;

  static Widget getStatusIcon(TaskStatusEnum status) => status.iconWidget;
}
