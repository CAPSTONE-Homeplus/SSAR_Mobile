import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';
import 'package:home_clean/domain/entities/option/option.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_bloc.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_event.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_state.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_bloc.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_event.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_state.dart';
import 'package:home_clean/presentation/blocs/option/option_event.dart';
import 'package:home_clean/presentation/blocs/option/option_state.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_event.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_state.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_event.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_state.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/size_config.dart';
import '../../../core/format/formater.dart';
import '../../../domain/entities/house/house.dart';
import '../../../domain/entities/order/create_order.dart';
import '../../../domain/entities/service_activity/service_activity.dart';
import '../../../domain/entities/service_in_house_type/house_type.dart';
import '../../../domain/entities/time_slot/time_slot.dart';
import '../../blocs/house/house_bloc.dart';
import '../../blocs/option/option_bloc.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service_in_house_type/service_price_bloc.dart';
import '../../blocs/service_in_house_type/service_price_event.dart';
import '../../blocs/service_in_house_type/service_price_state.dart';
import '../../blocs/time_slot/time_slot_bloc.dart';
import '../../blocs/time_slot/time_slot_event.dart';
import '../../blocs/time_slot/time_slot_state.dart';
import '../../widgets/currency_display.dart';
import '../../widgets/step_indicator_widget.dart';
import '../../widgets/time_drop_down.dart';

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailArguments? arguments;

  ServiceDetailScreen({super.key, required this.arguments});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceInHouseType _servicePriceType = ServiceInHouseType(
    id: '',
    name: '',
    price: 0,
    serviceId: '',
  );
  House? house;
  final List<Option> _selectedOptions = [];
  final List<ExtraService> _selectedExtraServices = [];
  List<Option> _options = [];
  List<ExtraService> _extraServices = [];
  List<EquipmentSupply> _supplies = [];
  bool isLoading = true;
  final Map<String, List<SubActivity>> _serviceActivities = {};
  int _totalPrice = 0;
  List<TimeSlot> timeSlots = [];
  late TimeSlot _selectedTimeSlot = TimeSlot(
      id: '',
      startTime: '',
      endTime: '',
      description: '',
      status: '',
      code: '');
  final TextEditingController _notesController = TextEditingController();
  Service service = Service(
    id: '',
    name: '',
    description: '',
  );

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    fetchService().then((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = true;
      });

      fetchHouse();

      context.read<ServicePriceBloc>().add(
            GetServicePrice(
              houseId: house?.id ?? '',
              serviceId: service.id ?? '',
            ),
          );

      // Dispatch events to fetch data
      context.read<ServiceActivityBloc>().add(
            GetServiceActivitiesByServiceIdEvent(serviceId: service.id ?? ''),
          );
      context
          .read<OptionBloc>()
          .add(GetOptionsEvent(serviceId: service.id ?? ''));
      context.read<ExtraServiceBloc>().add(
            GetExtraServices(serviceId: service.id ?? ''),
          );
      context.read<EquipmentSupplyBloc>().add(
            GetEquipmentSupplies(serviceId: service.id ?? ''),
          );
      context.read<TimeSlotBloc>().add(GetTimeSlotEvents());
    });
  }

  void fetchHouse() {
    final houseBloc = context.read<HouseBloc>();
    house = houseBloc.cachedHouse;
  }

  Future<void> fetchService() async {
    final serviceBloc = context.read<ServiceBloc>();
    serviceBloc.add(GetServiceByIdEvent(widget.arguments?.serviceId ?? ''));

    final state = await serviceBloc.stream
        .firstWhere((state) => state is GetServiceByIdState);
    if (state is GetServiceByIdState) {
      setState(() {
        service = state.service;
      });
    }
  }

  void _handleCreateOrder(bool isEmergency) {
    final createOrder = CreateOrder(
      service: service,
      option: _selectedOptions,
      extraService: _selectedExtraServices,
      timeSlot: isEmergency
          ? TimeSlot(startTime: "", endTime: "")
          : _selectedTimeSlot,
      notes: _notesController.text,
      emergencyRequest: isEmergency,
      address: '',
    );
    AppRouter.navigateToOrderConfirmation(
      createOrder,
      reOrderId: widget.arguments?.orderIdToReOrder,
      staff: widget.arguments?.staff,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServiceActivityBloc, ServiceActivityState>(
          listener: (context, state) {
            if (state is ServiceActivitySuccessState) {
              _handleServiceActivitiesLoaded(state.serviceActivities);
            }
          },
        ),
        BlocListener<OptionBloc, OptionState>(
          listener: (context, state) {
            if (state is OptionSuccessState) {
              setState(() {
                _options = state.options;
                _checkAllDataLoaded();
              });
            }
          },
        ),
        BlocListener<ExtraServiceBloc, ExtraServiceState>(
          listener: (context, state) {
            if (state is ExtraServiceSuccessState) {
              setState(() {
                _extraServices = state.extraServices.items;
                _checkAllDataLoaded();
              });
            }
          },
        ),
        BlocListener<EquipmentSupplyBloc, EquipmentSupplyState>(
          listener: (context, state) {
            if (state is EquipmentSupplySuccessState) {
              setState(() {
                _supplies = state.equipmentSupplies.items;
                _checkAllDataLoaded();
              });
            }
          },
        ),
        BlocListener<TimeSlotBloc, TimeSlotState>(
          listener: (context, state) {
            if (state is TimeSlotLoaded) {
              setState(() {
                timeSlots = state.timeSlots;
                _checkAllDataLoaded();
              });
            }
          },
        ),
        BlocListener<ServicePriceBloc, ServicePriceState>(
          listener: (context, state) {
            if (state is ServicePriceLoaded) {
              setState(() {
                _totalPrice = state.servicePrice.price!;
                _servicePriceType = state.servicePrice;
              });
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: CustomAppBar(
            title: (widget.arguments?.orderIdToReOrder != null
                    ? 'Order lại - '
                    : '') +
                (service.name ?? ''),
            onBackPressed: () {
              AppRouter.navigateToHome();
            },
          ),
          body: isLoading
              ? _loadingPlaceholder()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      StepIndicatorWidget(currentStep: 2),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // _buildServiceSupply(),
                            // SizedBox(height: 10),
                            _buildOriginCost(),
                            SizedBox(height: 10),
                            _buildAdditionalOptionsSection(),
                            SizedBox(height: 10),
                            _buildExtraService(),
                            SizedBox(height: 10),
                            _buildJobDetailsSection(),
                            SizedBox(height: 10),
                            _buildNotesField(),
                            if (widget.arguments?.staff != null) ...[
                              SizedBox(height: 10),
                              _buildEmployee(),
                            ],
                            SizedBox(height: 10),
                            _build(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: _buildBottomBar(),
        ),
      ),
    );
  }

  Future<void> _handleServiceActivitiesLoaded(
      List<ServiceActivity> activities) async {
    Map<String, List<SubActivity>> tempSubActivities = {};

    for (var activity in activities) {
      final key = activity.name ?? '';
      if (!tempSubActivities.containsKey(key)) {
        tempSubActivities[key] = [];
      }

      final subActivityBloc = context.read<SubActivityBloc>();
      subActivityBloc.add(GetSubActivities(activityId: activity.id ?? ''));

      await for (final subState in subActivityBloc.stream) {
        if (subState is SubActivitySuccessState) {
          if (mounted) {
            tempSubActivities[key]!.addAll(subState.subActivities);
            break;
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _serviceActivities.addAll(tempSubActivities);
        _checkAllDataLoaded();
      });
    }
  }

  void _checkAllDataLoaded() {
    // if (_serviceActivities.isNotEmpty &&
    if (    _options.isNotEmpty &&
        _extraServices.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _loadingPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1CAF7D), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  // Widget _buildServiceSupply() {
  //   return _buildSection(title: "Công cụ", icon: Icons.cleaning_services, child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       GestureDetector(
  //         onTap: _showToolsList,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.grey[100],
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.grey, width: 1),
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Danh sách dụng cụ',
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),);
  // }

  // void _showToolsList() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Danh sách dụng cụ',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //             SizedBox(height: 12),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 physics: BouncingScrollPhysics(),
  //                 child: Wrap(
  //                   spacing: 8,
  //                   runSpacing: 8,
  //                   children: _supplies.map((tool) {
  //                     return SizedBox(
  //                       width: (MediaQuery.of(context).size.width - 48) / 3,
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             height: 150,
  //                             width: double.infinity,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(8),
  //                               color: Colors.grey[200],
  //                             ),
  //                             child: tool.urlImage != null
  //                                 ? ClipRRect(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                     child: Image.network(
  //                                       tool.urlImage!,
  //                                       fit: BoxFit.cover,
  //                                       errorBuilder:
  //                                           (context, error, stackTrace) {
  //                                         return Center(
  //                                           child: Icon(
  //                                             Icons.image_not_supported,
  //                                             size: 48,
  //                                             color: Colors.grey,
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                                   )
  //                                 : Center(
  //                                     child: Icon(
  //                                       Icons.image_not_supported,
  //                                       size: 48,
  //                                       color: Colors.grey,
  //                                     ),
  //                                   ),
  //                           ),
  //                           SizedBox(height: 8),
  //                           Text(
  //                             tool.name ?? 'Unnamed Tool',
  //                             textAlign: TextAlign.center,
  //                             style: GoogleFonts.poppins(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 14,
  //                               color: Colors.black87,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 12),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Color(0xFF1CAF7D),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'Đóng',
  //                   style: GoogleFonts.poppins(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildAdditionalOptionsSection() {
    return _buildSection(
      title: "Tùy chọn thêm",
      icon: Icons.add_reaction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_options.isEmpty)
            Center(
              child: Text(
                'Không có tùy chọn thêm nào',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            _buildOption(),
        ],
      ),
    );
  }

  Widget _buildOption() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          return Column(
            children: [
              CheckboxListTile(
                title: Text(
                  option.name ?? 'Unnamed Option',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: CurrencyDisplay(
                  price: option.price,
                  fontSize: 14,
                  iconSize: 16,
                  unit: '',
                ),
                value: _selectedOptions.contains(option),
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
                tileColor: Colors.grey[100],
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedOptions.add(option);
                      _totalPrice += option.price ?? 0;
                    } else {
                      _selectedOptions.remove(option);
                      _totalPrice -= option.price ?? 0;
                    }
                  });
                },
              ),
              if (index != _extraServices.length - 1)
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOriginCost() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, -3),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề rõ ràng về loại căn hộ
          Text(
            'Thông Tin Dịch Vụ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Chi tiết loại căn hộ
          Row(
            children: [
              Icon(
                Icons.home_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại Căn Hộ',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _servicePriceType.houseTypeDescription ?? 'Chưa xác định',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 16, thickness: 0.5),

          // Chi tiết dịch vụ và giá
          Row(
            children: [
              Icon(
                Icons.clean_hands_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dịch Vụ',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      service.name ?? 'Chưa xác định',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 16, thickness: 0.5),

          // Giá tiền
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đơn Giá',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    CurrencyDisplay(
                      price: _servicePriceType.price,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
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

  Widget _buildExtraService() {
    return _buildSection(
      title: "Dịch vụ thêm",
      icon: Icons.add,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_extraServices.isEmpty)
            Center(
              child: Text(
                'Không có dịch vụ thêm nào',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            _buildExtra(),
        ],
      ),
    );
  }

  Widget _buildExtra() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _extraServices.asMap().entries.map((entry) {
          final index = entry.key;
          final extra = entry.value;

          return Column(
            children: [
              CheckboxListTile(
                title: Text(
                  extra.name ?? 'Unnamed Option',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: CurrencyDisplay(
                  price: extra.price,
                  fontSize: 14,
                  iconSize: 16,
                  unit: '',
                ),
                value: _selectedExtraServices.contains(extra),
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
                tileColor: Colors.grey[100],
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedExtraServices.add(extra);
                      _totalPrice += extra.price ?? 0;
                    } else {
                      _selectedExtraServices.remove(extra);
                      _totalPrice -= extra.price ?? 0;
                    }
                  });
                },
              ),
              if (index != _extraServices.length - 1)
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobDetailsSection() {
    return _buildSection(
      title: "Chi tiết công việc",
      icon: Icons.work,
      child: DefaultTabController(
        length: _serviceActivities.length, // Số lượng tab
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_serviceActivities.isEmpty)
              Center(
                child: Text(
                  'Không có hoạt động nào',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorColor: const Color(0xFF1CAF7D),
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: _serviceActivities.keys
                        .map((key) =>
                            Tab(text: key.isNotEmpty ? key : 'Unnamed'))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: _serviceActivities.entries.map((entry) {
                        final key = entry.key;
                        final subActivities = entry.value;

                        return ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.assignment_outlined,
                                  color: Color(0xFF1CAF7D),
                                ),
                                title: Text(
                                  key.isNotEmpty ? key : 'Unnamed Activity',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            // Hiển thị luôn phần nội dung mở rộng
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: subActivities.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final subActivity = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Text("${index + 1}:"),
                                          const SizedBox(width: 8),
                                          Text(
                                            subActivity.name ??
                                                'Unnamed Sub-Activity',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return _buildSection(
      title: "Ghi chú",
      icon: Icons.notes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _notesController,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'Nhập ghi chú',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployee() {
    final staff = widget.arguments?.staff;

    return _buildSection(
      title: "Nhân viên được bạn yêu cầu",
      icon: Icons.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (staff != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${staff.fullName ?? 'Chưa có tên'}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.blueGrey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Mã nhân viên: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: staff.code ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  staff.phoneNumber ?? 'Chưa có số điện thoại',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          else
            Text(
              'Chưa có nhân viên nào được chỉ định',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.27,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, -3),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              width: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              height: 24,
              width: 150,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 40,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _build() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Chọn thời gian',
                  style: GoogleFonts.poppins(
                    fontSize: 18 * SizeConfig.ffem,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Divider for visual separation
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TimeSelector(
              selectedSlot: _selectedTimeSlot,
              availableSlots: timeSlots,
              onSlotChanged: (newValue) {
                setState(() {
                  _selectedTimeSlot = newValue;
                });
              },
            ),
          ),

          // Note section at the bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Nếu bạn muốn đặt khung giờ khác, vui lòng chọn từ danh sách trên.',
                    style: GoogleFonts.poppins(
                      fontSize: 12 * SizeConfig.ffem,
                      color: Colors.grey[600],
                      height: 1.3,
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

  Widget _buildBottomBar() {
    return isLoading
        ? _buildShimmerLoading()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFF7FFFC),
                    border: Border.all(color: const Color(0xFFE0F5EF)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng cộng',
                            style: GoogleFonts.poppins(
                              fontSize: 13 * SizeConfig.ffem,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          CurrencyDisplay(
                            price: _totalPrice,
                            fontSize: 18,
                            iconSize: 16,
                            unit: '',
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1CAF7D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Đã bao gồm VAT',
                          style: TextStyle(
                            fontSize: 11 * SizeConfig.ffem,
                            color: const Color(0xFF1CAF7D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Action buttons with improved styling
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        title: 'Đặt ngay',
                        icon: Icons.flash_on,
                        isEmergency: true,
                        onPressed: () {
                          _handleCreateOrder(true);
                        },
                      ),
                    ),
                    SizedBox(width: 10 * SizeConfig.hem),
                    Expanded(
                      child: _buildActionButton(
                        title: 'Đặt theo giờ',
                        icon: Icons.schedule,
                        isEmergency: false,
                        onPressed: () {
                          if (_selectedTimeSlot.id == '') {
                            _showErrorDialog(context,
                                'Vui lòng chọn khung giờ trước khi đặt.');
                          } else {
                            _handleCreateOrder(false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

// Improved action button with gradient and animation
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required bool isEmergency,
    required VoidCallback onPressed,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: isEmergency
                  ? [const Color(0xFF1CAF7D), const Color(0xFF0D9268)]
                  : [Colors.white, Colors.white],
            ),
            border:
                isEmergency ? null : Border.all(color: const Color(0xFF1CAF7D)),
            boxShadow: isEmergency
                ? [
                    BoxShadow(
                      color: const Color(0xFF1CAF7D).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isEmergency ? Colors.white : const Color(0xFF1CAF7D),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: isEmergency ? Colors.white : const Color(0xFF1CAF7D),
                  fontWeight: FontWeight.w600,
                  fontSize: 14 * SizeConfig.ffem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
