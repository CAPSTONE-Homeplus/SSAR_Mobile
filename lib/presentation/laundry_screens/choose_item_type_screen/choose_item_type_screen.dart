import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../data/laundry_repositories/laundry_order_repo.dart';
import '../../../domain/entities/laundry_item_type/laundry_item_type.dart';
import '../../blocs/additional_service/additional_service_bloc.dart';
import '../../blocs/additional_service/additional_service_event.dart';
import '../../blocs/additional_service/additional_service_state.dart';
import '../../blocs/laundry_item_type/laundry_item_type_bloc.dart';
import '../../blocs/laundry_item_type/laundry_item_type_event.dart';
import '../../blocs/laundry_item_type/laundry_item_type_state.dart';
import '../../laundry_blocs/order/laundry_order_bloc.dart';
import '../../laundry_blocs/order/laundry_order_event.dart';
import '../../widgets/currency_display.dart';
import '../../widgets/show_dialog.dart';

class ChooseItemTypeScreen extends StatefulWidget {
  final String serviceId;

  const ChooseItemTypeScreen({Key? key, required this.serviceId})
      : super(key: key);

  @override
  State<ChooseItemTypeScreen> createState() => _ChooseItemTypeScreenState();
}

class _ChooseItemTypeScreenState extends State<ChooseItemTypeScreen> {
  late AdditionalServiceBloc _additionalServiceBloc;
  List<dynamic> additionalService = [];
  Map<String, int> _itemQuantities = {};
  List<String> selectedServiceId = [];
  bool isLoading = true;
  final List<OrderDetailsRequest> orderDetails = [];
  final Map<String, String> categoryIcons = {
    'All': 'assets/icons/all.png',
    'Shirt': 'assets/icons/shirt.png',
    'Skirt': 'assets/icons/skirt.png',
    'Towel': 'assets/icons/towel.png',
    'Set': 'assets/icons/set.png',
  };
  String? _selectedCategory;

  // Method to update quantity
  void _updateQuantity(LaundryItemType itemType, int change) {
    setState(() {
      final key = itemType.id?.toString() ?? itemType.name ?? 'unknown';
      _itemQuantities[key] = (_itemQuantities[key] ?? 0) + change;

      // Ensure quantity doesn't go below zero
      if (_itemQuantities[key]! < 0) {
        _itemQuantities[key] = 0;
      }
    });
  }

  // Build quantity counter for a specific item type
  Widget _buildQuantityCounter(LaundryItemType itemType) {
    final key = itemType.id?.toString() ?? itemType.name ?? 'unknown';
    final quantity = _itemQuantities[key] ?? 0;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: itemType.imageUrl ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemType.name ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CurrencyDisplay(
                  price: itemType.pricePerItem,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _updateQuantity(itemType, -1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[200],
                  child: Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _updateQuantity(itemType, 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Fetch Laundry Item Types
    context.read<LaundryItemTypeBloc>().add(
          GetLaundryItemTypeByService(widget.serviceId),
        );

    // Setup Additional Service Bloc
    _additionalServiceBloc = context.read<AdditionalServiceBloc>();
    _additionalServiceBloc.add(FetchAdditionalService());

    // Listen to Laundry Item Type Bloc
    context.read<LaundryItemTypeBloc>().stream.listen((state) {
      if (state is LaundryItemTypeLoaded) {
        _checkLoadingStatus();
      }
    });

    // Listen to Additional Service Bloc
    _additionalServiceBloc.stream.listen((state) {
      if (state is AdditionalServiceLoaded) {
        setState(() {
          additionalService = state.services.items;
          _checkLoadingStatus();
        });
      }
    });
  }

  void _checkLoadingStatus() {
    final laundryItemTypeState = context.read<LaundryItemTypeBloc>().state;
    final additionalServiceState = _additionalServiceBloc.state;

    setState(() {
      isLoading = !(laundryItemTypeState is LaundryItemTypeLoaded &&
          additionalServiceState is AdditionalServiceLoaded);
    });
  }

  void _placeOrder() {
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

  Widget _buildPriceOnly(LaundryItemType itemType) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giặt ${itemType.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Giá 1 kg'),
              CurrencyDisplay(
                price: itemType.pricePerKg,
                fontSize: 16,
                iconSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: "Giặt sấy",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<LaundryItemTypeBloc, LaundryItemTypeState>(
        builder: (context, state) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (state is LaundryItemTypeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade300,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lỗi: ${state.message}',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is LaundryItemTypeLoaded) {
            final filteredItems = _selectedCategory == null
                ? state.laundryItemTypes.items
                : state.laundryItemTypes.items
                    .where((item) => item.category == _selectedCategory)
                    .toList();
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (filteredItems
                          .any((itemType) => itemType.serviceType != "PerKg"))
                        _buildCategorySelector(state.laundryItemTypes.items),
                      Container(
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
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chọn loại đồ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...filteredItems.map(
                              (itemType) => itemType.serviceType == "PerKg"
                                  ? _buildPriceOnly(itemType)
                                  : _buildQuantityCounter(itemType),
                            ),
                          ],
                        ),
                      ),
                      _buildAdditionalServicesSection(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedItems =
                                state.laundryItemTypes.items.where((itemType) {
                              final key = itemType.id?.toString() ??
                                  itemType.name ??
                                  'unknown';
                              return (_itemQuantities[key] ?? 0) > 0;
                            }).toList();

                            if (selectedItems.isNotEmpty) {}
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tiếp theo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Text(
              'Không có dữ liệu',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getUniqueCategories(List<LaundryItemType> items) {
    return items
        .map((item) => item.category ?? '')
        .toSet()
        .toList()
        .where((category) => category.isNotEmpty)
        .toList();
  }

  Widget _buildCategorySelector(List<LaundryItemType> items) {
    // Get unique categories
    final uniqueCategories = _getUniqueCategories(items);
    uniqueCategories.insert(0, 'All'); // Add 'All' category at the beginning

    return SizedBox(
      height: 100, // Adjust as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: uniqueCategories.length,
        itemBuilder: (context, index) {
          final category = uniqueCategories[index];
          final iconPath =
              categoryIcons[category] ?? 'assets/icons/default.png';

          return GestureDetector(
            onTap: () {
              setState(() {
                if (category == 'All') {
                  // If 'All' is selected, reset to show all items
                  _selectedCategory = null;
                } else {
                  // Toggle between selected category and null
                  _selectedCategory =
                      _selectedCategory == category ? null : category;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (_selectedCategory == null && category == 'All') ||
                              _selectedCategory == category
                          ? AppColors.primaryColor.withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        iconPath,
                        width: 36,
                        height: 36,
                        color:
                            (_selectedCategory == null && category == 'All') ||
                                    _selectedCategory == category
                                ? AppColors.primaryColor
                                : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: (_selectedCategory == null && category == 'All') ||
                              _selectedCategory == category
                          ? AppColors.primaryColor
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
                        } else {
                          selectedServiceId.remove(service.id);
                        }
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
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
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
              color: Colors.black,
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
}
