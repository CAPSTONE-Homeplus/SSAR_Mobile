import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/laundry_blocs/order/laundry_order_bloc.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../data/laundry_repositories/laundry_order_repo.dart';
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
import '../../laundry_blocs/order/laundry_order_event.dart';
import '../../laundry_blocs/order/laundry_order_state.dart';
import '../../widgets/currency_display.dart';
import '../../widgets/show_dialog.dart';
import 'components/laundry_item_quantity_row.dart';
import 'components/laundry_service_weight_item_row.dart';

class LaundryServiceScreen extends StatefulWidget {
  const LaundryServiceScreen({Key? key}) : super(key: key);

  @override
  _LaundryServiceScreenState createState() => _LaundryServiceScreenState();
}

class _LaundryServiceScreenState extends State<LaundryServiceScreen> {
  // Constants
  static const primaryColor = Color(0xFF1CAF7D);
  static const appBarTitle = 'Dịch Vụ Giặt Sấy';
  static const emptyServiceMessage = 'Không có dịch vụ nào';
  static const emptyItemMessage = 'Không có mục giặt';
  static const loadingMessage = 'Đang tải dịch vụ...';
  static const additionalServicesTitle = 'Dịch Vụ Bổ Sung';
  static const orderButtonText = 'Đặt Dịch Vụ Ngay';
  static const errorTitle = 'Lỗi';
  static const emptyOrderError =
      'Vui lòng thêm chi tiết đơn hàng trước khi tạo đơn';
  static const orderCreationError = 'Không thể tạo đơn hàng';

  // State variables
  bool isLoading = true;
  late LaundryServiceTypeBloc _laundryServiceTypeBloc;
  late LaundryItemTypeBloc _laundryItemTypeBloc;
  late AdditionalServiceBloc _additionalServiceBloc;
  late LaundryOrderBloc _laundryOrderBloc;
  List<dynamic> laundryServiceType = [];
  List<dynamic> additionalService = [];
  Map<String, List<dynamic>> laundryItemsByService = {};
  List<String> selectedServiceId = [];
  List<dynamic> itemsLaundry = [];
  final List<OrderDetailsRequest> orderDetails = [];

