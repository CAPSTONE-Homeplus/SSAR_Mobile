import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/size_config.dart';
import '../../../core/enums/order_status.dart';
import '../../../domain/entities/order/cancellation_request.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/staff/staff.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/staff/staff_bloc.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/currency_display.dart';

class OrdersDetailsScreen extends StatefulWidget {
  final String ordersId;

  const OrdersDetailsScreen({Key? key, required this.ordersId})
      : super(key: key);

  @override
  State<OrdersDetailsScreen> createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  // App theme colors
  final Color primaryColor = const Color(0xFF1CAF7D);
  final Color secondaryColor = const Color(0xFF4A6572);
  final Color backgroundColor = const Color(0xFFF8F9FA);
  final Color cardColor = Colors.white;
  final Color errorColor = const Color(0xFFFF3B30);
  Staff? _loadedStaff;
  bool _staffFetched = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future _initData() async {
    context.read<OrderBloc>().add(GetOrderEvent(widget.ordersId));
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Chưa có thông tin';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: BlocListener<StaffBloc, StaffState>(
        listener: (context, staffState) {
          if (staffState is StaffLoaded) {
            setState(() {
              _loadedStaff = staffState.staff;
            });
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                _initData();
              },
              child: Builder(
                builder: (context) {
                  if (state is OrderLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }

                  if (state is OrderError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: errorColor,
                                size: 48 * SizeConfig.ffem,
                              ),
                              SizedBox(height: 16 * SizeConfig.hem),
                              Text(
                                state.message,
                                style: GoogleFonts.poppins(
                                  color: secondaryColor,
                                  fontSize: 16 * SizeConfig.ffem,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24 * SizeConfig.hem),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<OrderBloc>()
                                      .add(GetOrderEvent(widget.ordersId));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24 * SizeConfig.fem,
                                    vertical: 12 * SizeConfig.hem,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8 * SizeConfig.fem),
                                  ),
                                ),
                                child: Text(
                                  'Thử lại',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is OrderLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!_staffFetched && state.order.employeeId != null) {
                        _staffFetched = true;
                        context
                            .read<StaffBloc>()
                            .add(GetStaffById(state.order.employeeId!));
                      }
                    });

