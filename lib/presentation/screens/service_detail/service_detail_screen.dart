import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
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

import '../../blocs/option/option_bloc.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final List<String> _selectedOptions = [];
  final List<String> _selectedExtraServices = [];
  List<Option> _options = [];
  List<ExtraService> _extraServices = [];
  List<EquipmentSupply> _supplies = [];
  late ServiceActivityBloc _serviceActivityBloc;
  late OptionBloc _optionBloc;
  late ExtraServiceBloc _extraServiceBloc;
  late EquipmentSupplyBloc _equipmentSupplyBloc;
  bool isLoading = true;
  final Map<String, List<SubActivity>> _serviceActivities = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });

        // Init blocs
        _serviceActivityBloc = context.read<ServiceActivityBloc>();
        _optionBloc = context.read<OptionBloc>();
        _extraServiceBloc = context.read<ExtraServiceBloc>();
        _equipmentSupplyBloc = context.read<EquipmentSupplyBloc>();

        // Fetch service events
        _serviceActivityBloc.add(
          GetServiceActivitiesByServiceIdEvent(
              serviceId: widget.service.id ?? ''),
        );
        _optionBloc.add(GetOptionsEvent(serviceId: widget.service.id ?? ''));
        _extraServiceBloc.add(
          GetExtraServices(serviceId: widget.service.id ?? ''),
        );
        _equipmentSupplyBloc.add(
          GetEquipmentSupplies(serviceId: widget.service.id ?? ''),
        );

        // Process events
        final serviceActivityComplete = _processServiceActivities();
        final extraServiceComplete = _processExtraServices();
        final optionComplete = _processOptions();
        final supplyComplete = _processSupplies();

        // Wait for all events to complete
        await Future.wait([
          serviceActivityComplete,
          extraServiceComplete,
          optionComplete,
          supplyComplete,
        ]);

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _processServiceActivities() async {
    await for (final state in _serviceActivityBloc.stream) {
      if (state is ServiceActivitySuccessState && mounted) {
        Map<String, List<SubActivity>> tempSubActivities = {};

        for (var activity in state.serviceActivities) {
          final key = activity.name ?? '';
          if (!tempSubActivities.containsKey(key)) {
            tempSubActivities[key] = [];
          }

          final subActivityBloc = context.read<SubActivityBloc>();
          subActivityBloc.add(GetSubActivities(activityId: activity.id ?? ''));

          await subActivityBloc.stream.firstWhere((subState) {
            if (subState is SubActivitySuccessState) {
              tempSubActivities[key]!.addAll(subState.subActivities);
              return true;
            }
            return false;
          });
        }

        setState(() {
          _serviceActivities.addAll(tempSubActivities);
        });
        break;
      }
    }
  }

  Future<void> _processExtraServices() async {
    await for (final state in _extraServiceBloc.stream) {
      if (state is ExtraServiceSuccessState && mounted) {
        setState(() {
          _extraServices = state.extraServices;
        });
        break;
      }
    }
  }

  Future<void> _processOptions() async {
    await for (final state in _optionBloc.stream) {
      if (state is OptionSuccessState && mounted) {
        setState(() {
          _options = state.options;
        });
        break;
      }
    }
  }

  Future<void> _processSupplies() async {
    await for (final state in _equipmentSupplyBloc.stream) {
      if (state is EquipmentSupplySuccessState && mounted) {
        setState(() {
          _supplies = state.equipmentSupplies;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(
          title: widget.service.name ?? '',
          onBackPressed: () {
            Navigator.pop(context);
          }),
      body: isLoading
          ? _loadingPlaceholder()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceSupply(),
                    SizedBox(height: 8),
                    _buildAdditionalOptionsSection(),
                    SizedBox(height: 8),
                    _buildExtraService(),
                    SizedBox(height: 8),
                    _buildJobDetailsSection(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
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

  Widget _buildServiceSupply() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Các công cụ',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _showToolsList,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách dụng cụ',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToolsList() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách dụng cụ',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _supplies.map((tool) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 3,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: tool.urlImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        tool.urlImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              tool.name ?? 'Unnamed Tool',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1CAF7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Đóng',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tùy chọn thêm',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
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
                subtitle: Text(
                  option.price != null ? '+${option.price} VND' : '',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
                value: _selectedOptions.contains(option.id),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedOptions.add(option.id ?? '');
                    } else {
                      _selectedOptions.remove(option.id);
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

  Widget _buildExtraService() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dịch vụ thêm',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
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
                subtitle: Text(
                  extra.price != null ? '+${extra.price} VND' : '',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
                value: _selectedExtraServices.contains(extra.id),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedExtraServices.add(extra.id ?? '');
                    } else {
                      _selectedExtraServices.remove(extra.id);
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
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTabController(
          length: _serviceActivities.length, // Số lượng tab
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chi tiết công việc',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
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
                                    Icons.check_circle_outline,
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
                                  children: subActivities
                                      .map(
                                        (subActivity) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.grey,
                                              ),
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
                                        ),
                                      )
                                      .toList(),
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
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Xử lý sự kiện onTap ở đây
              print("Total tapped");
            },
            child: Text(
              'Total: 200,000 VND',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AppRouter.navigateToTimeCollection();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CAF7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