  double additionalServicePrice = 0.0;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _laundryOrderBloc = context.read<LaundryOrderBloc>();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() => isLoading = true);
      _initializeBlocs();
      await _fetchAllData();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _initializeBlocs() {
    _laundryServiceTypeBloc = context.read<LaundryServiceTypeBloc>();
    _laundryItemTypeBloc = context.read<LaundryItemTypeBloc>();
    _additionalServiceBloc = context.read<AdditionalServiceBloc>();
  }

  Future<void> _fetchAllData() async {
    _laundryServiceTypeBloc.add(GetLaundryServiceTypes());
    _additionalServiceBloc.add(FetchAdditionalService());

    await _processServiceType();
    await _fetchLaundryItems();
    await _processAdditionalService();
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
          setState(() {
            laundryItemsByService[service.id ?? ''] =
                state.laundryItemTypes.items;
          });
          break;
        } else if (state is LaundryItemTypeError) {
          debugPrint(
              'Error fetching items for service ${service.id}: ${state.message}');
          setState(() {
            laundryItemsByService[service.id ?? ''] = [];
          });
          break;
        }
      }
    }
  }

  void onAddItem(OrderDetailsRequest item) {
    setState(() {
      final existingIndex = orderDetails.indexWhere(
              (existingItem) => existingItem.itemTypeId == item.itemTypeId);

      if (existingIndex != -1) {
        // Ghi đè lại item đã có, giữ lại giá trị cũ nếu giá trị mới là null
        orderDetails[existingIndex] = OrderDetailsRequest(
          itemTypeId: item.itemTypeId,
          quantity: item.quantity ?? orderDetails[existingIndex].quantity,
          weight: item.weight ?? orderDetails[existingIndex].weight,
        );
      } else {
        orderDetails.add(item);
      }
      _updateTotalPrice();
    });
  }

  void _placeOrder() {
    if (orderDetails.isEmpty) {
      _showErrorDialog(emptyOrderError);
      return;
    }


    final requestData = LaOrderRequest(
      name: 'Đơn Giặt',
      type: '',
      extraField: null,
      appliedDiscountId: null,
      orderDetailsRequest: orderDetails,
      additionalServiceIds: selectedServiceId,
    );

    showCustomDialog(
        context: context,
        message: 'Bạn có chắc chắn muốn đặt dịch vụ này? '
            'Lưu ý rằng đối với số giặt theo kg, '
            'nhân viên sẽ gọi bạn sau khi đã giặt xong'
            ' và bạn sẽ thanh toán số tiền cuối cùng '
            'trong app để nhân viên có thể giao hàng tới cho bạn.',
        type: DialogType.info,
        onConfirm: () {
          context
              .read<LaundryOrderBloc>()
              .add(CreateLaundryOrderEvent(requestData));
        },
        confirmButtonText: 'Tiếp Tục',
        onCancel: () {});
  }

  double _calculateTotalPrice() {
    double total = 0.0;

    // Tính giá các item đã chọn
    for (var detail in orderDetails) {
      // Tìm item tương ứng trong danh sách các item
      final item = laundryItemsByService.values
          .expand((items) => items)
          .firstWhereOrNull((item) => item.id == detail.itemTypeId);

      if (item == null) continue;

      // Ưu tiên tính theo kg nếu có
      if (detail.weight != null && detail.weight! > 0) {
        total += (item.pricePerKg ?? 0) * detail.weight!;
      }
      // Nếu không có kg, mới tính theo số lượng
      else if (detail.quantity != null && detail.quantity! > 0) {
        total += (item.pricePerItem ?? 0) * detail.quantity!;
      }
    }

    // Cộng thêm giá dịch vụ bổ sung
    total += additionalServicePrice;

    return total;
  }

  void _updateTotalPrice() {
    setState(() {
      totalPrice = _calculateTotalPrice();
    });
  }

  // Thêm widget hiển thị tổng số tiền
  Widget _buildTotalPriceWidget() {
    if (orderDetails.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tổng giá tham khảo:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          CurrencyDisplay(
            price: totalPrice,
            fontSize: 18,
            iconSize: 18,
            unit: '',
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(errorTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            loadingMessage,
            style: TextStyle(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServiceItem(dynamic service) {
    final itemsLaundry = laundryItemsByService[service.id] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceHeader(service),
          if (itemsLaundry.isEmpty)
            _buildEmptyItemMessage()
          else
            Column(
              children: itemsLaundry.map((item) =>
              item.pricePerKg != null
                  ? LaundryServiceWeightItemRow(
                item: item,
                primaryColor: primaryColor,
                onAddItem: onAddItem,
              )
                  : LaundryServiceItemRow(
                item: item,
                primaryColor: primaryColor,
                serviceType: 'PerItem',
                onAddItem: onAddItem,
              )
              ).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(dynamic service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
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
            '${itemsLaundry.length} mục',
            style: TextStyle(
              color: primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyItemMessage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        emptyItemMessage,
        style: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAdditionalServicesSection() {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdditionalServicesHeader(),
            const SizedBox(height: 8),
            ...additionalService.map((service) {
              return Column(
                children: [
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name ?? "Dịch vụ không tên",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        CurrencyDisplay(
                          price: service.price,
                          fontSize: 16,
                          iconSize: 16,
                        ),
                      ],
                    ),
                    value: selectedServiceId.contains(service.id),
                    onChanged: (bool? newValue) {
                      setState(() {
                        if (newValue == true) {
                          selectedServiceId.add(service.id);
                          additionalServicePrice += service.price ?? 0;
                        } else {
                          selectedServiceId.remove(service.id);
                          additionalServicePrice -= service.price ?? 0;
                        }
                        _updateTotalPrice(); // Cập nhật lại tổng giá sau khi thay đổi
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Colors.green,
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 8,
                  ),
                ],
              );
            }).toList(),
          ],
        ));
  }

  Widget _buildAdditionalServicesHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            additionalServicesTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 18,
            ),
          ),
          Text(
            'Đã chọn: ${selectedServiceId.length}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        onPressed: !isLoading ? _placeOrder : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          orderButtonText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: appBarTitle,
        onBackPressed: () => AppRouter.navigateToHome(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    if (isLoading)
                      _buildLoadingIndicator()
                    else if (laundryServiceType.isEmpty)
                      Center(
                        child: Text(
                          emptyServiceMessage,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children:
                        laundryServiceType.map(_buildServiceItem).toList(),
                      ),
                    if (!isLoading) _buildAdditionalServicesSection(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTotalPriceWidget(),
                    BlocListener<LaundryOrderBloc, LaundryOrderState>(
                      listener: (context, state) {
                        if (state is CreateLaundrySuccess) {
                          orderDetails.clear();
                          selectedServiceId.clear();
                          AppRouter.navigateToLaundryOrderDetail(
                              state.order.id ?? '');
                        } else if (state is LaundryOrderFailure) {
                          _showErrorDialog(orderCreationError);
                        }
                      },
                      child: _buildOrderButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}