                    return _buildOrdersDetails(context, state.order);
                  }

                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        title: 'Chi tiết đơn hàng',
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(
                child: Container(),
                initialIndex: 1,
                selectedCategory: 'clean',
              ),
            ),
          );
        });
  }

  Widget _buildOrdersDetails(BuildContext context, Orders orders) {
    String statusString = orders.status ?? '';
    OrderStatus status = statusString.toOrderStatus();

    return ListView(
      padding: EdgeInsets.only(
        bottom: 100 * SizeConfig.hem,
      ),
      children: [
        _buildStatusBanner(status),
        _buildIdAndDateCard(orders),
        _buildServiceDetailsCard(orders),
        _buildExtraServicesAndOptionsCard(orders),
        _buildPriceDetailsCard(orders),
        if (orders.notes != null && orders.notes!.isNotEmpty)
          _buildNotesCard(orders.notes!),
        _buildActionButtons(context, orders, status),
      ],
    );
  }

  Widget _buildStatusBanner(OrderStatus status) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 12 * SizeConfig.hem,
      ),
      color: status.color.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            color: status.color,
            size: 28 * SizeConfig.ffem,
          ),
          SizedBox(height: 8 * SizeConfig.hem),
          Text(
            status.displayName,
            style: GoogleFonts.poppins(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 16 * SizeConfig.ffem,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIdAndDateCard(Orders orders) {
    return Card(
      margin: EdgeInsets.all(16 * SizeConfig.fem),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.receipt_long,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 12 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã đơn hàng',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        orders.code ?? 'N/A',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 12 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thời gian đặt dịch vụ',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        formatDateTime(orders.createdAt),
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.timelapse,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 12 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thời gian dự kiến hoàn thành',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        '${orders.estimatedDuration} giờ',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.timelapse,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 12 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đã lên lịch',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        orders.timeSlotDetail != null
                            ? formatDateTime(orders.timeSlotDetail)
                            : 'Yêu cầu ngay',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard(Orders orders) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16 * SizeConfig.fem,
        vertical: 8 * SizeConfig.hem,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 8 * SizeConfig.fem),
                Text(
                  'Chi tiết dịch vụ',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48 * SizeConfig.fem,
                  height: 48 * SizeConfig.hem,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8 * SizeConfig.fem),
                  ),
                  child: Center(
                    child: Icon(
                      _getServiceIcon(orders.serviceType),
                      color: primaryColor,
                      size: 24 * SizeConfig.ffem,
                    ),
                  ),
                ),
                SizedBox(width: 16 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orders.serviceType ?? 'Dọn dẹp',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        _getServiceDescription(orders.serviceType),
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48 * SizeConfig.fem,
                  height: 48 * SizeConfig.hem,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.access_time_filled,
                      color: primaryColor,
                      size: 24 * SizeConfig.ffem,
                    ),
                  ),
                ),
                SizedBox(width: 16 * SizeConfig.fem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Giờ bắt đầu",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13 * SizeConfig.ffem,
                        ),
                      ),
                      Text(
                        formatDateTime(orders.jobStartTime),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6 * SizeConfig.hem),
                      Text(
                        "Giờ kết thúc",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13 * SizeConfig.ffem,
                        ),
                      ),
                      Text(
                        formatDateTime(orders.jobEndTime),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * SizeConfig.ffem,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12 * SizeConfig.hem,
                horizontal: 16 * SizeConfig.fem,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStaffStatus(orders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraServicesAndOptionsCard(Orders orders) {
    // Combine and check if either list has items
    final hasExtraServicesOrOptions =
        (orders.extraServices?.isNotEmpty == true) ||
            (orders.options?.isNotEmpty == true);

    if (!hasExtraServicesOrOptions) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16 * SizeConfig.fem,
        vertical: 8 * SizeConfig.hem,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 8 * SizeConfig.fem),
                Text(
                  'Dịch Vụ Bổ Sung',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),

            // Extra Services Section
            if (orders.extraServices?.isNotEmpty == true)
              Column(
                children: orders.extraServices!
                    .map((service) => Padding(
                          padding: EdgeInsets.only(bottom: 12 * SizeConfig.hem),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 48 * SizeConfig.fem,
                                height: 48 * SizeConfig.hem,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(8 * SizeConfig.fem),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: primaryColor,
                                    size: 24 * SizeConfig.ffem,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16 * SizeConfig.fem),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name ?? 'Dịch vụ không xác định',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15 * SizeConfig.ffem,
                                      ),
                                    ),
                                    SizedBox(height: 4 * SizeConfig.hem),
                                    Text(
                                      'Chi tiết dịch vụ bổ sung',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
                                        fontSize: 13 * SizeConfig.ffem,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CurrencyDisplay(price: service.price ?? 0),
                            ],
                          ),
                        ))
                    .toList(),
              ),

            // Options Section
            if (orders.options?.isNotEmpty == true)
              Column(
                children: [
                  if (orders.extraServices?.isNotEmpty == true)
                    Divider(
                      height: 24 * SizeConfig.hem,
                      color: Colors.grey[300],
                    ),
                  ...orders.options!
                      .map((option) => Padding(
                            padding:
                                EdgeInsets.only(bottom: 12 * SizeConfig.hem),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48 * SizeConfig.fem,
                                  height: 48 * SizeConfig.hem,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        8 * SizeConfig.fem),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: primaryColor,
                                      size: 24 * SizeConfig.ffem,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16 * SizeConfig.fem),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option.name ??
                                            'Lựa chọn không xác định',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15 * SizeConfig.ffem,
                                        ),
                                      ),
                                      SizedBox(height: 4 * SizeConfig.hem),
                                      Text(
                                        'Chi tiết lựa chọn',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black54,
                                          fontSize: 13 * SizeConfig.ffem,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CurrencyDisplay(price: option.price ?? 0),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffStatus(Orders orders) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ([
            OrderStatus.accepted,
            OrderStatus.inProgress,
          ].contains(orders.status.toString().toOrderStatus()))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_pin_outlined,
                      color: primaryColor,
                      size: 24 * SizeConfig.ffem,
                    ),
                    SizedBox(width: 8 * SizeConfig.fem),
                    Expanded(
                      child: Text(
                        'Nhân Viên: ${_loadedStaff?.fullName ?? 'Chưa có thông tin'}',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * SizeConfig.ffem,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8 * SizeConfig.hem),
                if (_loadedStaff?.phoneNumber != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: primaryColor,
                        size: 24 * SizeConfig.ffem,
                      ),
                      SizedBox(width: 8 * SizeConfig.fem),
                      Expanded(
                        child: Text(
                          'Liên hệ: ${_loadedStaff!.phoneNumber}',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15 * SizeConfig.ffem,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8 * SizeConfig.hem),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: primaryColor,
                      size: 24 * SizeConfig.ffem,
                    ),
                    SizedBox(width: 8 * SizeConfig.fem),
                    Expanded(
                      child: Text(
                        'Nhân viên đã tiếp nhận yêu cầu của bạn và sẽ đến trong thời gian sớm nhất',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else if (orders.status.toString().toOrderStatus() ==
              OrderStatus.completed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check if customer feedback and employee rating exist
                if (orders.customerFeedback != null &&
                    orders.employeeRating != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            color: primaryColor,
                            size: 24 * SizeConfig.ffem,
                          ),
                          SizedBox(width: 8 * SizeConfig.fem),
                          Expanded(
                            child: Text(
                              'Cảm ơn bạn đã sử dụng dịch vụ',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16 * SizeConfig.ffem,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * SizeConfig.hem),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8 * SizeConfig.fem,
                              children: [
                                Text(
                                  'Đánh giá của bạn: ${orders.employeeRating}/5',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14 * SizeConfig.ffem,
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20 * SizeConfig.ffem,
                                ),
                                Text(
                                  'đối với nhân viên ${_loadedStaff?.fullName ?? 'Thông tin nhân viên chưa được cập nhật'}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14 * SizeConfig.ffem,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8 * SizeConfig.fem),
                      ElevatedButton(
                        onPressed: () {
                          AppRouter.navigateToServiceDetail(
                              orders.serviceId ?? '',
                              orderIdToReOrder: orders.id,
                            staff: _loadedStaff);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24 * SizeConfig.fem,
                            vertical: 12 * SizeConfig.hem,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8 * SizeConfig.fem),
                          ),
                        ),
                        child: Text(
                          'Đăng ký lại dịch vụ',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16 * SizeConfig.ffem,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dịch vụ đã hoàn thành',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16 * SizeConfig.ffem,
                        ),
                      ),
                      SizedBox(height: 4 * SizeConfig.hem),
                      Text(
                        'Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * SizeConfig.ffem,
                        ),
                      ),
                    ],
                  ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orders.emergencyRequest == true
                      ? 'Đơn đặt ngay'
                      : 'Yêu cầu dịch vụ',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
                SizedBox(height: 4 * SizeConfig.hem),
                Text(
                  orders.emergencyRequest == true
                      ? 'Nhân viên sẽ được phân công ngay lập tức trong vòng 1 tiếng'
                      : 'Yêu cầu được đặt lịch theo thời gian bạn chọn',
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * SizeConfig.ffem,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String? serviceType) {
    if (serviceType == null) return Icons.home_repair_service;

    if (serviceType.toLowerCase().contains('dọn'))
      return Icons.cleaning_services;
    if (serviceType.toLowerCase().contains('giặt'))
      return Icons.local_laundry_service;
    if (serviceType.toLowerCase().contains('sửa')) return Icons.handyman;
    if (serviceType.toLowerCase().contains('nấu')) return Icons.restaurant;

    return Icons.miscellaneous_services;
  }

  String _getServiceDescription(String? serviceType) {
    if (serviceType == null) return 'Không có mô tả';

    if (serviceType.toLowerCase().contains('dọn')) {
      return 'Dọn dẹp, vệ sinh nhà cửa theo tiêu chuẩn chuyên nghiệp';
    }
    if (serviceType.toLowerCase().contains('giặt')) {
      return 'Giặt ủi quần áo, chăn ga gối đệm tại nhà';
    }
    if (serviceType.toLowerCase().contains('sửa')) {
      return 'Sửa chữa các thiết bị, đồ dùng trong nhà';
    }
    if (serviceType.toLowerCase().contains('nấu')) {
      return 'Nấu ăn tại nhà theo yêu cầu';
    }

    return 'Dịch vụ tiện ích, chăm sóc nhà cửa';
  }

  Widget _buildPriceDetailsCard(Orders orders) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16 * SizeConfig.fem,
        vertical: 8 * SizeConfig.hem,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 8 * SizeConfig.fem),
                Text(
                  'Chi tiết thanh toán',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phí dịch vụ',
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 14 * SizeConfig.ffem,
                  ),
                ),
                CurrencyDisplay(price: orders.totalAmount ?? 0),
              ],
            ),
            Divider(height: 24 * SizeConfig.hem),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng thanh toán',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
                CurrencyDisplay(price: orders.totalAmount ?? 0),
              ],
            ),
            SizedBox(height: 16 * SizeConfig.hem),
            Container(
              padding: EdgeInsets.all(12 * SizeConfig.fem),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8 * SizeConfig.fem),
                border: Border.all(
                  color: Colors.amber.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber.shade800,
                    size: 20 * SizeConfig.ffem,
                  ),
                  SizedBox(width: 8 * SizeConfig.fem),
                  Expanded(
                    child: Text(
                      'Đã thanh toán qua ví điện tử',
                      style: GoogleFonts.poppins(
                        color: Colors.amber.shade800,
                        fontSize: 14 * SizeConfig.ffem,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(String note) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16 * SizeConfig.fem,
        vertical: 8 * SizeConfig.hem,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.note,
                  color: primaryColor,
                  size: 20 * SizeConfig.ffem,
                ),
                SizedBox(width: 8 * SizeConfig.fem),
                Text(
                  'Ghi chú',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * SizeConfig.ffem,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12 * SizeConfig.hem),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12 * SizeConfig.fem),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8 * SizeConfig.fem),
              ),
              child: Text(
                note,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14 * SizeConfig.ffem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, Orders orders, OrderStatus status) {
    return Container(
      margin: EdgeInsets.all(16 * SizeConfig.fem),
      child: Column(
        children: [
          if (status == OrderStatus.accepted ||
              status == OrderStatus.inProgress)
            ElevatedButton(
              onPressed: () {
                AppRouter.navigateToOrderTracking(orders);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 52 * SizeConfig.hem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delivery_dining),
                  // Đổi biểu tượng thành theo dõi đơn hàng
                  SizedBox(width: 8 * SizeConfig.fem),
                  Text(
                    'Theo dõi đơn hàng',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * SizeConfig.ffem,
                    ),
                  ),
                ],
              ),
            ),
          if (status == OrderStatus.completed ||
              status == OrderStatus.completed)
            _buildRatingSupportButton(orders),
          if (status == OrderStatus.pending || status == OrderStatus.draft) ...[
            ElevatedButton(
              onPressed: () {
                _showCancelOrdersDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 52 * SizeConfig.hem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined),
                  SizedBox(width: 8 * SizeConfig.fem),
                  Text(
                    'Hủy đơn hàng',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * SizeConfig.ffem,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSupportButton(Orders orders) {
    if (orders.employeeRating != null) {
      return Container(
        width: double.infinity,
        height: 52 * SizeConfig.hem,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 8 * SizeConfig.fem),
            Text(
              'Đã đánh giá dịch vụ',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16 * SizeConfig.ffem,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // If no existing rating, show the normal button
    return ElevatedButton(
      onPressed: () {
        AppRouter.navigateToRatingScreen(orders.id);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 52 * SizeConfig.hem),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent),
          SizedBox(width: 8 * SizeConfig.fem),
          Text(
            'Đánh giá hỗ trợ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16 * SizeConfig.ffem,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrdersDialog(BuildContext context) {
    String selectedReason = 'Khách hàng đổi ý';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCancelled) {
              Navigator.of(context).pop();
              setState(() {
                _initData();
              });
            }
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16 * SizeConfig.fem),
                ),
                title: Row(
                  children: [
                    Icon(Icons.warning_amber, color: errorColor),
                    SizedBox(width: 8 * SizeConfig.fem),
                    Text(
                      'Xác nhận hủy đơn',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18 * SizeConfig.ffem,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn có chắc muốn hủy đơn hàng này?',
                      style: GoogleFonts.poppins(
                        fontSize: 15 * SizeConfig.ffem,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8 * SizeConfig.hem),
                    Text(
                      'Đơn hàng sau khi hủy sẽ không thể khôi phục lại.',
                      style: GoogleFonts.poppins(
                        fontSize: 14 * SizeConfig.ffem,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 16 * SizeConfig.hem),
                    Text(
                      'Chọn lý do hủy:',
                      style: GoogleFonts.poppins(
                        fontSize: 14 * SizeConfig.ffem,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8 * SizeConfig.hem),
                    DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8 * SizeConfig.fem),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12 * SizeConfig.fem,
                          vertical: 8 * SizeConfig.hem,
                        ),
                      ),
                      items: [
                        'Khách hàng đổi ý',
                        'Tìm được giá tốt hơn',
                        'Thời gian giao hàng quá lâu',
                        'Lý do khác',
                      ].map((String reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason,
                              style: GoogleFonts.poppins(
                                  fontSize: 14 * SizeConfig.ffem)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Quay lại',
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                        fontSize: 14 * SizeConfig.ffem,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(
                            CancelOrder(
                                widget.ordersId,
                                CancellationRequest(
                                  cancellationReason: selectedReason,
                                  refundMethod: 'Hoàn tiền vào ví điện tử',
                                  cancelledBy: 'customer',
                                )),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * SizeConfig.fem),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * SizeConfig.fem,
                        vertical: 8 * SizeConfig.hem,
                      ),
                    ),
                    child: Text(
                      'Xác nhận hủy',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14 * SizeConfig.ffem,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
