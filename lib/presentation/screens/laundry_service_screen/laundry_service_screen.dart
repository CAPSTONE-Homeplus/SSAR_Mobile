import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

import '../../blocs/additional_service/additional_service_bloc.dart';
import '../../blocs/additional_service/additional_service_event.dart';
import '../../blocs/additional_service/additional_service_state.dart';
import '../../blocs/laundry_item_type/laundry_item_type_bloc.dart';
import '../../blocs/laundry_item_type/laundry_item_type_state.dart';
import '../../blocs/laundry_item_type/laundry_item_type_event.dart';
import '../../blocs/laundry_service_type/laundry_service_type_bloc.dart';
import 'package:home_clean/presentation/blocs/laundry_service_type/laundry_service_type_event.dart'
    hide GetLaundryItemTypeByService;
import '../../blocs/laundry_service_type/laundry_service_type_state.dart';
import 'components/laundry_item_quantity_row.dart';

class LaundryServiceScreen extends StatefulWidget {
  const LaundryServiceScreen({Key? key}) : super(key: key);

  @override
  _LaundryServiceScreenState createState() => _LaundryServiceScreenState();
}

class _LaundryServiceScreenState extends State<LaundryServiceScreen> {
  bool isLoading = true;
  late LaundryServiceTypeBloc _laundryServiceTypeBloc;
  late LaundryItemTypeBloc _laundryItemTypeBloc;
  late AdditionalServiceBloc  _additionalServiceBloc;
  List<dynamic> laundryServiceType = [];
  List<dynamic> additionalService = [];
  Map<String, List<dynamic>> laundryItemsByService = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      setState(() => isLoading = true);
      _laundryServiceTypeBloc = context.read();
      _laundryItemTypeBloc = context.read();
      _additionalServiceBloc = context.read();
      _laundryServiceTypeBloc.add(GetLaundryServiceTypes());
      _additionalServiceBloc.add(FetchAdditionalService());
      await _processServiceType();
      await _fetchLaundryItems();
      await _processAdditionalService();
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _processServiceType() async {
    final state = _laundryServiceTypeBloc.state;
    if (state is LaundryServiceTypeLoaded) {
      laundryServiceType = state.laundryServiceTypes.items;
      return;
    }
    await for (final newState in _laundryServiceTypeBloc.stream) {
      if (newState is LaundryServiceTypeLoaded) {
        laundryServiceType = newState.laundryServiceTypes.items;
        break;
      }
    }
  }

  Future<void> _processAdditionalService() async {
    final state = _additionalServiceBloc.state;
    if (state is AdditionalServiceLoaded) {
      additionalService = state.services.items;
      return;
    }
    await for (final newState in _additionalServiceBloc.stream) {
      if (newState is AdditionalServiceLoaded) {
        additionalService = newState.services.items;
        break;
      }
    }
  }


  Future<void> _fetchLaundryItems() async {
    for (var service in laundryServiceType) {
      _laundryItemTypeBloc.add(GetLaundryItemTypeByService(service.id));
      await for (final state in _laundryItemTypeBloc.stream) {
        if (state is LaundryItemTypeLoaded) {
          laundryItemsByService[service.id ?? ''] =
              state.laundryItemTypes.items;
          break;
        } else if (state is LaundryItemTypeError) {
          print(
              'Error fetching items for service ${service.id}: ${state.message}');
          laundryItemsByService[service.id ?? ''] = [];
          break;
        }
      }
    }
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đặt Dịch Vụ Giặt Là'),
          content: Text('Chức năng đặt dịch vụ đang được phát triển. Vui lòng liên hệ hotline để được hỗ trợ.'),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF1CAF7D);
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Dịch Vụ Giặt Là'),
      body: Column(
        children: [
          // Existing ListView takes most of the space
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                // Main ListView of services
                isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: primaryColor),
                      SizedBox(height: 16),
                      Text(
                        'Đang tải dịch vụ...',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
                    : laundryServiceType.isEmpty
                    ? Center(
                  child: Text(
                    'Không có dịch vụ nào',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : Column(
                  children: laundryServiceType.map((service) {
                    var items = laundryItemsByService[service.id] ?? [];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  service.name ?? 'Dịch Vụ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '${items.length} mục',
                                  style: TextStyle(
                                    color: primaryColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          items.isEmpty
                              ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Không có mục giặt',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                              : Column(
                            children: items.map((item) {
                              return LaundryServiceItemRow(
                                item: item,
                                primaryColor: primaryColor,
                                serviceType: item.pricePerItem != null ? 'PerItem' : null,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // Additional Services Section
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: additionalService.isEmpty
                      ? Center(
                    child: Text(
                      "Không có dịch vụ bổ sung",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dịch Vụ Bổ Sung',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      ...additionalService.map((service) {
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(
                                service.name ?? "Dịch vụ không tên",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),

                              value: false, // Cần thay đổi thành state thực tế
                              onChanged: (bool? newValue) {
                                // Thêm logic chọn dịch vụ
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: Colors.green, // Màu khi chọn checkbox
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 8,
                            ), // Thêm đường kẻ phân cách
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lưu Ý',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Đây chỉ là bảng giá tham khảo. Đối với giặt đồ theo ký, sau khi nhân viên tới lấy đồ, họ sẽ kiểm tra và đo đạc lại số kg sau khi giặt. '
                            'Sau đó, nhân viên sẽ gọi điện yêu cầu bạn thanh toán trên app. '
                            'Sau khi thanh toán thành công, nhân viên sẽ giao lại đồ cho bạn.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Booking button at the very bottom
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: _showBookingDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Đặt Dịch Vụ Ngay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}